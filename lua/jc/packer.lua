-- use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- have packer use a popup window
packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}

--install plugins
return packer.startup(function(use)
  use "wbthomason/packer.nvim"

  --Utils
  use "nvim-lua/plenary.nvim"
  use({
      "folke/trouble.nvim",
      config = function()
          require("trouble").setup {
              -- your configuration comes here
              -- or leave it empty to use the default settings
              -- refer to the configuration section below
          }
      end
  })

  --color theme
  --use { "catppuccin/nvim", as = "catppuccin" }
  --use {"rebelot/kanagawa.nvim", as = "kanagawa"}
  use {"AlexvZyl/nordic.nvim", as = "nordic"}

  --File navigation
  use "ThePrimeagen/harpoon"
  use "nvim-telescope/telescope.nvim"

  --SyntaxHightlighting

	use "hrsh7th/cmp-nvim-lsp"
  use ("L3MON4D3/LuaSnip")
  use "saadparwaiz1/cmp_luasnip"
  
	use {"hrsh7th/nvim-cmp",
        dependencies = {
          "hrsh7th/cmp-nvim-lsp",
          "L3MON4D3/LuaSnip",
          "saadparwaiz1/cmp_luasnip"
        },
        
        config = function()
          local has_words_before = function()
            unpack = unpack or table.unpack
            local line, col = unpack(vim.api.nvim_win_get_cursor(0))
            return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
          end
          
          local cmp = require('cmp')
          local luasnip = require('luasnip')

          cmp.setup({
            snippet = {
              expand = function(args)
                luasnip.lsp_expand(args.body)
              end
            },
            completion = {
              autocomplete = false
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
              ["<c-e>"] = cmp.mapping.abort(),
              ["<CR>"] = cmp.mapping.confirm({select=true}),
            }),
            sources = {
              {name = "nvim_lsp"},
              {name = "luasnip"},
            }
          })
        end
      }
  use "hrsh7th/cmp-buffer"
  use "hrsh7th/cmp-path"
  use "hrsh7th/cmp-cmdline"

  use "williamboman/mason.nvim"
  use "williamboman/mason-lspconfig.nvim"

  use { "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim"
    },
    config = function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

      require('mason').setup()
      local mason_lspconfig = require('mason-lspconfig')
      mason_lspconfig.setup {
        ensure_installed = { 'pyright', 'clangd' }
      }
      require("lspconfig").pyright.setup {
        capabilities = capabilities,
      }
    end
  }
  

  use "nvim-treesitter/nvim-treesitter"
  use "nvim-treesitter/nvim-treesitter-context"

  use "folke/neodev.nvim"

  
  use 'quangnguyen30192/cmp-nvim-ultisnips'

  use "m4xshen/autoclose.nvim"

  use "windwp/nvim-ts-autotag"

  --Git
  use "tpope/vim-fugitive"
  use "lewis6991/gitsigns.nvim"

  --godot
  use "lommix/godot.nvim"
  use "habamax/vim-godot"

  --silly stuff
  use "eandrju/cellular-automaton.nvim"

end)

--require("luasnip.loaders.from_vscode").load({paths={"./snippets"}})
