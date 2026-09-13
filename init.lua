require("config.options")
require("config.keymaps")

-- StatusLine colors (Dynamic Modes + Transparent BG)
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    -- Base transparent statuslines
    vim.api.nvim_set_hl(0, "StatusLine",   { bg = "NONE" })
    vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE", fg = "#555555" })

    -- Dynamic Mode Highlights
    vim.api.nvim_set_hl(0, "StatusLineNormal", { bg = "NONE", fg = "#52ad70", bold = true })
    vim.api.nvim_set_hl(0, "StatusLineInsert", { bg = "NONE", fg = "#5555ff", bold = true })
    vim.api.nvim_set_hl(0, "StatusLineVisual", { bg = "NONE", fg = "#cc55cc", bold = true })
    vim.api.nvim_set_hl(0, "StatusLineCmd", { bg = "NONE", fg = "#cdcd55", bold = true })

    -- Text elements
    vim.api.nvim_set_hl(0, "StatusLineInfo", { bg = "NONE", fg = "#52ad70" })
    vim.api.nvim_set_hl(0, "StatusLinePath", { bg = "NONE", fg = "#cdd6f4" })
  end,
})

-- Now load lazy
require("config.lazy")

-- fixing warnings
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- Map modes to labels and corresponding highlight groups
local modes = {
  ["n"]   = { label = "NORMAL",  hl = "%#StatusLineNormal#" },
  ["i"]   = { label = "INSERT",  hl = "%#StatusLineInsert#" },
  ["ic"]  = { label = "INSERT",  hl = "%#StatusLineInsert#" },
  ["v"]   = { label = "VISUAL",  hl = "%#StatusLineVisual#" },
  ["V"]   = { label = "V-LINE",  hl = "%#StatusLineVisual#" },
  ["\22"] = { label = "V-BLOCK", hl = "%#StatusLineVisual#" },
  ["c"]   = { label = "COMMAND", hl = "%#StatusLineCmd#" },
  ["R"]   = { label = "REPLACE", hl = "%#StatusLineInsert#" },
  ["t"]   = { label = "TERMINAL",hl = "%#StatusLineInsert#" },
}

local function get_mode_info()
  local current_mode = vim.api.nvim_get_mode().mode
  return modes[current_mode] or { label = "NORMAL", hl = "%#StatusLineNormal#" }
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
  local mode = get_mode_info()

  return table.concat({
    mode.hl, " ", mode.label, " ",               -- Dynamic Colored Mode
    "%#StatusLineInfo#", get_git_branch(), " ", -- Git Branch
    "%#StatusLinePath#%f %m",                   -- File Path & Modified flag
    "%=",                                       -- Right-align separator
    "%#StatusLineInfo#", get_diagnostics(), " ",-- LSP Errors
    "%#StatusLinePath#%Y ",                     -- Filetype
    mode.hl, "%l:%c %p%% ",                     -- Line:Col & Percentage matching Mode Color
  })
end

-- Set the statusline to call our Lua function
vim.opt.statusline = "%!v:lua.statusline_content()"
