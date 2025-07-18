vim.keymap.set("n", "<leader>fm", function()
  require("fknotes.ui.menu").open()
end, { desc = "Open FKNotes Menu" })

