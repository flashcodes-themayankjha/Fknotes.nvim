
local M = {}

M.paths = {
  todo_file = vim.fn.stdpath("data") .. "/fknotes/todos.json"
}

function M.setup()
  vim.fn.mkdir(vim.fn.stdpath("data") .. "/fknotes", "p")

  vim.api.nvim_create_user_command("FkToDo", function()
    require("fknotes.ui").open_dashboard()
  end, {})
end

return M
