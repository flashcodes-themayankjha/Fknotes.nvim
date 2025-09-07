
local Popup = require("nui.popup")
local Text = require("nui.text")
local event = require("nui.utils.autocmd").event
local storage = require("fknotes.core.storage")

local M = {}

-- fields
local fields = {
  { label = "📓 Notebook Name", key = "name", value = "" },
  { label = "✍️ Author", key = "author", value = vim.env.USER or "Anonymous" },
  { label = "🏷️ Tags", key = "tags", value = {} },
}

local current_index = 1
local popup = nil

-- Render notebook form
local function render_form()
  local lines = {
    "",
    "    Create a New Notebook to Organize all notes",
    " ─────────────────────────────────────────────────────",
    "",
  }

  for i, field in ipairs(fields) do
    local arrow = (i == current_index) and " ➤" or " "
    local val = ""

    if field.key == "tags" then
      val = (#field.value > 0) and (": " .. table.concat(field.value, ", ")) or ""
    elseif field.value ~= "" then
      val = ": " .. field.value
    end

    table.insert(lines, string.format("  %s %s %s", arrow, field.label, val))
  end

  table.insert(lines, "")
      table.insert(lines, "")
  table.insert(lines, "")
      table.insert(lines, "")
  table.insert(lines, "")
  table.insert(lines, "  ──────────────────────────────────────────────────── ")
  table.insert(lines, "  🖋️ Edit [↵]   🧭 Navigate [j/k]   💾 Save [s]   ❌ Quit [Esc] ")

  local buf = popup.bufnr
  vim.api.nvim_buf_set_option(buf, "modifiable", true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(buf, "modifiable", false)
end

-- Save notebook
local function save_notebook()
  local name = fields[1].value
  if not name or name == "" then
    vim.notify("❌ Notebook name is required!", vim.log.levels.ERROR)
    return
  end

  local notebook = {
    name = fields[1].value,
    author = fields[2].value,
    tags = fields[3].value,
    created_at = os.time(),
    notes = {},
  }

  storage.add_notebook(notebook)
  vim.notify("✅ Notebook '" .. notebook.name .. "' created!", vim.log.levels.INFO)

  popup:unmount()
end

function M.new_notebook()
  local config = require("fknotes.config").get()
  current_index = 1

  popup = Popup({
    position = "50%",
    size = { width = 60, height = 16 },
    enter = true,
    focusable = true,
    border = {
      style = config.ui.border_style,
      text = {
        top = Text(" 📓 FKNotes Notebook Form ", "FknotesTitle"),
        bottom = Text(" 🔋 Powered by Neovim + FKNotes ", "FknotesComment"),
      },
    },
    win_options = {
      winhighlight = "Normal:Normal,FloatBorder:FknotesComment",
    },
  })

  popup:mount()
  render_form()

  -- navigation
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

  -- quick save
  popup:map("n", "s", save_notebook, { noremap = true })

  -- quit with ESC (confirmation)
  popup:map("n", "<esc>", function()
    vim.ui.input({
      prompt = "❓ Cancel notebook creation? (y/n): ",
    }, function(input)
      if input and input:lower() == "y" then
        vim.notify("Notebook creation cancelled", vim.log.levels.WARN)
        popup:unmount()
      else
        render_form()
      end
    end)
  end, { noremap = true })

 -- handle ENTER
popup:map("n", "<cr>", function()
  local field = fields[current_index]

  if field.key == "tags" then
    local function ask_tag()
      vim.ui.input({ prompt = "Add Tag (leave blank to finish): " }, function(input)
        if input and input ~= "" then
          table.insert(field.value, input)
          render_form()
          ask_tag() -- keep asking until user leaves blank
        else
          render_form()
        end
      end)
    end
    ask_tag()
  else
    vim.ui.input({
      prompt = field.label .. ": ",
      default = field.value or "",
    }, function(input)
      if input then
        field.value = input
        render_form()
      end
    end)
  end
end, { noremap = true })

  popup:on(event.BufLeave, function() popup:unmount() end)
end

return M
