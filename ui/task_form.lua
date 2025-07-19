
local Popup = require("nui.popup")
local Text = require("nui.text")
local event = require("nui.utils.autocmd").event
local priority_selector = require("fknotes.ui.priority_selector")
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

-- Define custom highlight styles (Catppuccin colors)
local function define_highlights()
  -- New header and footer specific groups
  vim.api.nvim_set_hl(0, "FkNotesHeader",  { fg = "#f9e2af", bold = true }) -- Yellowish
  vim.api.nvim_set_hl(0, "FkNotesFooter",  { fg = "#babbf1", italic = true }) -- Soft Green
  vim.api.nvim_set_hl(0,"FkNotesFooter2",{fg="#a6d189", italic=true})
end

local current_index = 1
local popup

local function disable_global_cursor_arrow()
  vim.fn.sign_unplace("cursor_arrow")
  vim.g.fknotes_arrow_disabled = true
end

local function restore_global_cursor_arrow()
  vim.g.fknotes_arrow_disabled = false
  vim.api.nvim_exec_autocmds("CursorMoved", {})
end

-- Basic validation (just title required for now)
local function is_valid()
  for _, field in ipairs(fields) do
    if field.key == "title" and (not field.value or field.value == "") then
      vim.notify("❌ Title is required!", vim.log.levels.ERROR)
      return false
    end

    if field.key == "due_date" and field.value ~= "" then
      local y, m, d = field.value:match("^(%d+)%-(%d+)%-(%d+)$")
      if not (y and m and d) then
        vim.notify("⚠️ Due Date must be in format YYYY-MM-DD", vim.log.levels.WARN)
        return false
      end
    end
  end
  return true
end

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
  exporter.export_task(task)

  vim.notify("✅ Task saved!", vim.log.levels.INFO)
  popup:unmount()
  restore_global_cursor_arrow()
end

local function render_form()
  local lines = {
    "",
    "  🏹 Fill in your task details:",
    "",
  }

  for i, field in ipairs(fields) do
    local arrow = (i == current_index) and " ➤ " or " "
    local val = ""

    if field.key == "tags" and type(field.value) == "table" then
      val = #field.value > 0 and (": " .. table.concat(field.value, ", ")) or ""
    elseif field.value ~= "" then
      val = ": " .. field.value
    end

    table.insert(lines, string.format("  %s %s %s", arrow, field.label, val))
  end

  table.insert(lines, "")
  table.insert(lines, "")
  table.insert(lines, "")
  table.insert(lines, "")
  table.insert(lines, "   🖋️Edit[↵]   🧭Navigate [j/k]  💾 Save[s]  ❌ Quit [Esc]" )

  local buf = popup.bufnr
  vim.api.nvim_buf_set_option(buf, "modifiable", true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_add_highlight(buf, -1, "FkNotesFooter", #lines - 1, 0, -1)
  vim.api.nvim_buf_set_option(buf, "modifiable", false)
end

function task_form.new_task()
  current_index = 1

  define_highlights()

  popup = Popup({
    position = "50%",
    size = {
      width = 60,
      height = 17,
    },
    enter = true,
    focusable = true,
    border = {
      style = "rounded",
      text = {
        top = Text(" Create New Task ", "FkNotesHeader"),
        bottom = Text("   Powered by Neovim and FKvim ", "FkNotesFooter2"),
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
    elseif field.key == "tags" then
      local function ask_tag()
        vim.ui.input({ prompt = "Add Tag (leave blank to finish): " }, function(input)
          if input and input ~= "" then
            table.insert(field.value, input)
            render_form()
            ask_tag()
          else render_form() end
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
    popup:unmount()
    restore_global_cursor_arrow()
  end)
end

return task_form
