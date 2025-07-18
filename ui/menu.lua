
local popup = require("nui.popup")
local event = require("nui.utils.autocmd").event
local nuitext = require("nui.text")
local nuiline = require("nui.line")
local nuilayout = require("nui.layout")
local layout = nuilayout
local text = nuitext
local line = nuiline

local m = {}

function m.open_main_menu()
  local popup = popup({
    position = "50%",
    size = {
      width = 50,
      height = 16,
    },
    border = {
      style = {
        top_left = "╭",
        top = "─",
        top_right = "╮",
        right = "│",
        bottom_right = "╯",
        bottom = "─",
        bottom_left = "╰",
        left = "│",
      },
      text = {
        top = text(" 🗂 FkNotes Main Menu ", "title"),
        bottom = text(" Powered by Neovim and Fkvim ", "comment"),
      },
    },
    win_options = {
      winhighlight = "normal:normal,floatborder:comment",
    },
  })

  local menu_lines = {
    line():append("📝 Create new task", "identifier"),
    line():append("🔍  View tasks", "function"),
    line():append("📓  Create new note", "statement"),
    line():append("🔖 Browse all notes", "type"),
  }

  local help_line = line()
  help_line:append("      [", "comment")
  help_line:append("❓]  [help", "function")
  help_line:append("]", "comment")
  help_line:append("   ")
  help_line:append("[", "comment")
  help_line:append("esc] [quit", "errormsg")
  help_line:append("]", "comment")

  popup:mount()

  local buf = popup.bufnr
  vim.api.nvim_buf_set_option(buf, "modifiable", true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})

  -- draw menu content
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
    "",
    "   Welcome, choose the option bellow 🏹",
    "",
  })

  for _, line in ipairs(menu_lines) do
    vim.api.nvim_buf_set_lines(buf, -1, -1, false, { "   " .. line:content() })
  end

  -- add spacing and footer buttons
  vim.api.nvim_buf_set_lines(buf, -1, -1, false, {
    "",
    "   " .. help_line:content(),
    "",
  })

  vim.api.nvim_buf_set_option(buf, "modifiable", false)

  -- escape closes the popup
  popup:map("n", "<esc>", function()
    popup:unmount()
  end, { noremap = true })

  -- optionally handle enter key
  vim.keymap.set("n", "<cr>", function()
    -- add custom action if needed
  end, { buffer = buf })
end

return m
