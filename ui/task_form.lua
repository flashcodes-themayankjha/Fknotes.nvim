
local Popup = require("nui.popup")
local Text = require("nui.text")
local event = require("nui.utils.autocmd").event

local task_form = {}

local fields = {
  { label = "📝 Title", key = "title", value = "" },
  { label = "📄 Description", key = "description", value = "" },
  { label = "📅 Due Date", key = "due_date", value = "" },
  { label = "⚡ Priority", key = "priority", value = "" },
  { label = "🏷️ Tags", key = "tags", value = "" },
}

local current_index = 1
local popup

-- Disable global cursor arrow (if active)
local function disable_global_cursor_arrow()
  vim.fn.sign_unplace("cursor_arrow")
  vim.g.fknotes_arrow_disabled = true
end

-- Restore global cursor arrow (if needed)
local function restore_global_cursor_arrow()
  vim.g.fknotes_arrow_disabled = false
  vim.api.nvim_exec_autocmds("CursorMoved", {}) -- force re-eval
end

local function render_form()
  local lines = {
    "",
    "  🏹 Fill in your task details:",
    "",
  }

  for i, field in ipairs(fields) do
    local arrow = (i == current_index) and "➤" or " "
    local val = field.value ~= "" and (": " .. field.value) or ""
    table.insert(lines, string.format("  %s %s %s", arrow, field.label, val))
  end

  table.insert(lines, "")
  table.insert(lines, "   [↵ Edit]   [j/k] Navigate   [Esc] Quit")

  local buf = popup.bufnr
  vim.api.nvim_buf_set_option(buf, "modifiable", true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(buf, "modifiable", false)
end

function task_form.new_task()
  current_index = 1

  popup = Popup({
    position = "50%",
    size = {
      width = 50,
      height = 15,
    },
    enter = true,
    focusable = true,
    border = {
      style = "rounded",
      text = {
        top = Text(" Create New Task ", "Title"),
        bottom = Text(" [FkNotes Task Form] ", "Comment"),
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

  -- Keymaps
  local nav_down = function()
    current_index = (current_index % #fields) + 1
    render_form()
  end

  local nav_up = function()
    current_index = (current_index - 2 + #fields) % #fields + 1
    render_form()
  end

  popup:map("n", "j", nav_down, { noremap = true })
  popup:map("n", "<down>", nav_down, { noremap = true })
  popup:map("n", "k", nav_up, { noremap = true })
  popup:map("n", "<up>", nav_up, { noremap = true })

  popup:map("n", "<esc>", function()
    popup:unmount()
    restore_global_cursor_arrow()
  end, { noremap = true })

  popup:map("n", "<cr>", function()
    local field = fields[current_index]
    vim.ui.input({ prompt = field.label .. ": " }, function(input)
      if input then
        field.value = input
        render_form()
      end
    end)
  end, { noremap = true })

  popup:on(event.BufLeave, function()
    popup:unmount()
    restore_global_cursor_arrow()
  end)
end

return task_form
