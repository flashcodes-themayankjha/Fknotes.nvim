local M = {}
local json_path = vim.fn.stdpath("data") .. "/fknotes/tasks.json"

function M._ensure_file()
  if vim.fn.filereadable(json_path) == 0 then
    vim.fn.mkdir(vim.fn.fnamemodify(json_path, ":h"), "p")
    vim.fn.writefile(vim.fn.json_encode({}), json_path)
  end
end

function M.load_tasks()
  M._ensure_file()
  local ok, data = pcall(vim.fn.readfile, json_path)
  if not ok then return {} end

  local decoded = vim.fn.json_decode(table.concat(data, "\n"))
  return decoded or {}
end

function M.save_tasks(tasks)
  vim.fn.writefile({vim.fn.json_encode(tasks)}, json_path)
end

return M

