---@type ChadrcConfig
--- replaing default configs of nvCHAD
local M = {}

M.ui = { theme = 'catppuccin' }
M.plugins = 'custom.plugins'
require('custom.keymapping')

return M

