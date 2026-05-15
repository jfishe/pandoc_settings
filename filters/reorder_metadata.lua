-- Reorder Markdown YAML front matter so `title` is first and `tags` is last.
--
-- Usage:
--   pandoc --standalone --lua-filter=reorder_metadata.lua \
--     --to=markdown input.md
--
-- This filter rewrites Markdown-family output formats when Pandoc is reading a
-- single named input file with YAML front matter at the top. It preserves the
-- original front matter text for standard top-level YAML mappings and only moves
-- the top-level `title` and `tags` entries.
--
-- Pandoc Lua filters do not expose whether `--standalone` was requested, so this
-- filter cannot enforce that requirement. Use `--standalone` to match Pandoc's
-- normal metadata-preservation behavior. The filter also does not operate on
-- stdin or on multiple input files. Pandoc's Markdown writer controls the final
-- output newlines, so this filter emits reordered YAML using LF line endings.

local function is_markdown_output()
  return FORMAT:match("^markdown") or FORMAT == "gfm" or FORMAT:match("^commonmark")
end

local function read_file(path)
  local handle = io.open(path, "r")
  if not handle then
    return nil
  end

  local text = handle:read("*a")
  handle:close()

  if not text then
    return nil
  end

  return {
    normalized = text:gsub("\r\n", "\n"),
  }
end

local function split_lines(text)
  local lines = {}

  if text == "" then
    return lines
  end

  if text:sub(-1) ~= "\n" then
    text = text .. "\n"
  end

  for line in text:gmatch("(.-)\n") do
    table.insert(lines, line)
  end

  return lines
end

local function extract_front_matter(text)
  local lines = split_lines(text)
  if lines[1] ~= "---" then
    return nil
  end

  local header_lines = {}
  for i = 2, #lines do
    local line = lines[i]
    if line == "---" or line == "..." then
      return header_lines
    end

    table.insert(header_lines, line)
  end

  return nil
end

local function top_level_key(line)
  if line == "" or line:match("^%s") or line:match("^#") then
    return nil
  end

  return line:match("^([^%s][^:]-):")
end

local function reorder_front_matter(lines)
  local preamble = {}
  local entries = {}
  local current = nil

  for _, line in ipairs(lines) do
    local key = top_level_key(line)

    if key then
      if current then
        table.insert(entries, current)
      end

      current = {
        key = key,
        lines = {line},
      }
    elseif current then
      table.insert(current.lines, line)
    else
      table.insert(preamble, line)
    end
  end

  if current then
    table.insert(entries, current)
  end

  local title_entry = nil
  local tags_entry = nil
  local middle_entries = {}

  for _, entry in ipairs(entries) do
    if entry.key == "title" and not title_entry then
      title_entry = entry
    elseif entry.key == "tags" and not tags_entry then
      tags_entry = entry
    else
      table.insert(middle_entries, entry)
    end
  end

  local out = {"---"}

  for _, line in ipairs(preamble) do
    table.insert(out, line)
  end

  if title_entry then
    for _, line in ipairs(title_entry.lines) do
      table.insert(out, line)
    end
  end

  for _, entry in ipairs(middle_entries) do
    for _, line in ipairs(entry.lines) do
      table.insert(out, line)
    end
  end

  if tags_entry then
    for _, line in ipairs(tags_entry.lines) do
      table.insert(out, line)
    end
  end

  table.insert(out, "---")
  table.insert(out, "")

  return table.concat(out, "\n")
end

function Pandoc(doc)
  if not is_markdown_output() then
    return doc
  end

  local input_files = PANDOC_STATE.input_files or {}
  if #input_files ~= 1 or input_files[1] == "-" then
    return doc
  end

  local source = read_file(input_files[1])
  if not source then
    return doc
  end

  local front_matter = extract_front_matter(source.normalized)
  if not front_matter then
    return doc
  end

  local reordered = reorder_front_matter(front_matter)

  doc.meta = pandoc.Meta({})
  table.insert(doc.blocks, 1, pandoc.RawBlock(FORMAT, reordered))

  return doc
end
