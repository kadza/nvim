local M = {}

M.format_buffer = function()
  local indent = "  "

  local function format_xml(xml)
    local max_line_length = 120
    local formatted = {}
    local stack = {} -- tag stack to manage nesting levels

    local function current_indent()
      return indent:rep(#stack)
    end

    local function format_opening_tag(tag)
      local tag_name = tag:match("^<%s*(%S+)")
      local attrs_str = tag:match("^<%s*%S+%s+(.-)[/]?>") or ""
      local attrs = {}
      for attr in attrs_str:gmatch('(%S-=%b"")') do
        table.insert(attrs, attr)
      end
      local self_closing = tag:match("/>$")
      local close = self_closing and " />" or ">"
      local base = "<" .. tag_name

      local flat = base
      if #attrs > 0 then
        flat = flat .. " " .. table.concat(attrs, " ")
      end
      flat = flat .. close

      if #flat <= max_line_length then
        return { flat }
      end

      -- Multiline attributes
      local lines = { base }
      for _, attr in ipairs(attrs) do
        table.insert(lines, indent .. attr)
      end
      lines[#lines] = lines[#lines] .. close
      return lines
    end

    local pos = 1
    while true do
      local open_start, open_end, open_tag = xml:find("<([^/][^>%s/>]*)[^>]*>", pos)
      if not open_start then
        break
      end

      local before = xml:sub(pos, open_start - 1)
      if before:match("%S") then
        table.insert(formatted, current_indent() .. before)
      end

      local full_open_tag = xml:sub(open_start, open_end)
      local is_self_closing = full_open_tag:match("/>$")
      local tag_name = full_open_tag:match("^<%s*(%S+)")

      local open_lines = format_opening_tag(full_open_tag)
      for _, line in ipairs(open_lines) do
        table.insert(formatted, current_indent() .. line)
      end

      if not is_self_closing then
        table.insert(stack, tag_name)

        -- Look for children or content
        local content_start = open_end + 1
        local next_close_tag = "</" .. tag_name .. ">"
        local close_start, close_end = xml:find(next_close_tag, content_start, true)
        if close_start then
          local content = xml:sub(content_start, close_start - 1)
          if content:match("%S") then
            pos = content_start
            -- Recursively format inner content
            local sub = format_xml(content)
            for line in sub:gmatch("[^\r\n]+") do
              table.insert(formatted, indent .. line)
            end
            pos = close_end + 1
          else
            pos = close_end + 1
          end

          table.insert(formatted, current_indent() .. next_close_tag)
        else
          -- malformed: no close tag found
          pos = open_end + 1
        end

        table.remove(stack)
      else
        pos = open_end + 1
      end
    end

    local tail = xml:sub(pos)
    if tail:match("%S") then
      table.insert(formatted, current_indent() .. tail)
    end

    return table.concat(formatted, "\n")
  end

  -- Main logic
  local buf = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local xml = table.concat(lines, "\n")
  local result = format_xml(xml)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(result, "\n"))
end

return M
