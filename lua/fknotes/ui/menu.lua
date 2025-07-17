local M = {}

function M.open()
  local buf = vim.api.nvim_create_buf(false, true)

  local menu_lines = {
    "  🔹 FKTASK MENU 🔹",
    "",
    "  1. ➕ Create Task",
    "  2. 📋 Browse Tasks",
    "  3. ❌ Exit",
  }

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, menu_lines)
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)
  vim.api.nvim_buf_set_option(buf, 'buftype', 'prompt')
  vim.api.nvim_buf_set_option(buf, 'filetype', 'fknotes_menu')

  local width = 40
  local height = #menu_lines
  local win_opts = {
    style = "minimal",
    relative = "editor",
    width = width,
    height = height,
    row = (vim.o.lines - height) / 2,
    col = (vim.o.columns - width) / 2,
    border = "rounded",
  }

  local win = vim.api.nvim_open_win(buf, true, win_opts)

  -- Highlight current line
  vim.cmd("setlocal cursorline")

  -- Key: Enter to select option
  vim.api.nvim_buf_set_keymap(buf, 'n', '<CR>', '', {
    noremap = true,
    silent = true,
    callback = function()
      local line = vim.api.nvim_get_current_line()

      if line:match("Create Task") then
        vim.api.nvim_win_close(win, true)
        require("fknotes.ui.task_form").new_task()

      elseif line:match("Browse Tasks") then
        vim.api.nvim_win_close(win, true)
        -- require("fknotes.ui.task_browser").open()
        vim.notify("📂 Browse Tasks – Not implemented yet", vim.log.levels.INFO)

      elseif line:match("Exit") then
        vim.api.nvim_win_close(win, true)
      end
    end,
  })

  -- Optional: j/k to navigate
  vim.api.nvim_buf_set_keymap(buf, 'n', 'j', 'j', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', 'k', 'k', { noremap = true, silent = true })
end

return M

