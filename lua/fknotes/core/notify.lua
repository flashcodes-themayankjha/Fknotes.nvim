local M = {}

-- Simple wrapper for consistent FKNotes messages
function M.info(msg)
  vim.notify("󰚩 " .. msg, vim.log.levels.INFO, { title = "FKNotes" })
end

function M.warn(msg)
  vim.notify(" " .. msg, vim.log.levels.WARN, { title = "FKNotes" })
end

function M.error(msg)
  vim.notify(" " .. msg, vim.log.levels.ERROR, { title = "FKNotes" })
end

-- Check tasks for approaching deadlines
function M.check_due_tasks()
  local storage = require("fknotes.core.storage")
  local tasks = storage.get_all_tasks()

  local today = os.date("%Y-%m-%d")
  local y2, m2, d2 = today:match("(%d+)%-(%d+)%-(%d+)")

  for _, task in ipairs(tasks or {}) do
    local due = task.due_date or task.due -- Handle both for backward compatibility
    if due then
      local y1, m1, d1 = due:match("(%d+)%-(%d+)%-(%d+)")
      if y1 and m1 and d1 then
        local due_time = os.time { year = y1, month = m1, day = d1 }
        local now = os.time { year = y2, month = m2, day = d2 }
        local diff = math.floor((due_time - now) / 86400)
        if diff >= 0 and diff <= 2 then
          M.warn("Task '" .. (task.title or task.text) .. "' is due soon (" .. due .. ") ⚠️")
        end
      end
    end
  end
end

return M

