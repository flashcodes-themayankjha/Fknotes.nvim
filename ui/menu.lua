
local M = {}

function M.open()
  local lines = {
    "🌟 FKNotes Menu 🌟",
    "",
    "1. ➕ Create a New Task",
    "2. 📋 View Task List",
    "",
    "Press the number to select an option. Press 'q' to quit."
  }

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)

  local width = 40
  local height = #lines
  local row = (vim.o.lines - height) / 2
  local col = (vim.o.columns - width) / 2

  vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    style = "minimal",
    border = "rounded",
    row = row,
    col = col,
    width = width,
    height = height,
  })

  -- Keybindings
  vim.api.nvim_buf_set_keymap(buf, 'n', '1', [[:lua require("fknotes.ui.task_form").open()<CR>]], { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', '2', [[:lua require("fknotes.ui.task_browser").open()<CR>]], { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', 'q', ':bd!<CR>', { noremap = true, silent = true })
end

return M
