local m = {}

function m.setup()
  -- Load FKNotes highlight colors from fknotes/ui/colorscheme.lua
  require("fknotes.ui.colorscheme").setup()



  -- Create user command
  vim.api.nvim_create_user_command("FkNotes", function()
    require("fknotes.ui.menu").open_main_menu()
  end, {})

  -- Keymap
  vim.keymap.set("n", "<leader>fn", function()
    require("fknotes.ui.menu").open_main_menu()
  end, { desc = "Open FKNotes Menu" })
end

return m

