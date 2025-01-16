vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt

opt.relativenumber = true
opt.number = true

-- tabs and indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true
opt.wrap = false

--search setting
opt.ignorecase = true
opt.smartcase = true

opt.cursorline = true

-- colour
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"

--backspace
opt.backspace = "indent,eol,start"
--clipBoard
vim.cmd("set clipboard+=unnamedplus")

--splitting
opt.splitright = true
opt.splitbelow = true

--Personal
vim.cmd("map <C-a> <esc>ggVG<CR>")
vim.api.nvim_set_keymap("n", "<C-c>", ":!clear && g++ -o %:r.out % -std=c++17<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-x>", ":vsplit | term ./%:r.out<CR>i", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<F9>", ":Test<CR>", { noremap = true, silent = true })
