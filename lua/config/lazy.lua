-- =====================================================================
-- 1. LAZY SETUP
-- =====================================================================

-- Define lazy installation path
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- How to clone
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

-- Add lazy.nvim to Neovim's runtime path
vim.opt.rtp:prepend(lazypath)


-- =====================================================================
-- 2. PLUGIN CONFIGS
-- =====================================================================

require("lazy").setup({
  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "lua",
        "vim",
        "vimdoc",
        "javascript",
        "python",
        "html",
        "css",
        "zig",
      },
      highlight = { enable = true },
      indent = { enable = true },
    },
  },

  -- Tinted theming support
  {
    "tinted-theming/tinted-vim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.tinted_background_transparent = 1
      vim.g.tinted_italic = 0
      vim.opt.termguicolors = true
      vim.cmd.colorscheme("base24-wez")
    end,
  },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    branch = "master",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Telescope",
  },

  -- Autopairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },

  -- Alpha for dashboard
  {
    "goolord/alpha-nvim",
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      dashboard.section.header.val = {
        "NEOVIM",
      }

      -- Alpha sections
      dashboard.section.buttons.val = {
        dashboard.button("e", "New", ":ene <BAR> startinsert <CR>"),
        dashboard.button("r", "Recent", ":Telescope oldfiles <CR>"),
        dashboard.button("f", "Find", ":Telescope find_files <CR>"),
        -- dashboard.button("n", "init.lua", ":e $MYVIMRC <CR>"),
        -- dashboard.button("l", "lazy.lua", ":e ~/.config/nvim/lua/config/lazy.lua <CR>"),
        dashboard.button("p", "Lazy", ":Lazy<CR>"),
        dashboard.button("m", "Mason", ":Mason<CR>"),
        dashboard.button("q", "Quit", ":qa<CR>"),
      }

      -- Send config to alpha
      alpha.setup(dashboard.opts)
    end,
  },

  -- Gitsigns
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      attach_to_untracked = true,
    },
  },

  -- Mason
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },

  -- Mason-LSPconfig
  {
    "williamboman/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
    opts = {
      -- List of language servers
      ensure_installed = {
        "lua_ls",
        "zls",
        "pyright",
        "ts_ls",
        "html",
        "cssls",
      },
      handlers = {
        -- Default setup for all language servers
        function(server_name)
          require("lspconfig")[server_name].setup({})
        end,
        -- Setup specifically for the Lua lsp
        ["lua_ls"] = function()
          require("lspconfig").lua_ls.setup({
            settings = {
              Lua = {
                -- Stop Lua from complaining about 'vim' being undefined
                diagnostics = { globals = { "vim" } },
                workspace = { checkThirdParty = false },
              },
            },
          })
        end,
      },
    },
  },

  -- Nvim-cmp for main autocomplete
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",

      -- LuaSnip for snippet engine
      {
        "L3MON4D3/LuaSnip",
        build = "make install_jsregexp",
      },
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      -- Load friendly-snippets
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        -- Tell cmp how to expand snippets
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },

        -- Keyboard shortcuts for the completion menu
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),

          -- Tab functionality
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),

          -- Shift+Tab
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),

        -- Where nvim-cmp should look for completion suggestions (in order)
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },
})