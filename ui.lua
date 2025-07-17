
local storage = require("fknotes.storage")
local config = require("fknotes.config")
local M = {}

local ns = vim.api.nvim_create_namespace("fknotes")

-- Helper to calculate relative centered window
local function center_win(width, height)
  return {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = "rounded"
  }
end

local function format_todo(todo)
  local status = todo.done and "[✔]" or "[ ]"
  local date = todo.due
  return string.format("%s %s (Due: %s)", status, todo.title, date)
end

-- Compute color based on due date
local function get_due_color(due, done)
  if done then return "TodoDone" end

  local due_time = os.time({ year = tonumber(due:sub(1, 4)), month = tonumber(due:sub(6, 7)), day = tonumber(due:sub(9, 10)) })
  local now = os.time()
  local diff = math.floor((due_time - now) / (60 * 60 * 24))

  if diff < 0 then return "TodoOverdue"
  elseif diff <= 2 then return "TodoSoon"
  else return "Normal" end
end

-- Highlight groups
vim.cmd([[
  highlight TodoDone guifg=#5faf5f
  highlight TodoSoon guifg=#ffaf00
  highlight TodoOverdue guifg=#ff5f5f
]])

function M.open_dashboard()
  local todos = storage.load_todos()
  local lines = { "📝 FKNotes", "────────────────────────────", "[+] Create New To-Do" }
  local highlights = { "Title", "", "Normal" }

  for _, todo in ipairs(todos) do
    table.insert(lines, format_todo(todo))
  end

  local width = 50
  local height = #lines + 2
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  local win = vim.api.nvim_open_win(buf, true, center_win(width, height))

  -- Apply highlight colors per line
  for i = 4, #lines do
    local todo = todos[i - 3]
    if todo then
      local hl = get_due_color(todo.due, todo.done)
      vim.api.nvim_buf_add_highlight(buf, ns, hl, i - 1, 0, -1)
    end
  end

  local cursor = 3

  local function redraw_cursor()
    for i = 1, #lines do
      vim.api.nvim_buf_clear_namespace(buf, ns, i - 1, i)
    end

    vim.api.nvim_buf_add_highlight(buf, ns, "Visual", cursor - 1, 0, -1)
  end

  redraw_cursor()

  vim.keymap.set("n", "<CR>", function()
    if cursor == 3 then
      vim.api.nvim_win_close(win, true)
      M.create_todo_form()
    else
      local index = cursor - 3
      todos[index].done = not todos[index].done
      storage.save_todos(todos)
      vim.api.nvim_win_close(win, true)
      M.open_dashboard()
    end
  end, { buffer = buf })

  vim.keymap.set("n", "j", function()
    if cursor < #lines then
      cursor = cursor + 1
      vim.api.nvim_win_set_cursor(win, { cursor, 0 })
      redraw_cursor()
    end
  end, { buffer = buf })

  vim.keymap.set("n", "k", function()
    if cursor > 3 then
      cursor = cursor - 1
      vim.api.nvim_win_set_cursor(win, { cursor, 0 })
      redraw_cursor()
    end
  end, { buffer = buf })
end

function M.create_todo_form()
  local buf = vim.api.nvim_create_buf(false, true)
  local width, height = 50, 8

  local lines = {
    "Create New To-Do",
    "",
    "Title: ",
    "Due (YYYY-MM-DD): ",
    "",
    "[Enter] Save | [Esc] Cancel"
  }

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  local win = vim.api.nvim_open_win(buf, true, center_win(width, height))

  local input = { title = "", due = "" }

  vim.api.nvim_buf_add_highlight(buf, ns, "Title", 0, 0, -1)

  vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", "", {
    callback = function()
      vim.api.nvim_win_close(win, true)
    end,
    noremap = true,
    silent = true
  })

  vim.api.nvim_buf_set_keymap(buf, "n", "<CR>", "", {
    callback = function()
      input.title = vim.fn.input("Title: ")
      input.due = vim.fn.input("Due (YYYY-MM-DD): ")
      if input.title ~= "" and input.due:match("^%d%d%d%d%-%d%d%-%d%d$") then
        local todos = storage.load_todos()
        table.insert(todos, {
          title = input.title,
          due = input.due,
          done = false
        })
        storage.save_todos(todos)
        vim.api.nvim_win_close(win, true)
        M.open_dashboard()
      else
        print("Invalid input")
      end
    end,
    noremap = true,
    silent = true
  })
end

return M
