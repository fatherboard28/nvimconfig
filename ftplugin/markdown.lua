vim.keymap.set("n", "<leader>'", "<cmd>RenderMarkdown toggle<cr>")
vim.opt.wrap = true
require('render-markdown').setup({
  heading = {
    position = 'inline',
    border = true,
    border_virtual = false,
    backgrounds = {},
    signs = {},
    above = '▄',
    below = '▀',
    border_prefix = true,
  },
})
