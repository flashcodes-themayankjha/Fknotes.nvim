local M = {}

function M.open()
  local buf = vim.api.nvim_create_buf(false, true)

  local menu_lines = {
    "FKTODO MENU",
    "",
    "1. Create Task",
    "2. Browse Tasks",
    "3. Exit"
  }

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, menu_lines)
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)

  local width = 30
  local height = #menu_lines
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

  -- Simple key mappings for demo
  vim.api.nvim_buf_set_keymap(buf, 'n', '1', [[:lua require("fknotes.ui.task_form").new_task()<CR>]], { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', '3', ':bd!<CR>', { noremap = true, silent = true }) -- Exit
end

return M

