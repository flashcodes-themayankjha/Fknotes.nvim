local M = {}

local input_fields = {
  { label = "Title: ", value = "" },
  { label = "Due Date (YYYY-MM-DD): ", value = "" },
  { label = "Priority (High/Medium/Low): ", value = "" },
}

-- Save task to file (placeholder, real logic will go to storage.lua)
local function save_task(task)
  vim.notify("✅ Task saved:\n" .. vim.inspect(task), vim.log.levels.INFO)
end

function M.new_task()
  local buf = vim.api.nvim_create_buf(false, true)

  local lines = {}
  for _, field in ipairs(input_fields) do
    table.insert(lines, field.label .. field.value)
  end
  table.insert(lines, "")
  table.insert(lines, "[Press <Enter> to Save | <Esc> to Cancel]")

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(buf, "modifiable", true)
  vim.api.nvim_buf_set_option(buf, "filetype", "fknotes_task")

  local width = 50
  local height = #lines
  local opts = {
    style = "minimal",
    relative = "editor",
    width = width,
    height = height,
    row = (vim.o.lines - height) / 2,
    col = (vim.o.columns - width) / 2,
    border = "rounded",
  }

  local win = vim.api.nvim_open_win(buf, true, opts)

  local current_field = 1

  vim.api.nvim_buf_set_keymap(buf, "i", "<CR>", "", {
    noremap = true,
    callback = function()
      -- Read the current input values from buffer
      for i, field in ipairs(input_fields) do
        local line = vim.api.nvim_buf_get_lines(buf, i - 1, i, false)[1]
        input_fields[i].value = line:sub(#field.label + 1)
      end

      local task = {
        title = input_fields[1].value,
        due = input_fields[2].value,
        priority = input_fields[3].value,
        status = "pending",
        subtasks = {},
      }

      vim.api.nvim_win_close(win, true)
      save_task(task)
    end,
  })

  vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", "", {
    noremap = true,
    callback = function()
      vim.api.nvim_win_close(win, true)
    end,
  })

  vim.api.nvim_set_current_win(win)
  vim.cmd("startinsert!")
end

return M

