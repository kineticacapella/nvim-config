return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-file-browser.nvim",
  },
  config = function()
    local telescope = require("telescope")

    telescope.setup({
      defaults = {
        prompt_prefix = " ", -- No prompt prefix
        sorting_strategy = "ascending",
        layout_strategy = "horizontal",
        layout_config = {
          prompt_position = "top",
          horizontal = {
            width = 0.85,
            height = 0.80,
            preview_width = 0.55,
          },
        },
        path_display = { "smart" },
        border = true,
        borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
      },
    })

    -- Disable highlighting on selected items
    vim.api.nvim_set_hl(0, "TelescopeSelection", { bg = "NONE", bold = true })

    telescope.load_extension("file_browser")
  end,
}
