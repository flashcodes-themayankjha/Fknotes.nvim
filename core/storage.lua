
local M = {}

local json = vim.fn.stdpath("data") .. "/fknotes/tasks.json"

-- Ensure folder and empty JSON file exists
function M._ensure_file()
  if vim.fn.filereadable(json) == 0 then
    vim.fn.mkdir(vim.fn.fnamemodify(json, ":h"), "p")
    vim.fn.writefile({ "{}" }, json) -- empty JSON object
  end
end

-- Load tasks from JSON file
function M.load_tasks()
  M._ensure_file()
  local ok, data = pcall(vim.fn.readfile, json)
  if not ok or not data then return {} end
  local decoded = vim.fn.json_decode(table.concat(data, "\n"))
  return decoded or {}
end

-- Save tasks to JSON file
function M.save_tasks(tasks)
  M._ensure_file()
  local json_string = vim.fn.json_encode(tasks)
  vim.fn.writefile({ json_string }, json)
end

return M
