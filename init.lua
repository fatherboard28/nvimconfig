-----------------------------------------------------------------------------------------
--SETTINGS
-----------------------------------------------------------------------------------------
vim.opt.guicursor = "n-v-c-sm:hor25,i-ci-ve:ver25,r-cr-o:ver25"
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

-----------------------------------------------------------------------------------------
--Keymaps
-----------------------------------------------------------------------------------------
local keymap = vim.keymap.set
local opts = { silent = true }

keymap("n", "<leader>=", "<cmd>Ex<CR>", opts)

-----------------------------------------------------------------------------------------
--LAZY CONFIG 
-----------------------------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {"nvim-lua/plenary.nvim"},
  {"folke/trouble.nvim", config = function() 
      require('trouble').setup()
      vim.keymap.set("n", "<leader>z", "<cmd>TroubleToggle quickfix<cr>", {silent = true, noremap = true})
    end,
  },
  { "catppuccin/nvim", 
    name = "catppuccin", 
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        transparent_background = true,
        term_colors = true,
      })
      vim.cmd([[colorscheme catppuccin-mocha]])
    end,
  },
  -- file navigation
  {"ThePrimeagen/harpoon",
    config = function()
      local mark = require("harpoon.mark")
      local ui = require("harpoon.ui")

      vim.keymap.set("n", "<leader>a", mark.add_file)
      vim.keymap.set("n", "<leader>q", ui.toggle_quick_menu)

      vim.keymap.set("n", "<leader>d", function() ui.nav_file(1) end)
      vim.keymap.set("n", "<leader>f", function() ui.nav_file(2) end)
      vim.keymap.set("n", "<leader>j", function() ui.nav_file(3) end)
      vim.keymap.set("n", "<leader>k", function() ui.nav_file(4) end)
    end
  },
  {"nvim-telescope/telescope.nvim",
    config = function()
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>o', builtin.find_files, {})
      vim.keymap.set('n', '<leader>og', builtin.git_files, {})
      vim.keymap.set('n', '<leader>os', function()
        builtin.grep_string({ search = vim.fn.input("Grep > ") })
      end)
      vim.keymap.set('n', '<leader>oh', builtin.help_tags, {})
    end
  },

  --lsp / syntax hylighting stuff
  {"hrsh7th/cmp-nvim-lsp"},
  {"L3MON4D3/LuaSnip"},
  {"saadparwaiz1/cmp_luasnip"},
  {"quangnguyen30192/cmp-nvim-ultisnips"},

  {"hrsh7th/nvim-cmp", 
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "quangnguyen30192/cmp-nvim-ultisnips",
    },
    config = function()
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end
      
      local cmp = require('cmp')
      local luasnip = require('luasnip')
      local ultisnip = require("cmp_nvim_ultisnips")
      ultisnip.setup{}

      cmp.setup({
        snippet = {
          expand = function(args)
            vim.fn["UltiSnips#Anon"](args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert ({
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<s-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, {"i", "s"}),
          ["<leader>x"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({select=true}),
        }),
        sources = {
          {name = "ultisnips"},
          {name = "nvim_lsp"},
          {name = "luasnip"},
        }
      })
    end
  },
  {"hrsh7th/cmp-buffer"},
  {"hrsh7th/cmp-path"},
  {"hrsh7th/cmp-cmdline"},
  {"williamboman/mason.nvim"},
  {"williamboman/mason-lspconfig.nvim"},
  {"neovim/nvim-lspconfig", dependencies = {"williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim"},
    config = function()
      local on_attach = function(client, bufnr)
        -- Enable completion triggered by <c-x><c-o>
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- Mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', 's', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'i', ',s', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', ',wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', ',wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', ',wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', ',D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', ',rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', ',qf', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', ',f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
      end

      local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = {"documentation", "detail", "additionalTextEdits"},
      }

      require('mason').setup()
      local mason_lspconfig = require('mason-lspconfig')
      mason_lspconfig.setup {
        ensure_installed = { 'pyright', 'clangd', 'eslint', 'cssls', 'rust_analyzer' }
      }

      --LSP's Config
      require("lspconfig").pyright.setup {
        on_attach = on_attach,
        capabilities = capabilities,
      }

      require('lspconfig').clangd.setup{
        on_attach = on_attach,
        cmd = {
          "/opt/homebrew/opt/llvm/bin/clangd",
          "--background-index",
          "--pch-storage=memory",
          "--all-scopes-completion",
          "--pretty",
          "--header-insertion=never",
          "-j=4",
          "--inlay-hints",
          "--header-insertion-decorators",
          "--function-arg-placeholders",
          "--completion-style=detailed"
        },
        filetypes = {"c", "cpp", "objc", "objcpp"},
        root_dir = require('lspconfig').util.root_pattern("src"),
        init_option = { fallbackFlags = {  "-std=c++2a"  } },
        capabilities = capabilities
      }

      require('lspconfig').eslint.setup{
        on_attach = on_attach,
        cpabilities = capabilities,
      }

      require('lspconfig').cssls.setup{
        on_attach = on_attach,
        cpabilities = capabilities,
      }
      require('lspconfig').gdscript.setup{
        on_attach = on_attach,
        capabilities = capabilities,
      }
      require('lspconfig').rust_analyzer.setup{
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          ['rust-analyzer'] = {
            diagnostics = {
              disabled = {
                "unresolved-proc-macro",
              },
            }
          }
        }
      }
    end
  },

  {"nvim-treesitter/nvim-treesitter",
    config = function()
      require("nvim-treesitter.configs").setup{
        auto_intsall = false,
        highlight = {
          enable = true,
        },
        autotag = {
          enable = true,
        },
      }
    end
  },
  {"nvim-treesitter/nvim-treesitter-context"},


  {"windwp/nvim-autopairs", 
    event = "InsertEnter",
    opts =  {
    },
  },
  {"windwp/nvim-ts-autotag"},

  --Git
  {"tpope/vim-fugitive"},
  {"lewis6991/gitsigns.nvim",
    config = function()
      require('gitsigns').setup {
        signs = {
          add = { text = '+' },
          change = { text = '~' },
          delete = { text = '_' },
          topdelete = { text = '‾' },
          changedelete = { text = '~' },
        },
        on_attach = function(bufnr)
          vim.keymap.set('n', '[c', require('gitsigns').prev_hunk, { buffer = bufnr })
          vim.keymap.set('n', ']c', require('gitsigns').next_hunk, { buffer = bufnr })
        end,
      }
    end
  },

  --godot
  {"lommix/godot.nvim",
    config = function()
      local ok, godot = pcall(require, "~/Coding Projects/Godot/godot crash course/project.godot")
      if not ok then
        return
      end

      local config = {
        --bin = "godot",
        --gui = {
          --console_config = @config for vim.api.nvim_open_win
        --},
      }

      godot.setup(config)

      local function map(m, k, v)
        vim.keymap.set(m,k,v { silent = true})
      end

      map("n", "<leader>dr", godot.debugger.debug)
      map("n", "<leader>dd", godot.debugger.debug_at_cursor)
      map("n", "<leader>dq", godot.debugger.quit)
      map("n", "<leader>dc", godot.debugger.continue)
      map("n", "<leader>ds", godot.debugger.step)    
    end
  },
  {"habamax/vim-godot"},

})



