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
  --Trouble is for errors and other problems in code
  {"folke/trouble.nvim", config = function()
    require('trouble').setup()
    vim.keymap.set("n", "<leader>z", "<cmd>Trouble diagnostics toggle<cr>",{silent = true, noremap = true})
  end,
  },

  --Finding files quicklyyyyy
  {"nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      local ts = require('telescope.builtin')
      vim.keymap.set('n', '<leader>]', ts.find_files, {})
      vim.keymap.set('n', '<leader>[', ts.git_files, {})
      vim.keymap.set('n', '<leader>p', function()
        ts.grep_string({ search = vim.fn.input("Grep > ")})
      end)
    end,
  },
  {"theprimeagen/harpoon", config = function()
      local mark = require("harpoon.mark")
      local ui = require("harpoon.ui")

      vim.keymap.set("n", "<leader>a", mark.add_file)
      vim.keymap.set("n", "<leader>q", ui.toggle_quick_menu)

      vim.keymap.set("n", "<leader>d", function() ui.nav_file(1) end)
      vim.keymap.set("n", "<leader>f", function() ui.nav_file(2) end)
      vim.keymap.set("n", "<leader>j", function() ui.nav_file(3) end)
      vim.keymap.set("n", "<leader>k", function() ui.nav_file(4) end)
    end,
  },

  --Auto Pairs for {}()""''<>
  {"windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      disable_filetype = { "TelescopePrompt", "vim"},
      map_cr = true,
    },
  },
  {"windwp/nvim-ts-autotag"},

  --Color scheme :)
  {"folke/tokyonight.nvim",
    priority = 1000,
    config = function()
      --vim.cmd([[colorscheme tokyonight]])
    end,
  },
  {"rose-pine/neovim",
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme rose-pine-main]])
    end,
  },
  {"nvim-treesitter/nvim-treesitter",
    config = function()
      require("nvim-treesitter.configs").setup{
        ensure_installed = { "java", "c", "cpp", "lua", "rust", "go", "markdown" },
        highlight = {
          enable = true,
        },
        autotag = {
          enable = true,
        },
        additional_vim_regex_highlighting = false,
      }
      vim.cmd("TSUpdate")
    end,
  },

  --UndoTree
  {"mbbill/undotree", config = function()
      vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
    end,
  },

  --vim fugitive
  {"tpope/vim-fugitive", config = function()
      vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
    end,
  },

  {"nvim-tree/nvim-web-devicons"},

  {"MeanderingProgrammer/render-markdown.nvim"},

  {"mfussenegger/nvim-jdtls"},
  {
    "ray-x/lsp_signature.nvim",
    event = "VeryLazy",
  },
  {"mfussenegger/nvim-dap"},

  -- LSP
  {"neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
    },

    config = function()
        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities())

        require("fidget").setup({})
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
            },
            handlers = {
                function(server_name) -- default handler (optional)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities,
                        on_attach = function(client, bufnr)
                          local opts = { noremap=true, silent=true }
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
                        end,
                    }
                end,

                ["lua_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.lua_ls.setup {
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                runtime = { version = "Lua 5.1" },
                                diagnostics = {
                                    globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
                                }
                            }
                        }
                    }
                end,
            }
        })

        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' }, -- For luasnip users.
            }, {
                { name = 'buffer' },
            })
        })

        vim.diagnostic.config({
            -- update_in_insert = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })
    end,
  },

})

