
local diagnostics = require("fknotes.core.diagnostics")
local notify = require("fknotes.core.notify")
local storage = require("fknotes.core.storage")

local M = {}

-- Namespace for highlighter
local hl_ns = vim.api.nvim_create_namespace("FkNotesHighlighter")


-- Highlight and sign placement
function M.highlight_buffer(bufnr)
  if not vim.api.nvim_buf_is_loaded(bufnr) then return end
  vim.api.nvim_buf_clear_namespace(bufnr, hl_ns, 0, -1)
  vim.fn.sign_unplace("FkNotesSigns", { buffer = bufnr })

  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local diagnostics_data = {}
  local fk_pattern = "@fknotes%s+(%u+):%s*(.*)"

  for linenr, line in ipairs(lines) do
    local tag, rest_of_line = line:match(fk_pattern)

    if tag and rest_of_line then
      local task = rest_of_line
      local priority_keyword = nil
      local date_str_for_highlight = nil
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

      -- 2. Date parsing
      local abs_date_match = { task:match("^(.-)([%–%-]%s*%d%d%d%d%-%d%d%-%d%d)$") }
      if abs_date_match[1] then
        task = vim.trim(abs_date_match[1])
        date_str_for_highlight = vim.trim(abs_date_match[2])
        date_for_storage = date_str_for_highlight:match("%d%d%d%d%-%d%d%-%d%d")
      else
        local rel_date_match = { task:match("^(.-)([%–%-]%s*%d+[dwmyDWMY])$") }
        if rel_date_match[1] then
          task = vim.trim(rel_date_match[1])
          date_str_for_highlight = vim.trim(rel_date_match[2])
          local num, unit = date_str_for_highlight:match("[%–%-]%s*(%d+)([dwmyDWMY])")
          num = tonumber(num)
          unit = unit:lower()
          local now = os.date("*t")
          if unit == 'd' then now.day = now.day + num
          elseif unit == 'w' then now.day = now.day + (num * 7)
          elseif unit == 'm' then now.month = now.month + num
          elseif unit == 'y' then now.year = now.year + num end
          date_for_storage = os.date("%Y-%m-%d", os.time(now))
        end
      end

      -- 3. Extract @priority as an override
      local priority_match = { task:match("^(.-)%s*@([%w_]+)$") }
      if priority_match[1] then
        task = vim.trim(priority_match[1])
        priority_keyword = priority_match[2]
      end

      -- 4. Map keyword to display string
      local priority_map = { high = "🔴 High", medium = "🟠 Medium", low = "🟢 Low", none = "⚪ None" }
      local final_priority = "⚪ None" -- Default
      if priority_keyword then
        final_priority = priority_map[priority_keyword:lower()] or priority_keyword
      end

      local title_text = vim.trim(task)

      -- Highlighting via overlay
      local kw_s, kw_e = line:find("@fknotes")
      vim.api.nvim_buf_add_highlight(bufnr, hl_ns, "FkNotesKeyword", linenr - 1, kw_s - 1, kw_e)

      local tag_s, tag_e = line:find(tag .. ":", kw_e)
      vim.api.nvim_buf_add_highlight(bufnr, hl_ns, "FkNotesTag" .. tag, linenr - 1, tag_s - 1, tag_e)

      local title_start = tag_e + 1
      vim.api.nvim_buf_add_highlight(bufnr, hl_ns, "FkNotesTitle" .. tag, linenr - 1, title_start - 1, -1)

      if priority_keyword then
        local prio_marker = "[#@]" .. priority_keyword
        local prio_s, prio_e = line:find(prio_marker, title_start)
        if prio_s then
          local prio_hl = "FkNotesPriorityMedium"
          if priority_keyword:lower() == "high" then prio_hl = "FkNotesPriorityHigh"
          elseif priority_keyword:lower() == "low" then prio_hl = "FkNotesPriorityLow" end
          vim.api.nvim_buf_add_highlight(bufnr, hl_ns, prio_hl, linenr - 1, prio_s - 1, prio_e)
        end
      end

      if date_str_for_highlight then
        local date_s, date_e = line:find(date_str_for_highlight, title_start, true)
        if date_s then
          vim.api.nvim_buf_add_highlight(bufnr, hl_ns, "FkNotesMeta", linenr - 1, date_s - 1, date_e)
        end
      end

      for _, t_str in ipairs(tags_list) do
        local tag_marker = "#" .. t_str
        local t_s, t_e = line:find(tag_marker, title_start)
        if t_s then
          vim.api.nvim_buf_add_highlight(bufnr, hl_ns, "FkNotesMeta", linenr - 1, t_s - 1, t_e)
        end
      end

      if vim.bo[bufnr].filetype ~= "todo_project" then
        -- Place the sign
        vim.fn.sign_place(0, "FkNotesSigns", "FkNotes" .. tag, bufnr, { lnum = linenr, priority = 40 })

        -- Add diagnostic entry
        table.insert(diagnostics_data, {
          lnum = linenr - 1,
          col = kw_s - 1,
          severity = vim.diagnostic.severity.INFO,
          message = "[" .. tag .. "] " .. title_text,
          source = "FkNotes",
        })
      end

      -- Add to task storage
      storage.add_task({
        buffer = vim.api.nvim_buf_get_name(bufnr),
        line = linenr,
        tag = tag,
        title = title_text,
        priority = final_priority,
        due_date = date_for_storage,
        tags = tags_list,
      })

      -- Due date notification
      if date_for_storage and M.is_due_soon(date_for_storage) then
        notify.info("Task '" .. title_text .. "' is due soon (" .. date_for_storage .. ") ⚠️")
      end
    end
  end

  diagnostics.set_diagnostics(bufnr, diagnostics_data)
end

-- Helper to check due date proximity
function M.is_due_soon(date_str)
  local today = os.date("%Y-%m-%d")
  local y1, m1, d1 = date_str:match("(%d+)%-(%d+)%-(%d+)")
  local y2, m2, d2 = today:match("(%d+)%-(%d+)%-(%d+)")
  if not (y1 and y2) then return false end
  local due = os.time { year = y1, month = m1, day = d1 }
  local now = os.time { year = y2, month = m2, day = d2 }
  local diff = math.floor((due - now) / 86400)
  return diff >= 0 and diff <= 2
end

-- Attach autocommands to scan buffers automatically
function M.attach_autocmd()
  vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "TextChanged" }, {
    callback = function(args)
      M.highlight_buffer(args.buf)
    end,
  })
end

return M
