vim.g.mapleader = " "

local map = vim.keymap.set

-- File operations
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Telescope
map("n", "<leader>f", function() require("telescope.builtin").find_files() end, { desc = "Find files" })
map("n", "<leader>F", function() require("telescope.builtin").find_files({ cwd = vim.fn.getcwd() }) end, { desc = "Find files (cwd)" })
map("n", "<leader>e", function() require("telescope.builtin").find_files() end, { desc = "File explorer" })
map("n", "<leader>b", function() require("telescope.builtin").buffers() end, { desc = "Buffers" })
map("n", "<leader>g", function() require("telescope.builtin").live_grep() end, { desc = "Live grep" })
map("n", "<leader>h", function() require("telescope.builtin").help_tags() end, { desc = "Help tags" })