# yank-file-path.nvim

Copy file paths and code blocks to the clipboard.

## Features

- Copy a path relative to Neovim's current working directory
- Append inclusive line references such as `#L10` or `#L10-L20`
- Copy a file path with the entire buffer or a line range in a fenced code block
- Copy text to the `+` register, notify with `vim.notify()`, and return the copied text

## Installation

Use your preferred plugin manager.

## Usage

Add user commands that pass an optional line range to the public functions:

```lua
local yank_file_path = require("yank-file-path")

local function get_yank_file_path_options(opts)
  if opts.range == 0 then
    return {}
  end
  return {
    start_line = opts.line1,
    end_line = opts.line2,
  }
end

vim.api.nvim_create_user_command("YankFilePath", function(opts)
  yank_file_path.yank_file_path(get_yank_file_path_options(opts))
end, { range = true, desc = "Copy relative file path" })

vim.api.nvim_create_user_command("YankFilePathCodeBlock", function(opts)
  yank_file_path.yank_file_path_code_block(get_yank_file_path_options(opts))
end, { range = true, desc = "Copy relative file path and code block" })
```

`:YankFilePath` copies the current file path. `:YankFilePathCodeBlock` copies
the file path and the entire buffer in a fenced code block. Run either command
with a line range, such as `:'<,'>YankFilePath`, to pass one-based, inclusive
`start_line` and `end_line` values and append a reference such as `#L10-L20`.

See `:help yank-file-path` for the complete API documentation.

## License

MIT License. Copyright (c) 2026 sh1Nome
