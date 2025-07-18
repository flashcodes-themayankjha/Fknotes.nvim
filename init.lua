
local M = {}

function M.setup()
  -- Apply custom highlights
vim.api.nvim_set_hl(0, "Title", { fg = "#ffd700", bold = true })      -- Yellowish title
vim.api.nvim_set_hl(0, "Comment", { fg = "#888888" })                 -- Grey comment bar
vim.api.nvim_set_hl(0, "FkNotesRedButton", { fg = "#ff5f5f", bold = true })
vim.api.nvim_set_hl(0, "FkNotesBlueButton", { fg = "#5fafff", bold = true })


  -- Ensure highlights persist across color scheme changes
  vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = function()
      vim.api.nvim_set_hl(0, "FkNotesRedButton", { fg = "#f7768e", bold = true })
      vim.api.nvim_set_hl(0, "FkNotesBlueButton", { fg = "#7dcfff", bold = true })
    end,
  })

  -- User commands
  vim.api.nvim_create_user_command("FKNotes", function()
    require("fknotes.ui.menu").open_main_menu()
  end, {})

  vim.api.nvim_create_user_command("FkNotes", function()
    require("fknotes.ui.menu").open_main_menu()
  end, {})

  -- Keymap
  vim.keymap.set("n", "<Leader>fn", function()
    require("fknotes.ui.menu").open_main_menu()
  end, { desc = "Open FKNotes Menu" })
end

return M
