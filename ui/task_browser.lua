
local storage = require("fknotes.core.storage")

local M = {}

function M.open()
  local tasks = storage.load_tasks()

  local lines = { "📋 TODO List", "" }
  local today = os.date("%Y-%m-%d")

  for i, task in ipairs(tasks) do
    local status = ""
    local color = "Normal"
    if task.done then
      status = "✔ DONE"
      color = "TodoDone"
    elseif task.due < today then
      status = "❌ OVERDUE"
      color = "TodoOverdue"
    elseif task.due == today then
      status = "⚠ DUE TODAY"
      color = "TodoDueToday"
    else
      status = "⏳ UPCOMING"
      color = "TodoUpcoming"
    end

    local line = string.format("%d. %s [%s] - %s", i, task.title, task.due, status)
    table.insert(lines, line)
  end

  if #tasks == 0 then
    table.insert(lines, "No tasks found. Press 'q' to exit.")
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)

  local width = 60
  local height = #lines
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    style = "minimal",
    border = "rounded",
    row = (vim.o.lines - height) / 2,
    col = (vim.o.columns - width) / 2,
    width = width,
    height = height,
  })

  -- Define highlights
  vim.cmd("highlight TodoDone guifg=#6ec1e4")
  vim.cmd("highlight TodoOverdue guifg=#e06c75")
  vim.cmd("highlight TodoDueToday guifg=#e5c07b")
  vim.cmd("highlight TodoUpcoming guifg=#98c379")

  -- Apply highlights line by line
  for i, task in ipairs(tasks) do
    local hl_group
    if task.done then
      hl_group = "TodoDone"
    elseif task.due < today then
      hl_group = "TodoOverdue"
    elseif task.due == today then
      hl_group = "TodoDueToday"
    else
      hl_group = "TodoUpcoming"
    end
    vim.api.nvim_buf_add_highlight(buf, -1, hl_group, i + 1, 0, -1)
  end

  vim.api.nvim_buf_set_keymap(buf, 'n', 'q', ':bd!<CR>', { noremap = true, silent = true })
end

return M

