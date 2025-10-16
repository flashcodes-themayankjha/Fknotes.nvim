local M = {}

-- Namespace for FKNotes diagnostics
local ns = vim.api.nvim_create_namespace("FkNotesDiagnostics")

-- Default config for diagnostics display
vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

-- Set diagnostics for a buffer
function M.set_diagnostics(bufnr, items)
  if not vim.api.nvim_buf_is_valid(bufnr) then return end
  vim.diagnostic.reset(ns, bufnr)

  local diagnostics = {}
  for _, d in ipairs(items or {}) do
    table.insert(diagnostics, {
      lnum = d.lnum or 0,
      col = d.col or 0,
      severity = d.severity or vim.diagnostic.severity.INFO,
      message = d.message or "",
      source = d.source or "FkNotes",
    })
  end

  vim.diagnostic.set(ns, bufnr, diagnostics, {})
end

-- Clear all FKNotes diagnostics globally
function M.clear_all()
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    vim.diagnostic.reset(ns, bufnr)
  end
end

return M

