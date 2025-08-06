local export_config = require("fknotes").config.export
local core_config = require("fknotes").config

local M = {}

-- 🔐 Makes a safe filename from a task or note title
local function sanitize_filename(name)
  return name:gsub("[^%w%s%-_]", ""):gsub("%s+", "_")
end

-- ✍️ Save given content to a file
local function write_to_file(subdir, title, content)
  local base_dir = export_config.export_dir
  local filename = sanitize_filename(title) .. "." .. export_config.default_format
  local full_path = base_dir .. "/" .. subdir .. "/" .. filename

  vim.fn.mkdir(base_dir .. "/" .. subdir, "p") -- ensure dir exists
  local f = io.open(full_path, "w+")
  if not f then
    vim.notify("Failed to write to: " .. full_path, vim.log.levels.ERROR)
    return
  end
  f:write(content)
  f:close()

  vim.notify("📝 Exported to: " .. full_path, vim.log.levels.INFO)
end

-- 📤 Export a task (used from task_form.lua)
M.export_task = function(task)
  local lines = {
    "# " .. (task.title or "(no title)"),
    "",
    "**Priority:** " .. (task.priority or "-"),
    "**Due Date:** " .. (task.due_date or "-"),
    "**Created At:** " .. (task.created_at or ""),
    "",
    (task.description or ""),
  }

  if task.tags and #task.tags > 0 then
    table.insert(lines, "")
    table.insert(lines, "**Tags:** " .. table.concat(task.tags, ", "))
  end

  write_to_file(core_config.storage.tasks_subdir, task.title, table.concat(lines, "\n"))
end

-- 📤 Export a note (once note_form is added)
M.export_note = function(note)
  local lines = {
    "# " .. (note.title or "(no title)"),
    "",
    "**Created:** " .. os.date("%Y-%m-%d %H:%M"),
    "",
    (note.content or "")
  }

  if note.tags and #note.tags > 0 then
    table.insert(lines, "")
    table.insert(lines, "**Tags:** " .. table.concat(note.tags, ", "))
  end

  write_to_file(core_config.storage.notes_subdir, note.title, table.concat(lines, "\n"))
end

return M

