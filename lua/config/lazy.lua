-- =====================================================================
-- 1. PLUGIN MANAGER SETUP (lazy.nvim)
-- =====================================================================

-- Define where lazy.nvim should be installed on your computer
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- If lazy.nvim isn't installed, download (clone) it from GitHub
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end

-- Add lazy.nvim to Neovim's runtime path so we can use it
vim.opt.rtp:prepend(lazypath)


-- =====================================================================
-- 2. PLUGIN CONFIGURATIONS
-- =====================================================================

require("lazy").setup({
  -- Treesitter: Provides advanced syntax highlighting and code parsing
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate", -- Automatically update parsers when treesitter updates
    opts = {
      ensure_installed = { "lua", "vim", "vimdoc", "javascript", "python", "html", "css", "zig" },
      highlight = { enable = true }, -- Turn on syntax highlighting
      indent = { enable = true },    -- Turn on smart indentation
    },
  },

  -- Telescope: Fuzzy finder for files, text, and more
  {
    "nvim-telescope/telescope.nvim",
    branch = "master",
    dependencies = { "nvim-lua/plenary.nvim" }, -- Required dependency for Telescope
  },

  -- Autopairs: Automatically closes brackets and quotes (e.g., '(' creates '()')
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter", -- Only load this plugin when you start typing
    opts = {},
  },

  -- Alpha: A start screen/dashboard for Neovim
  {
    "goolord/alpha-nvim",
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")


dashboard.section.header.val = {
        "Neovim"
        
      }

    -- Clean, reordered sections: Files/Settings first, Plugins at the bottom
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

  -- Mason: A package manager inside Neovim for installing LSPs, formatters, etc.
  { "williamboman/mason.nvim", opts = {} },

  -- Mason-LSPconfig: Bridges Mason with Neovim's built-in LSP client
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
    opts = {
      -- List of language servers you want Mason to automatically install
      ensure_installed = { "lua_ls", "zls", "pyright", "ts_ls", "html", "cssls" },
      handlers = {
        -- Default setup for all language servers
        function(server_name)
          require("lspconfig")[server_name].setup({})
        end,
        -- Custom setup specifically for the Lua language server
        ["lua_ls"] = function()
          require("lspconfig").lua_ls.setup({
            settings = {
              Lua = {
                -- Stop Lua from complaining about 'vim' being an undefined variable
                diagnostics = { globals = { "vim" } },
                workspace = { checkThirdParty = false },
              },
            },
          })
        end,
      },
    },
  },

  -- Nvim-cmp: The main autocompletion engine
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",       -- LSP completion source
      "hrsh7th/cmp-buffer",         -- Buffer text completion source
      "hrsh7th/cmp-path",           -- File path completion source
      
      -- LuaSnip: The snippet engine (FIXED: Now builds jsregexp for full functionality)
      {
        "L3MON4D3/LuaSnip",
        build = "make install_jsregexp",
      },
      "saadparwaiz1/cmp_luasnip",   -- Bridges LuaSnip with nvim-cmp
      "rafamadriz/friendly-snippets", -- A massive collection of pre-made snippets
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      
      -- Load the standard "friendly-snippets" collection
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
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),       -- Scroll docs up
          ["<C-f>"] = cmp.mapping.scroll_docs(4),        -- Scroll docs down
          ["<C-Space>"] = cmp.mapping.complete(),        -- Manually trigger completion
          ["<C-e>"] = cmp.mapping.abort(),               -- Close completion window
          ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Hit enter to confirm selection
          
          -- Tab functionality: move to next item or jump forward in a snippet
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          
          -- Shift+Tab functionality: move backward in the menu or snippet
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
        
        -- Where nvim-cmp should look for completion suggestions (order matters!)
        sources = cmp.config.sources({
          { name = "nvim_lsp" }, -- Suggestions from Language Servers (highest priority)
          { name = "luasnip" },  -- Suggestions from Snippets
          { name = "buffer" },   -- Suggestions from words in the current file
          { name = "path" },     -- Suggestions from your computer's file paths
        }),
      })
    end,
  },
})
