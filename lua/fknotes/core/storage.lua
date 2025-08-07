
local M = {}

local json_encode = vim.fn.json_encode
local json_decode = vim.fn.json_decode

local config = require("fknotes.config").get()

local data_path = config.default_note_dir .. "/" .. config.storage.tasks_subdir
local file_path = data_path .. "/tasks." .. config.storage.file_format

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

  if config.storage.file_format == "json" then
    local ok, result = pcall(json_decode, content)
    return ok and result or {}
  else
    -- For other formats, we'll just return an empty table for now
    -- More sophisticated parsing would be needed here for markdown, etc.
    return {}
  end
end

-- Write tasks to file
function M.write_tasks(tasks)
  ensure_dir()
  local fd = io.open(file_path, "w")
  if not fd then
    vim.notify("FKNotes: Failed to write task data", vim.log.levels.ERROR)
    return
  end

  if config.storage.file_format == "json" then
    fd:write(json_encode(tasks))
  else
    -- For other formats, we'll just write a basic representation for now
    -- More sophisticated serialization would be needed here for markdown, etc.
    for _, task in ipairs(tasks) do
      fd:write("- [ ] " .. task.title .. "\n")
    end
  end
  fd:close()
end

return M