--
--extra stuff
--  {"catppuccin/nvim", priority=1000,
--    config = function()
--      require("catppuccin").setup({
--        transparent_background = true,
--        term_colors = true,
--      })
--      vim.cmd([[colorscheme catppuccin "catppuccin-mocha"]])
--    end,
--  },

 -- {"tanvirtin/monokai.nvim", priority=1000,
 --   config = function()
 --     local monokai = require("monokai")
 --     local palette = monokai.classic
 --     monokai.setup({
 --       palette = {
 --       },
 --       custom_hlgroups = {},
 --     })
 --     vim.cmd([[hi NORMAL guibg=NONE]])
 --   end,
 -- },

  --{"daschw/leaf.nvim", priority=1000,
  --  config = function()
  --    require("leaf").setup({
  --      transparent = true,
  --      colors = {
  --       red0=     "#477a62",
  --       blue0=   "#0dcd0f",
  --       yellow0=  "#a9e884",
  --       teal0=    "#33ab64",
  --       aqua0=    "#2c8424",
  --       green0=    "#acc2de",
  --       red1=     "#538d72",
 --        blue1=   "#0fe612",
 --        yellow1=  "#b7eb98",
 --        teal1=    "#38bc6f",
 --        aqua1=    "#36a02c",
 --        green1=    "#c5d4e8",
 --       }
 --     })
 --     vim.cmd([[colorscheme leaf]])
 --     vim.cmd([[hi NORMAL guibg=NONE]])
 --   end,
 -- },
 --





















