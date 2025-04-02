vim.cmd [[
    highlight Normal guibg=NONE
    highlight NonText guibg=NONE
]]

require("custom.core")
require("custom.lazy")
require("nvim-tree").setup()
