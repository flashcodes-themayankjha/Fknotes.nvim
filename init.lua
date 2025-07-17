local M = {}

function M.setup(opts)
  require("fknotes.config").setup(opts or {})
end

return M

