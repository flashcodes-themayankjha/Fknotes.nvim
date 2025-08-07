
local NuiMenu = require("nui.menu")
local event = require("nui.utils.autocmd").event
local Text = require("nui.text")

local task_form = require("fknotes.ui.task_form")
local task_browser = require("fknotes.ui.task_browser")

local config = {
  border_style = "rounded",
  menu_width = 50,
  menu_height = 16,
}

local M = {}

function M.open_main_menu()
  local menu = NuiMenu({
    position = {
      row = "50%",
      col = "50%",
    },
    size = {
      width = config.menu_width,
      height = config.menu_height,
    },
    border = {
      style = config.border_style,
      text = {
        top = Text(" 󰲡  Welcome to FKNotes Dashboard ", "FknotesTitle"),
        top_align = "center",
      },
    },
    win_options = {
      winhighlight = "Normal:Normal,FloatBorder:FknotesComment",
      cursorline = false,     -- disable current line highlight
      cursorcolumn = false,   -- disable current column highlight
    },
  }, {
    lines = {
      NuiMenu.separator(Text("   Task Management "), "SpecialComment"),
      NuiMenu.item(Text("🆕  Add New Task")),
      NuiMenu.item(Text("🗂️  Browse All Tasks")),
      NuiMenu.separator(Text(" 📝  Notes Management "), "SpecialComment"),
      NuiMenu.item(Text("🧾  Add New Note")),
      NuiMenu.item(Text("📚  Browse All Notes")),
      NuiMenu.separator(Text(" 🎛️  Controls "), "SpecialComment"),
      NuiMenu.item(Text("⬇️  Move Down"), { disabled = true }),
      NuiMenu.item(Text("⬆️  Move Up"), { disabled = true }),
      NuiMenu.item(Text("⏎  Select"), { disabled = true }),
      NuiMenu.item(Text("❌  Quit"), { disabled = true }),
      NuiMenu.separator(Text(""), "Comment"),
      NuiMenu.item(Text("⚡  Powered by Neovim & Fk.vim"), { disabled = true }),
    },
    max_width = config.menu_width,
    separator = {
      char = "─",
      text_align = "center",
    },
    keymap = {
      focus_next = { "j", "<Down>" },
      focus_prev = { "k", "<Up>" },
      close = { "<Esc>", "q" },
      submit = { "<CR>" },
    },
    on_close = function()
      vim.notify("FKNotes menu closed", vim.log.levels.INFO)
    end,
    on_submit = function(item)
      local label = item.text
      if label:find("Add New Task") then
        task_form.new_task()
      elseif label:find("Browse All Tasks") then
        task_browser.show_browser()
      elseif label:find("Add New Note") then
        vim.notify("Note creation not implemented yet", vim.log.levels.INFO)
      elseif label:find("Browse All Notes") then
        vim.notify("Note browser not implemented yet", vim.log.levels.INFO)
      end
    end,
  })

  menu:mount()

  menu:on(event.BufLeave, function()
    menu:unmount()
  end)
end

return M
