vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt

opt.relativenumber = true
opt.number = true

-- tabs and indentation
opt.tabstop = 4 -- 4 spaces for tabs
opt.shiftwidth = 4 -- 4 spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one

opt.list = true
opt.listchars = { space = "·", tab = "→ ", extends = "⫸", precedes = "⫷" }

opt.wrap = false -- dont wrap line

opt.swapfile = false
opt.backup = false
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.undofile = true

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

-- preview substitutions in cmdline like `%s/opt/test
opt.inccommand = "split"

opt.cursorline = true
opt.scrolloff = 10

-- turn on termguicolors for colorschemes to work
opt.termguicolors = true
opt.background = "dark" -- colorscehems that can be light or dark will be made dark
opt.signcolumn = "yes" -- Keep signcolumn on by default on the left sidebar - gitchanges/breakpoints

-- Decrease update time
opt.updatetime = 50

-- Displays which-key popup sooner
opt.timeoutlen = 300

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
-- opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom


