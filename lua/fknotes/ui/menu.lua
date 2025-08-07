
local NuiMenu = require("nui.menu")
local event = require("nui.utils.autocmd").event
local Text = require("nui.text")

local task_form = require("fknotes.ui.task_form")
local task_browser = require("fknotes.ui.task_browser")

local M = {}

function M.open_main_menu()
  local config = require("fknotes.config").get().ui

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
        top = Text(" 🗂️  FKNotes Main Menu ", "FknotesTitle"),
        top_align = "center",
        bottom = Text("🔋 Powered by Neovim ⚡ FkVim", "Comment"),
        bottom_align = "center",
      },
    },
    win_options = {
      winhighlight = "Normal:Normal,FloatBorder:FknotesComment",
      cursorline = false,
      cursorcolumn = false,
    },
  }, {
    lines = {
      NuiMenu.item("📌  Take control of your notes. Effortlessly."),
      NuiMenu.separator(""),
      NuiMenu.item("🎯  Add New Task"),
      NuiMenu.item("📝  Add New Note"),
      NuiMenu.item("📓  Browse All Notes"),
      NuiMenu.item("✅  Browse All Tasks"),
      NuiMenu.separator(""),
      NuiMenu.item("⬇️ Move Down    ⬆️ Move Up    🔘 Select    ❌ Quit", { disabled = true }),
      NuiMenu.separator(""),
      NuiMenu.item("⚙️ Mentained by Mayank Jha from Flashcodes", { disabled = true }),
    },
    max_width = config.menu_width - 2,
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
