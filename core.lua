
local config = require("fknotes.config")

local M = {}

function M.create_note()
  local title = vim.fn.input("Note title: ")
  if title == "" then return end

  local filename = title:gsub(" ", "_") .. ".md"
  local path = config.options.notes_dir .. "/" .. filename

  vim.cmd("edit " .. path)
end

function M.toggle_checkbox()
  local line = vim.api.nvim_get_current_line()
  if line:find("%[ %]") then
    line = line:gsub("%[ %]", "[x]")
  elseif line:find("%[x%]") then
    line = line:gsub("%[x%]", "[ ]")
  end
  vim.api.nvim_set_current_line(line)
end

return M
