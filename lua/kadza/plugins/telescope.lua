return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
    "folke/todo-comments.nvim",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local builtin = require("telescope.builtin")

    telescope.setup({
      defaults = {
        path_display = { "smart" },
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-h>"] = require("telescope.actions").cycle_history_prev,
          },
        },
      },
    })

    local function live_grep_min_length()
      local input = vim.fn.input("Grep: ")
      builtin.live_grep({
        default_text = input,
      })
    end

    local function git_files_with_input()
      local input = vim.fn.input("Git Files: ")
      builtin.git_files({
        default_text = input,
      })
    end

    telescope.load_extension("fzf")

    local keymap = vim.keymap

    keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
    keymap.set("n", "<leader><leader>", git_files_with_input, { desc = "Fuzzy find git files in cwd with input" })
    keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
    keymap.set(
      "n",
      "<leader>fs",
      live_grep_min_length,
      { noremap = true, silent = true, desc = "Fuzzy find string in files in cwd" }
    )
    keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
    keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })
    keymap.set("n", "<leader>fl", "<cmd>Telescope resume<cr>", { desc = "Resume last search" })
  end,
}
