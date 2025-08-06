
local Popup = require("nui.popup")
local Text = require("nui.text")
local event = require("nui.utils.autocmd").event
local priority_selector = require("fknotes.ui.priority_selector")
local date_picker = require("fknotes.ui.date_picker")
local storage = require("fknotes.core.storage")
local exporter = require("fknotes.core.export")

local task_form = {}

local fields = {
  { label = "📝 Title", key = "title", value = "" },
  { label = "📄 Description", key = "description", value = "" },
  { label = "📅 Due Date", key = "due_date", value = "" },
  { label = "✨ Priority", key = "priority", value = "" },
  { label = "🏷️ Tags", key = "tags", value = {} },
}

local current_index = 1
local popup = nil
local task_saved = false -- Track save status

-- Define Catppuccin-style header/footer highlights
local function define_highlights()
  -- FkNotes highlight groups are now defined in colorscheme.lua
  -- We just need to ensure they are loaded.
  require("fknotes.ui.colorscheme").setup()
end

-- Clear field values (called only after save)
local function clear_fields()
  for _, field in ipairs(fields) do
    field.value = field.key == "tags" and {} or ""
  end
end

local function disable_global_cursor_arrow()
  vim.fn.sign_unplace("cursor_arrow")
  vim.g.fknotes_arrow_disabled = true
end

local function restore_global_cursor_arrow()
  vim.g.fknotes_arrow_disabled = false
  vim.api.nvim_exec_autocmds("CursorMoved", {})
end

-- Input validation
local function is_valid()
  local all_tasks = storage.read_tasks()
  local titles = {}

  for _, task in ipairs(all_tasks) do
    if task.title then
      titles[task.title:lower()] = true
    end
  end

  for _, field in ipairs(fields) do
    if field.key == "title" then
      if not field.value or field.value == "" then
        vim.notify("❌ Title is required!", vim.log.levels.ERROR)
        return false
      end
      if titles[field.value:lower()] then
        vim.notify("A task with this title already exists!", vim.log.levels.WARN)
        return false
      end
    end

    if field.key == "due_date" and field.value ~= "" then
      local y, m, d = field.value:match("^(%d+)%-(%d+)%-(%d+)$")
      if not (y and m and d) then
        vim.notify("Due Date must be in format YYYY-MM-DD", vim.log.levels.WARN)
        return false
      end
    end
  end

  return true
end

-- Save the task
local function save_task()
  if not is_valid() then return end

  local task = {}
  for _, field in ipairs(fields) do
    task[field.key] = field.value
  end
  task.created_at = os.date("%Y-%m-%d %H:%M:%S")

  local all_tasks = storage.read_tasks()
  table.insert(all_tasks, task)
  storage.write_tasks(all_tasks)
  task_saved = true
  exporter.export_task(task)

  vim.notify("✅ Task saved!", vim.log.levels.INFO)

  clear_fields() -- Only clear after saving
  popup:unmount()
  restore_global_cursor_arrow()
end

-- Redraw the form
local function render_form()
  local lines = {
    "",
    "  🏹 Fill in your task details:",
    "",
  }

  for i, field in ipairs(fields) do
    local arrow = (i == current_index) and " ➤" or " "
    local val = ""

    if field.key == "tags" and type(field.value) == "table" then
      val = (#field.value > 0 and (": " .. table.concat(field.value, ", ")) or "")
    elseif field.value ~= "" then
      val = ": " .. field.value
    end

    table.insert(lines, string.format("  %s %s %s", arrow, field.label, val))
  end

  table.insert(lines, "")
  table.insert(lines, "")
  table.insert(lines, "")
  table.insert(lines, "")
  table.insert(lines, " 🖋️Edit[↵]   🧭Navigate [j/k]  💾 Save[s]  ❌ Quit [Esc]")

  local buf = popup.bufnr
  vim.api.nvim_buf_set_option(buf, "modifiable", true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_add_highlight(buf, -1, "FkNotesFooter", #lines - 1, 0, -1)
  vim.api.nvim_buf_set_option(buf, "modifiable", false)
end

-- Main entry
function task_form.new_task()
  current_index = 1
  task_saved = false -- Reset save status
  define_highlights()

  popup = Popup({
    position = "50%",
    size = { width = 60, height = 17 },
    enter = true,
    focusable = true,
    border = {
      style = "rounded",
      text = {
        top = Text("🗂️ Create New Task ", "FkNotesHeader"),
        bottom = Text("🔋 Powered by Neovim and FKvim ", "FkNotesFooter2"),
      },
    },
    win_options = {
      winhighlight = "Normal:Normal,FloatBorder:FknotesComment",
      cursorline = false,
      number = false,
      relativenumber = false,
    },
  })

  popup:mount()
  disable_global_cursor_arrow()
  render_form()

  local function nav_down()
    current_index = (current_index % #fields) + 1
    render_form()
  end

  local function nav_up()
    current_index = (current_index - 2 + #fields) % #fields + 1
    render_form()
  end

  popup:map("n", "j", nav_down, { noremap = true })
  popup:map("n", "k", nav_up, { noremap = true })
  popup:map("n", "<down>", nav_down, { noremap = true })
  popup:map("n", "<up>", nav_up, { noremap = true })

  popup:map("n", "s", save_task, { noremap = true })

  popup:map("n", "<esc>", function()
    if not task_saved then
      vim.notify("FKNotes form closed without saving", vim.log.levels.WARN)
    end
    popup:unmount()
    restore_global_cursor_arrow()
  end, { noremap = true })

  popup:map("n", "<cr>", function()
    local field = fields[current_index]

    if field.key == "priority" then
      priority_selector.open_priority_picker(function(selected)
        field.value = selected.label
        render_form()
      end)
    elseif field.key == "due_date" then
      date_picker.open(function(selected_date)
        field.value = selected_date
        render_form()
      end)
    elseif field.key == "tags" then
      local function ask_tag()
        vim.ui.input({ prompt = "Add Tag (leave blank to finish): " }, function(input)
          if input and input ~= "" then
            table.insert(field.value, input)
            render_form()
            ask_tag()
          else
            render_form()
          end
        end)
      end
      ask_tag()
    else
      vim.ui.input({ prompt = field.label .. ": " }, function(input)
        if input then
          field.value = input
          render_form()
        end
      end)
    end
  end, { noremap = true })

  popup:on(event.BufLeave, function()
    if not task_saved then
      vim.notify("FKNotes form closed without saving", vim.log.levels.WARN)
    end
    popup:unmount()
    restore_global_cursor_arrow()
  end)
end

return task_form
