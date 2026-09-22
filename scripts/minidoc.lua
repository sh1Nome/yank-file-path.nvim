local minidoc = require("mini.doc")

if _G.MiniDoc == nil then
	minidoc.setup()
end

MiniDoc.generate({ "lua/yank-file-path/init.lua" }, "doc/yank-file-path.txt")
