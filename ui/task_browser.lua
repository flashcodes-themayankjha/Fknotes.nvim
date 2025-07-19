
local Popup = require("nui.popup")
local event = require("nui.utils.autocmd").event
local storage = require("fknotes.core.storage")

local task_browser = {}

local popup
local tasks = {}
local current_index = 1

-- Detect task status for highlighting
local function get_task_status(task)
  if task.done then return "done" end
  if not task.due_date or task.due_date == "" then return "none" end

  local y, m, d = task.due_date:match("^(%d+)%-(%d+)%-(%d+)$")
  if not y then return "none" end

  local due = os.time({ year = tonumber(y), month = tonumber(m), day = tonumber(d) })
  local now = os.time()
  local diff = os.difftime(due, now)

  if diff < 0 then return "expired"
  elseif diff <= 2 * 86400 then return "soon"
  else return "pending" end
end

-- Format task with icons, done, and highlight group
local function format_task(task, index, is_selected)
  local prefix = is_selected and "➤" or string.format("%2d", index)
  local status = get_task_status(task)
  local title = task.title or "(no title)"
  local priority = task.priority or "-"

  -- Add checkmark if done
  if task.done then
    title = " " .. title
  end

  local line = string.format(" %s  %-40s %-10s", prefix, title, priority)
  return {
    text = line,
    group = "FkNotes" .. status:gsub("^%l", string.upper),
  }
end

-- Highlight group styles
local function define_highlights()
-- Reference: Catppuccin Mocha palette (https://github.com/catppuccin/catppuccin)

vim.api.nvim_set_hl(0, "FkNotesDone",    { fg = "#a6e3a1" })  -- Green (Success)
vim.api.nvim_set_hl(0, "FkNotesSoon",    { fg = "#f9e2af" })  -- Yellow (Warning)
vim.api.nvim_set_hl(0, "FkNotesExpired", { fg = "#f38ba8" })  -- Red (Urgent)
vim.api.nvim_set_hl(0, "FkNotesPending", { fg = "#cdd6f4" })  -- Subtle White
vim.api.nvim_set_hl(0, "FkNotesNone",    { fg = "#6c7086" })  -- Gray (Overlay)

-- Make header bold but use default foreground color (NO more blue):
vim.api.nvim_set_hl(0, "FkNotesHeader",  { bold = true })

end

-- Render tasks + menu footer (scroll support)
local function render_tasks()
  vim.api.nvim_buf_clear_namespace(popup.bufnr, -1, 0, -1)

  local lines = {}
  -- Header
  table.insert(lines, "")
  table.insert(lines, string.format("     %s  %-40s %-10s", "Idx", "Title", "Priority"))
  table.insert(lines, "     ─────────────────────────────────────────────────────────────")

  -- Tasks
  for i, task in ipairs(tasks) do
    local is_selected = (i == current_index)
    local formatted = format_task(task, i, is_selected)
    table.insert(lines, formatted.text)
  end

  -- Padding & Footer
  table.insert(lines, "")
  table.insert(lines, "   ✅ Mark Done [m]   🗑️ Delete [d] 🧭 Navigate [j/k or ↑/↓]  ❌ Quit")

  -- Set buffer content
  local buf = popup.bufnr
  vim.api.nvim_buf_set_option(buf, "modifiable", true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(buf, "modifiable", false)

  -- Apply highlights
  vim.api.nvim_buf_add_highlight(buf, -1, "FkNotesHeader", 1, 0, -1)
  for i, task in ipairs(tasks) do
    local group = format_task(task, i).group
    -- Offset +3 because header lines consume 3 rows
    vim.api.nvim_buf_add_highlight(buf, -1, group, i + 2, 0, -1)
  end

  -- Offset +3 for title + header spacing
  vim.api.nvim_win_set_cursor(popup.winid, { current_index + 3, 0 })
end

-- Delete current task
local function delete_task()
  if #tasks == 0 then return end
  table.remove(tasks, current_index)
  storage.write_tasks(tasks)
  current_index = math.max(1, math.min(current_index, #tasks))
  render_tasks()
  vim.notify("🗑️ Task deleted", vim.log.levels.WARN)
end

-- Toggle done flag
local function toggle_done()
  if #tasks == 0 then return end
  local task = tasks[current_index]
  task.done = not task.done
  storage.write_tasks(tasks)
  render_tasks()
  local msg = task.done and "✅ Marked as done" or "↩️ Marked as not done"
  vim.notify(msg, vim.log.levels.INFO)
end

-- Main entry
function task_browser.show_browser()
  tasks = storage.read_tasks()
  current_index = 1
  define_highlights()

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
        bottom = "   Powered by Neovim + FKNotes ",
      },
    },
    win_options = {
      winhighlight = "Normal:Normal,FloatBorder:Comment",
      cursorline = false,
      number = false,
      relativenumber = false,
    },
  })

  popup:mount()
  vim.api.nvim_buf_set_option(popup.bufnr, "filetype", "fknotes-browser")

  -- Enable vertical scrolling
  vim.api.nvim_win_set_option(popup.winid, "scrolloff", 2)
  render_tasks()

  -- Keybindings
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
  popup:map("n", "m", toggle_done, { noremap = true })

  popup:map("n", "<esc>", function()
    popup:unmount()
  end, { noremap = true })

  -- Auto-close if focus leaves
  popup:on(event.BufLeave, function()
    popup:unmount()
  end)
end

return task_browser
