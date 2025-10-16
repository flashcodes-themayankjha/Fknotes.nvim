local M = {}

-- Pattern for @fknotes parsing
-- Example:
-- @fknotes TODO: Refactor code @high –2025-10-20 #tag1 #tag2
local pattern = "@fknotes%s+(%u+):%s*(.*)"

--- Parse a line for FKNotes entries
---@param line string
---@param linenr number
---@return table|nil
function M.parse_line(line, linenr)
  vim.notify("--- PARSING START ---")
  vim.notify("Original line: " .. line)
  local tag, rest_of_line = line:match(pattern)
  if not tag or not rest_of_line then
    vim.notify("Parse failed: No tag found.")
    return nil
  end

  local task = rest_of_line
  local priority_keyword = nil
  local date_for_storage = nil

  -- 1. Extract tags and identify priority tags
  local tags_list = {}
  for t in task:gmatch("#([%w_]+)") do
    local t_lower = t:lower()
    if (t_lower == "high" or t_lower == "medium" or t_lower == "low") and not priority_keyword then
      priority_keyword = t_lower
    else
      table.insert(tags_list, t)
    end
  end
  task = vim.trim(task:gsub("%s*#([%w_]+)", ""))
  vim.notify("After tag strip: " .. task)

  -- 2. Extract date (absolute or relative)
  local abs_date_match = { task:match("^(.-)%s*[%–%-]%s*(%d%d%d%d%-%d%d%-%d%d)$") }
  if abs_date_match[1] then
    task = vim.trim(abs_date_match[1])
    date_for_storage = abs_date_match[2]
  else
    local rel_date_match = { task:match("^(.-)%s*[%–%-]%s*(%d+)([dwmyDWMY])$") }
    if rel_date_match[1] then
      task = vim.trim(rel_date_match[1])
      local num = tonumber(rel_date_match[2])
      local unit = rel_date_match[3]:lower()
      local now = os.date("*t")
      if unit == 'd' then now.day = now.day + num
      elseif unit == 'w' then now.day = now.day + (num * 7)
      elseif unit == 'm' then now.month = now.month + num
      elseif unit == 'y' then now.year = now.year + num end
      date_for_storage = os.date("%Y-%m-%d", os.time(now))
    end
  end
  vim.notify("After date strip: " .. task)

  -- 3. Extract @priority as an override
  local priority_match = { task:match("^(.-)%s*@([%w_]+)$") }
  if priority_match[1] then
    task = vim.trim(priority_match[1])
    priority_keyword = priority_match[2]
  end
  vim.notify("After priority strip: " .. task)
  vim.notify("Priority keyword found: " .. tostring(priority_keyword))

  -- 4. Map keyword to display string
  local priority_map = { high = "🔴 High", medium = "🟠 Medium", low = "🟢 Low", none = "⚪ None" }
  local final_priority = "⚪ None" -- Default
  if priority_keyword then
    final_priority = priority_map[priority_keyword:lower()] or priority_keyword
  end

  local final_title = vim.trim(task)
  vim.notify("Final Title: " .. final_title)
  vim.notify("Final Priority: " .. final_priority)
  vim.notify("--- PARSING END ---")

  return {
    line = linenr,
    tag = tag,
    title = final_title,
    priority = final_priority,
    due_date = date_for_storage,
    tags = tags_list,
  }
end

--- Parse all lines in a buffer
---@param bufnr number
---@return table[]
function M.parse_buffer(bufnr)
  local results = {}
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  for i, line in ipairs(lines) do
    local note = M.parse_line(line, i)
    if note then
      table.insert(results, note)
    end
  end

  return results
end

return M

