vim.opt.guicursor = "n-v-c-sm:block-blinkwait5000-blinkoff700-blinkon250,i-ci-ve:ver25,r-cr-o:ver25"
vim.opt.cursorline = true

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 2
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.g.mapleader = " "

vim.opt.mouse = "a"

vim.opt.termguicolors = true
vim.opt.conceallevel = 0
vim.opt.pumheight = 10
vim.opt.showtabline = 0
vim.opt.splitright = true

vim.opt.smartcase = true
vim.opt.scrolloff = 12
vim.opt.sidescrolloff = 12

vim.opt.swapfile = false

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})
