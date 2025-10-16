
local M = {}

local json_encode = vim.fn.json_encode
local json_decode = vim.fn.json_decode

local config = require("fknotes.config").get()
local notify = require("fknotes.core.notify")

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
  if not fd then return {} end

  local content = fd:read("*a")
  fd:close()

  if config.storage.file_format == "json" then
    local ok, result = pcall(json_decode, content)
    return ok and result or {}
  else
    return {}
  end
end

-- Write tasks to file
function M.write_tasks(tasks)
  ensure_dir(tasks_data_path)
  local fd = io.open(tasks_file_path, "w")
  if not fd then
    notify.error("Failed to write FKNotes task data")
    return
  end

  if config.storage.file_format == "json" then
    fd:write(json_encode(tasks))
  else
    for _, task in ipairs(tasks) do
      fd:write(("- [ ] %s (due: %s)\n"):format(task.text, task.due or "none"))
    end
  end
  fd:close()
end

-- Read notebooks from file
function M.read_notebooks()
  ensure_dir(notebooks_data_path)
  local fd = io.open(notebooks_file_path, "r")
  if not fd then return {} end

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
    notify.error("Failed to write FKNotes notebooks data")
    return
  end

  if config.storage.file_format == "json" then
    fd:write(json_encode(notebooks))
  else
    for _, notebook in ipairs(notebooks) do
      fd:write("# " .. notebook.name .. "\n")
      if notebook.description and notebook.description ~= "" then
        fd:write(notebook.description .. "\n")
      end
      fd:write("\n")
    end
  end
  fd:close()
end

-- Add a new notebook
function M.create_notebook(name, description)
  local notebooks = M.read_notebooks()
  local new_notebook = {
    name = name,
    description = description or "",
    created_at = os.date("%Y-%m-%d %H:%M:%S"),
  }
  table.insert(notebooks, new_notebook)
  M.write_notebooks(notebooks)
end

-- List all notebooks
function M.list_notebooks()
  local notebooks = M.read_notebooks()
  local names = {}
  for _, notebook in ipairs(notebooks) do
    table.insert(names, notebook.name)
  end
  return names
end

---------------------------------------------------------------------
-- 🔥 FKNotes Inline Task Management
---------------------------------------------------------------------

--- Add or update task (used by parser)
---@param task table
function M.add_task(task)
  local tasks = M.read_tasks()

  -- Deduplicate: avoid multiple entries from same file + line
  for i, t in ipairs(tasks) do
    if t.file == task.file and t.line == task.line then
      tasks[i].title = task.title or task.text -- Handle both
      if tasks[i].text then tasks[i].text = nil end -- Clean up
      tasks[i].priority = task.priority
      tasks[i].due_date = task.due_date
      if tasks[i].due then tasks[i].due = nil end -- Clean up
      tasks[i].tags = task.tags
      tasks[i].updated_at = os.date("%Y-%m-%d %H:%M:%S")
      M.write_tasks(tasks)
      return
    end
  end

  -- New task
  if task.text and not task.title then
    task.title = task.text
    task.text = nil
  end
  task.created_at = os.date("%Y-%m-%d %H:%M:%S")
  table.insert(tasks, task)
  M.write_tasks(tasks)
end

--- Get all tasks
---@return table[]
function M.get_all_tasks()
  return M.read_tasks()
end

--- Sync inline FKNotes from buffer to storage
---@param bufnr number
function M.sync_buffer_tasks(bufnr)
  local parser = require("fknotes.core.parser")
  local diagnostics = require("fknotes.core.diagnostics")

  local parsed = parser.parse_buffer(bufnr)
  local diagnostics_items = {}

  for _, note in ipairs(parsed) do
    local filepath = vim.api.nvim_buf_get_name(bufnr)
    local task = {
      file = filepath,
      line = note.line,
      text = note.text,
      tag = note.tag,
      priority = note.priority,
      due = note.due,
      tags = note.tags,
    }

    M.add_task(task)

    -- Add diagnostic marker
    table.insert(diagnostics_items, {
      lnum = note.line - 1,
      col = 0,
      message = ("@fknotes %s: %s"):format(note.tag, note.text),
      severity = vim.diagnostic.severity.INFO,
      source = "FkNotes",
    })
  end

  diagnostics.set_diagnostics(bufnr, diagnostics_items)
end

return M
