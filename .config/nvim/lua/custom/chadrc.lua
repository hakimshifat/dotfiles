---@type ChadrcConfig
--- replaing default configs of nvCHAD
local M = {}

M.ui = { theme = 'monekai' }
M.plugins = 'custom.plugins'
require('custom.keymapping')

return M

