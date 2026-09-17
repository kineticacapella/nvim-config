return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-file-browser.nvim",
  },
  cmd = { "Telescope" },
  keys = {
    { "<leader>f", function() require("telescope.builtin").find_files() end, desc = "Find files" },
    { "<leader>F", function() require("telescope.builtin").find_files({ cwd = vim.fn.getcwd() }) end, desc = "Find files (cwd)" },
    { "<leader>b", function() require("telescope.builtin").buffers() end, desc = "Buffers" },
    { "<leader>g", function() require("telescope.builtin").live_grep() end, desc = "Live grep" },
    { "<leader>h", function() require("telescope.builtin").help_tags() end, desc = "Help tags" },
    { "<leader>e", function()
        require("telescope").extensions.file_browser.file_browser({
          path = "%:p:h",
          select_buffer = true,
          hidden = true,
          grouped = true,
        })
      end, desc = "File browser" },
    { "<leader>E", function()
        require("telescope").extensions.file_browser.file_browser({
          path = "%:p:h",
          select_buffer = true,
          hidden = true,
          grouped = true,
        })
      end, desc = "File browser at current buffer's directory" },
  },
  config = function()
    local telescope = require("telescope")

    telescope.setup({
      defaults = {
        prompt_prefix = " ",
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
