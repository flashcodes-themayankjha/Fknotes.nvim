local M = {}

function M.setup()
  vim.api.nvim_create_user_command("FKNotes", function()
    require("fknotes.ui.menu").open()
  end, {})
end

return M

