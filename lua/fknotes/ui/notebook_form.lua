local NuiInput = require("nui.input")
local event = require("nui.utils.autocmd").event

local M = {}

function M.new()
  local input = NuiInput({
    position = "50%",
    size = {
      width = 40,
    },
    border = {
      style = "single",
      text = {
        top = "Enter Notebook Title",
        top_align = "center",
      },
    },
    win_options = {
      winhighlight = "Normal:Normal,FloatBorder:FknotesComment",
    },
  }, {
    prompt = "> ",
    on_submit = function(value)
      vim.notify("Notebook created: " .. value)
    end,
  })

  input:mount()

  input:on(event.BufLeave, function()
    input:unmount()
  end)
end

return M