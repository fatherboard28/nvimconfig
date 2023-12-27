local keymap = vim.keymap.set
local opts = { silent = true }

vim.g.mapleader = " "

-- Modes
-- normal = "n"
-- insert = "i"
-- visual = "v"
-- vblock = "x"
-- term   = "t"
-- command= "c"

--exit into netrw
keymap("n", "<leader>=", "<cmd>Ex<CR>", opts)
