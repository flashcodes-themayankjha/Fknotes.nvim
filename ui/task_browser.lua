
local Popup = require("nui.popup")
local event = require("nui.utils.autocmd").event
local storage = require("fknotes.core.storage")

local task_browser = {}

local popup
local tasks = {}
local current_index = 1

-- Format task with optional arrow if selected
local function format_task(task, index, is_selected)
  local prefix = is_selected and "" or string.format("%2d.", index)
  local title = task.title or "(No Title)"
  local priority = task.priority or "-"
  return string.format(" %s  %-50s %-8s", prefix, title, priority)
end

-- Render task list with highlight and local arrow
local function render_tasks()
  local lines = {}
  for i, task in ipairs(tasks) do
    local is_selected = (i == current_index)
    table.insert(lines, format_task(task, i, is_selected))
  end

  table.insert(lines, "")
  table.insert(lines, "   [d] Delete   [j/k or ↑/↓] Navigate   [Esc] Quit")

  local buf = popup.bufnr
  vim.api.nvim_buf_set_option(buf, "modifiable", true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(buf, "modifiable", false)

  -- Keep cursor visually aligned
  vim.api.nvim_win_set_cursor(popup.winid, { current_index, 0 })
end

-- Delete selected task
local function delete_task()
  if #tasks == 0 then return end

  table.remove(tasks, current_index)
  storage.write_tasks(tasks)

  if current_index > #tasks then
    current_index = #tasks
  end
  if current_index < 1 then
    current_index = 1
  end

  render_tasks()
  vim.notify("🗑️ Task deleted", vim.log.levels.WARN)
end

-- Show browser popup
function task_browser.show_browser()
  tasks = storage.read_tasks()
  current_index = 1

  popup = Popup({
    position = "50%",
    size = {
      width = 80,
      height = 20,
    },
    enter = true,
    focusable = true,
    border = {
      style = "rounded",
      text = {
        top = " FKvim Task Browser ",
        bottom = "   Powered by Neovim and FKvim ",
      },
    },
    win_options = {
      winhighlight = "Normal:Normal,FloatBorder:Comment,CursorLine:CursorLine",
      cursorline = true,
      number = false,
      relativenumber = false,
    },
  })

  popup:mount()
  vim.api.nvim_buf_set_option(popup.bufnr, "filetype", "fknotes-browser")

  -- Initial render
  render_tasks()

  -- Navigation keymaps
  local function nav_down()
    if current_index < #tasks then
      current_index = current_index + 1
      render_tasks()
    end
  end

  local function nav_up()
    if current_index > 1 then
      current_index = current_index - 1
      render_tasks()
    end
  end

  popup:map("n", "j", nav_down, { noremap = true, silent = true })
  popup:map("n", "<down>", nav_down, { noremap = true, silent = true })

  popup:map("n", "k", nav_up, { noremap = true, silent = true })
  popup:map("n", "<up>", nav_up, { noremap = true, silent = true })

  popup:map("n", "d", delete_task, { noremap = true })

  popup:map("n", "<esc>", function()
    popup:unmount()
  end, { noremap = true })

  -- Unmount when focus leaves buffer
  popup:on(event.BufLeave, function()
    popup:unmount()
  end)
end

return task_browser
