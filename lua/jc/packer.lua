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
  use { "catppuccin/nvim", as = "catppuccin" }

  --File navigation
  use "ThePrimeagen/harpoon"
  use "nvim-telescope/telescope.nvim"

  --SyntaxHightlighting
  use "nvim-treesitter/nvim-treesitter"
  use "nvim-treesitter/nvim-treesitter-context"

  use "neovim/nvim-lspconfig"
  use "williamboman/mason.nvim"
  use "williamboman/mason-lspconfig.nvim"
  use "folke/neodev.nvim"
  
	use "hrsh7th/nvim-cmp"
	use "hrsh7th/cmp-nvim-lsp"
  use "hrsh7th/cmp-buffer"
  use "hrsh7th/cmp-path"
  use "hrsh7th/cmp-cmdline"
  
  use "L3MON4D3/LuaSnip"
  use "saadparwaiz1/cmp_luasnip"
  
  use 'quangnguyen30192/cmp-nvim-ultisnips'

  use "m4xshen/autoclose.nvim"

  use "windwp/nvim-ts-autotag"

  --Git
  use "tpope/vim-fugitive"
  use "lewis6991/gitsigns.nvim"

  --silly stuff
  use "eandrju/cellular-automaton.nvim"


end)
