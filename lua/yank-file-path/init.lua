--- *yank-file-path*  Copy file paths and code blocks to the clipboard
---
---@toc

--- This plugin copies a path relative to Neovim's current working directory to
--- the clipboard. It can add a line range or include the buffer in a fenced
--- code block.
---
--- Both public functions return the copied text.
---@tag yank-file-path-intro
---@toc_entry Introduction

--- Options for selecting an inclusive, one-based line range.
---
--- Specify both fields to copy a line range.
---@class YankFilePathOptions
---@field start_line? integer One-based inclusive start line.
---@field end_line? integer One-based inclusive end line.
---@tag yank-file-path-api-options
---@toc_entry YankFilePathOptions

local M = {}

local function get_relative_path()
	local buffer_path = vim.api.nvim_buf_get_name(0)
	local relative_path = vim.fn.fnamemodify(buffer_path, ":.")
	return (relative_path:gsub("\\", "/"))
end

local function resolve_line_range(opts, use_full_buffer)
	local start_line = opts.start_line
	local end_line = opts.end_line
	if start_line == nil and end_line == nil then
		if use_full_buffer then
			return 1, vim.api.nvim_buf_line_count(0)
		end
		return
	end

	if start_line > end_line or end_line > vim.api.nvim_buf_line_count(0) then
		return
	end

	return start_line, end_line
end

local function format_reference(relative_path, start_line, end_line)
	if not start_line then
		return relative_path
	end
	if start_line == end_line then
		return ("%s#L%d"):format(relative_path, start_line)
	end
	return ("%s#L%d-L%d"):format(relative_path, start_line, end_line)
end

local function copy_to_clipboard(text)
	vim.fn.setreg("+", text)
	return text
end

--- Copy the current file path, optionally with a line range, to the clipboard.
---
--- With no range, return the relative path. With a valid range, append a
--- `#L<start>` or `#L<start>-L<end>` line reference.
---
---@param opts? YankFilePathOptions See |yank-file-path-api-options|.
---@return string|nil copied text, or nil when the line range is invalid.
---@tag yank-file-path-api-yank-file-path
---@toc_entry yank_file_path()
function M.yank_file_path(opts)
	opts = opts or {}
	local relative_path = get_relative_path()

	local has_range = opts.start_line ~= nil or opts.end_line ~= nil
	local start_line, end_line = resolve_line_range(opts, false)
	if has_range and not start_line then
		vim.notify("cannot copy file path: invalid line range", vim.log.levels.ERROR)
		return
	end

	local reference = format_reference(relative_path, start_line, end_line)
	copy_to_clipboard(reference)
	vim.notify(reference, vim.log.levels.INFO)
	return reference
end

--- Copy the current file path and buffer contents in a code block to the
--- clipboard.
---
--- With no range, include the entire buffer. With a valid range, include only
--- the specified lines.
---
---@param opts? YankFilePathOptions See |yank-file-path-api-options|.
---@return string|nil copied text, or nil when the line range is invalid.
---@tag yank-file-path-api-yank-file-path-code-block
---@toc_entry yank_file_path_code_block()
function M.yank_file_path_code_block(opts)
	opts = opts or {}
	local relative_path = get_relative_path()

	local start_line, end_line = resolve_line_range(opts, true)
	if not start_line then
		vim.notify("cannot copy file path and code block: invalid line range", vim.log.levels.ERROR)
		return
	end

	local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
	local filetype = vim.bo.filetype
	local reference = format_reference(relative_path, opts.start_line, opts.end_line)
	local text = table.concat({
		reference,
		"",
		"```" .. filetype,
		table.concat(lines, "\n"),
		"```",
	}, "\n")

	copy_to_clipboard(text)
	vim.notify(reference .. " with code block", vim.log.levels.INFO)
	return text
end

--- This plugin is distributed under the MIT License.
--- See the repository's `LICENSE` file for the full license text.
---@tag yank-file-path-license
---@toc_entry License

return M
