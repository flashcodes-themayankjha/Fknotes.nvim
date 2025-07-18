
local NuiPopup = require("nui.popup")
local event = require("nui.utils.autocmd").event
local storage = require("fknotes.core.storage")

local M = {}

function M.new_task()
  local popup = NuiPopup({
    enter = true,
    focusable = true,
    border = {
      style = "rounded",
      text = { top = " 📝 New Task ", top_align = "center" },
    },
    position = "50%",
    size = {
      width = 60,
      height = 15,
    },
    buf_options = {
      modifiable = true,
      readonly = false,
    },
  })

  popup:mount()

  local lines = {
    "Title: ",
    "Description: ",
    "Priority: [Low | Medium | High]",
    "Due Date (YYYY-MM-DD): ",
    "",
    "[S] Save   [C] Cancel",
  }

  vim.api.nvim_buf_set_lines(popup.bufnr, 0, -1, false, lines)

  popup:map("n", "C", function()
    popup:unmount()
  end, { noremap = true })

  popup:map("n", "S", function()
    local content = vim.api.nvim_buf_get_lines(popup.bufnr, 0, -1, false)

    local title = content[1]:gsub("Title:%s*", "")
    local description = content[2]:gsub("Description:%s*", "")
    local priority = content[3]:match("Priority:%s*%[(.-)%]") or "Low"
    local due_date = content[4]:gsub("Due Date %(.-%)%:%s*", "")

    if title == "" then
      vim.notify("⚠️ Title is required.", vim.log.levels.WARN)
      return
    end

    local new_task = {
      title = title,
      description = description,
      priority = priority,
      due_date = due_date,
      created = os.date("%Y-%m-%d"),
    }

    local tasks = storage.load_tasks()
    table.insert(tasks, new_task)
    storage.save_tasks(tasks)

    vim.notify("✅ Task saved!", vim.log.levels.INFO)
    popup:unmount()
  end, { noremap = true })

  popup:on(event.BufLeave, function()
    popup:unmount()
  end)
end

return M
