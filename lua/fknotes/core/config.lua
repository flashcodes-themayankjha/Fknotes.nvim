local M = {}
local config = require("fknotes").config

-- Access configuration values
M.obsidian_path = config.obsidian_path
M.default_note_dir = config.default_note_dir
M.default_task_priority = config.default_task_priority
M.default_task_due_date = config.default_task_due_date

-- Storage configuration
M.file_format = config.storage.file_format
M.tasks_subdir = config.storage.tasks_subdir
M.notes_subdir = config.storage.notes_subdir

return M

