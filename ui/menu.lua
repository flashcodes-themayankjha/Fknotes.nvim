
local Popup = require("nui.popup")
local Text = require("nui.text")

local m = {}

function m.open_main_menu()
  require("fknotes.ui.colorscheme").setup()

  local popup = Popup({
    position = "50%",
    size = {
      width = 44,
      height = 13,
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
        top = Text(" 🗂 FkNotes Main Menu ", "Title"),
        bottom = Text(" Powered by Neovim and FKvim ", "Comment"),
      },
    },
    win_options = {
      winhighlight = "Normal:Normal,FloatBorder:Comment",
    },
    enter = true, -- ✅ auto-focus when opened
    focusable = true,
  })

  -- 👇 Define your menu options and their actions
  local menu_items = {
    {
      label = "📝 Create New Task",
      action = function()
        require("fknotes.ui.task_form").new_task()
      end,
    },
    {
      label = "🔍 View Tasks",
      action = function()
        require("fknotes.ui.task_browser").show_browser()
      end,
    },
    {
      label = "📓 Create New Note",
      action = function()
        require("fknotes.note_form").open()
      end,
    },
    {
      label = "🔖 Browse All Notes",
      action = function()
        require("fknotes.note_browser").open()
      end,
    },
  }

  local current_index = 1
  popup:mount()

  local buf = popup.bufnr

  -- 👇 Disable indent plugins and folding for this buffer
  vim.api.nvim_buf_set_option(buf, "filetype", "fknotes-menu")
  vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
  vim.api.nvim_buf_set_option(buf, "modifiable", true)
  vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
  vim.api.nvim_buf_set_option(buf, "swapfile", false)

  vim.api.nvim_create_autocmd("BufEnter", {
    buffer = buf,
    callback = function()
      vim.b.indent_blankline_enabled = false
      vim.wo.foldenable = false
      vim.wo.signcolumn = "no"
    end,
  })
vim.api.nvim_buf_set_option(buf, "filetype", "fknotes-menu")
  ---@param index number
  local function render_menu(index)
    local lines = {
      "",
      "   Welcome, Choose the option below (1-4) 🏹",
      "",
    }

    for i, item in ipairs(menu_items) do
      local prefix = i == index and " ➤ " or "   "
      table.insert(lines, prefix .. item.label)
    end

    table.insert(lines, "")
    table.insert(lines, "      [❓ Help]   [󱊷 Quit]")
    table.insert(lines, "")

    vim.api.nvim_buf_set_option(buf, "modifiable", true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.api.nvim_buf_set_option(buf, "modifiable", false)
  end

  render_menu(current_index)

  -- Keybindings inside popup
  popup:map("n", "<esc>", function()
    popup:unmount()
  end, { noremap = true })

  popup:map("n", "<down>", function()
    if current_index < #menu_items then
      current_index = current_index + 1
      render_menu(current_index)
    end
  end, { noremap = true })

  popup:map("n", "<up>", function()
    if current_index > 1 then
      current_index = current_index - 1
      render_menu(current_index)
    end
  end, { noremap = true })

  popup:map("n", "<cr>", function()
    local selected = menu_items[current_index]
    popup:unmount()
    selected.action()
  end, { noremap = true })

  -- Shortcut keys 1–4
  for i = 1, #menu_items do
    popup:map("n", tostring(i), function()
      popup:unmount()
      menu_items[i].action()
    end, { noremap = true })
  end
end

return m
