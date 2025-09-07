local M = {}

local json_encode = vim.fn.json_encode
local json_decode = vim.fn.json_decode

local config = require("fknotes.config").get()

-- Task storage paths
local tasks_data_path = config.default_note_dir .. "/" .. config.storage.tasks_subdir
local tasks_file_path = tasks_data_path .. "/tasks." .. config.storage.file_format

-- Notebook storage paths
local notebooks_data_path = config.default_note_dir .. "/" .. config.storage.notes_subdir
local notebooks_file_path = notebooks_data_path .. "/notebooks." .. config.storage.file_format

-- Ensure directory exists
local function ensure_dir(path)
  if vim.fn.isdirectory(path) == 0 then
    vim.fn.mkdir(path, "p")
  end
end

-- Read tasks from file
function M.read_tasks()
  ensure_dir(tasks_data_path)
  local fd = io.open(tasks_file_path, "r")
  if not fd then return {}
  end

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
  ensure_dir(tasks_data_path)
  local fd = io.open(tasks_file_path, "w")
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

-- Read notebooks from file
function M.read_notebooks()
  ensure_dir(notebooks_data_path)
  local fd = io.open(notebooks_file_path, "r")
  if not fd then return {}
  end

  local content = fd:read("*a")
  fd:close()

  if config.storage.file_format == "json" then
    local ok, result = pcall(json_decode, content)
    return ok and result or {}
  else
    return {}
  end
end

-- Write notebooks to file
function M.write_notebooks(notebooks)
  ensure_dir(notebooks_data_path)
  local fd = io.open(notebooks_file_path, "w")
  if not fd then
    vim.notify("FKNotes: Failed to write notebook data", vim.log.levels.ERROR)
    return
  end

  if config.storage.file_format == "json" then
    fd:write(json_encode(notebooks))
  else
    -- Placeholder for other formats
    for _, notebook in ipairs(notebooks) do
      fd:write("# " .. notebook.name .. "\n")
      if notebook.description and notebook.description ~= "" then
        fd:write(notebook.description .. "\n")
      end
      fd:write("\n") -- Add a blank line for separation
    end
  end
  fd:close()
end

-- Add a new notebook
function M.create_notebook(name, description)
  local notebooks = M.read_notebooks()
  local new_notebook = {
    name = name,
    description = description or "", -- Ensure description is not nil
    created_at = os.date("%Y-%m-%d %H:%M:%S"),
  }
  table.insert(notebooks, new_notebook)
  M.write_notebooks(notebooks)
end

function M.list_notebooks()
  local notebooks = M.read_notebooks()
  local names = {}
  for _, notebook in ipairs(notebooks) do
    table.insert(names, notebook.name)
  end
  return names
end

return M