
local M = {}

local uv = vim.loop
local json = vim.fn.json_encode
local decode = vim.fn.json_decode

local data_path = vim.fn.stdpath("data") .. "/fknotes"
local file_path = data_path .. "/tasks.json"

-- Ensure directory exists
local function ensure_dir()
  if vim.fn.isdirectory(data_path) == 0 then
    vim.fn.mkdir(data_path, "p")
  end
end

-- Read tasks from file
function M.read_tasks()
  ensure_dir()
  local fd = io.open(file_path, "r")
  if not fd then return {} end

  local content = fd:read("*a")
  fd:close()

  local ok, result = pcall(decode, content)
  return ok and result or {}
end

-- Write tasks to file
function M.write_tasks(tasks)
  ensure_dir()
  local fd = io.open(file_path, "w")
  if not fd then
    vim.notify("FKNotes: Failed to write task data", vim.log.levels.ERROR)
    return
  end
  fd:write(json(tasks))
  fd:close()
end

return M
