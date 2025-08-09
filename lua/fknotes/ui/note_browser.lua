local NuiTree = require("nui.tree")
local event = require("nui.utils.autocmd").event

local M = {}

function M.show_browser()
  local tree = NuiTree({
    nodes = {
      NuiTree.node("My Notebook", {
        nodes = {
          NuiTree.node("Chapter 1"),
          NuiTree.node("Chapter 2"),
        }
      }),
      NuiTree.node("Another Notebook"),
    },
    win_options = {
      winhighlight = "Normal:Normal,FloatBorder:FknotesComment",
    }
  })

  tree:mount()

  tree:on(event.BufLeave, function()
    tree:unmount()
  end)
end

return M