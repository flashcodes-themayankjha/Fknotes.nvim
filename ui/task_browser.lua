
local NuiPopup = require("nui.popup")
local event = require("nui.utils.autocmd").event
local storage = require("fknotes.core.storage")

local M = {}

function M.open()
  local popup = NuiPopup({
    enter = true,
    focusable = true,
    border = {
      style = "rounded",
      text = { top = " 📋 Tasks ", top_align = "center" },
    },
    position = "50%",
    size = {
      width = 70,
      height = 20,
    },
    buf_options = {
      modifiable = true,
      readonly = false,
    },
  })

  popup:mount()

  local tasks = storage.load_tasks()

  -- Defensive: Ensure fields exist
  for _, task in ipairs(tasks) do
    task.title = task.title or "Untitled"
    task.priority = task.priority or "Low"
    task.due_date = task.due_date or "N/A"
    task.created = task.created or "N/A"
  end

  -- Sort by due_date if available
  table.sort(tasks, function(a, b)
    return (a.due_date or "") < (b.due_date or "")
  end)

  local lines = {}
  for i, task in ipairs(tasks) do
    table.insert(lines, string.format("%d. %s [%s] - Due: %s", i, task.title, task.priority, task.due_date))
  end

  if #lines == 0 then
    lines = { "No tasks found." }
  end

  vim.api.nvim_buf_set_lines(popup.bufnr, 0, -1, false, lines)

  popup:map("n", "q", function()
    popup:unmount()
  end, { noremap = true })

  popup:on(event.BufLeave, function()
    popup:unmount()
  end)
end

return M
