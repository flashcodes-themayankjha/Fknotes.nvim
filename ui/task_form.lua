
local M = {}
local storage = require("fknotes.core.storage")

function M.open()
  local buf = vim.api.nvim_create_buf(false, true)
  local lines = {
    "Create New Task",
    "",
    "Title: ",
    "Description: ",
    "Due Date: "
  }

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(buf, "modifiable", true)

  local width, height = 50, #lines + 2
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = (vim.o.lines - height) / 2,
    col = (vim.o.columns - width) / 2,
    style = "minimal",
    border = "rounded",
  })

  vim.api.nvim_buf_set_option(buf, "modifiable", true)
  vim.api.nvim_win_set_cursor(win, {3, 7}) -- Move to start of Title input

  vim.keymap.set("n", "<CR>", function()
    local content = vim.api.nvim_buf_get_lines(buf, 3, 6, false)

    local function safe_sub(line, start)
      if not line then return "" end
      return line:sub(start)
    end

    local task = {
      title = safe_sub(content[1], 8),
      description = safe_sub(content[2], 14),
      due = safe_sub(content[3], 11),
    }

    if task.title == "" then
      print("❌ Title is required")
      return
    end

    local tasks = storage.load_tasks()
    table.insert(tasks, task)
    storage.save_tasks(tasks)

    vim.api.nvim_win_close(win, true)
    print("✅ Task saved!")
  end, { buffer = buf })
end

return M
