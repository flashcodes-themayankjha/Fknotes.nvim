
local config = require("fknotes.config")
local M = {}

local function load_file()
  local file = io.open(config.paths.todo_file, "r")
  if not file then return {} end
  local content = file:read("*a")
  file:close()
  return vim.fn.json_decode(content) or {}
end

local function save_file(todos)
  local file = io.open(config.paths.todo_file, "w")
  if not file then return end
  file:write(vim.fn.json_encode(todos))
  file:close()
end

M.load_todos = function()
  return load_file()
end

M.save_todos = function(todos)
  save_file(todos)
end

return M
