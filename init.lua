require("config.options")
require("config.keymaps")

-- StatusLine colours
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    -- Set transparent background and custom text foreground color
    vim.api.nvim_set_hl(0, "StatusLine", { bg = "#000000", fg = "#52ad70", bold = true })   -- Active statusline text
    vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "#000000", fg = "#555555" }) -- Inactive statusline text
  end,
})

-- Now load lazy
require("config.lazy")

-- fixing warnings
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- Helper function to fetch current Vim mode in uppercase
local function get_mode()
  local modes = {
    n = "NORMAL", i = "INSERT", v = "VISUAL", V = "V-LINE",
    ["\22"] = "V-BLOCK", c = "COMMAND", R = "REPLACE", t = "TERMINAL",
  }
  return modes[vim.api.nvim_get_mode().mode] or "NORMAL"
end

-- Helper function to fetch Git branch
local function get_git_branch()
  local branch = vim.b.gitsigns_head or vim.b.git_branch or ""
  return branch ~= "" and ("  " .. branch) or ""
end

-- Helper function to fetch active LSP diagnostics count
local function get_diagnostics()
  if #vim.lsp.get_clients({ bufnr = 0 }) == 0 then return "" end
  local count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
  return count > 0 and ("  " .. count) or ""
end

-- Build the statusline dynamically
function _G.statusline_content()
  return table.concat({
    "%#StatusLineAccent# ", get_mode(), " ",    -- Mode (Lualine section A)
    "%#StatusLineInfo#", get_git_branch(), " ", -- Git Branch (Lualine section B)
    "%#StatusLinePath# %f %m",                  -- File Path & Modified flag (Lualine section C)
    "%=",                                       -- Right-align separator
    "%#StatusLineInfo#", get_diagnostics(), " ",-- LSP Errors (Lualine section X)
    "%#StatusLinePath# %Y ",                    -- Filetype (Lualine section Y)
    "%#StatusLineAccent# %l:%c %p%% ",          -- Line:Col & Percentage (Lualine section Z)
  })
end

-- Set the statusline to call our Lua function
vim.opt.statusline = "%!v:lua.statusline_content()"
