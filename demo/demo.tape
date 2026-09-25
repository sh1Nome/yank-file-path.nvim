# Where should we write the GIF?
Output demo.gif

# Set up a 960x540 terminal with 24px font.
Set Shell bash
Set FontSize 20
Set Width 960
Set Height 540
Set Padding 0

# Type a command in the terminal.
Hide

Type 'NVIM_DEMO_CONFIG="$(pwd)/demo.lua"'
Enter
Type 'nvim() { command nvim -u "$NVIM_DEMO_CONFIG"; }'
Enter
Type 'cd ..'
Enter
Type 'clear'
Enter

Show

Sleep 500ms

Type "nvim"
Sleep 1000ms
Enter
Sleep 1000ms
Type ":e lua/yank-file-path/init.lua"
Sleep 1000ms
Enter
Sleep 1000ms
Type ":lua require('yank-file-path').yank_file_path_code_block({start_line = 24, end_line = 28})"
Sleep 1000ms
Enter
Type ":enew"
Sleep 1000ms
Enter
Type ":put +"
Sleep 1000ms
Enter
Sleep 1000ms

Sleep 500ms

