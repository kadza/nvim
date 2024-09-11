return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-fzf-native.nvim",
  },
  config = function()
    local harpoon = require("harpoon")
    harpoon.setup({})

    -- basic telescope configuration
    local conf = require("telescope.config").values
    local function toggle_telescope(harpoon_files)
      local file_paths = {}
      for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
      end

      require("telescope.pickers")
        .new({}, {
          prompt_title = "Harpoon",
          finder = require("telescope.finders").new_table({
            results = file_paths,
          }),
          previewer = conf.file_previewer({}),
          sorter = conf.generic_sorter({}),
        })
        :find()
    end

    local keys = vim.keymap

    -- stylua: ignore start
    keys.set("n", "<leader>h", "", { desc = "+harpoon"})
    keys.set("n", "<leader>hh", function() harpoon:list():add() end, { desc = "Add to list" })
    keys.set("n", "<leader>hx", function() harpoon:list():remove() end, { desc = "Remove from list" })
    keys.set("n", "<leader>hl", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Open quick menu" })
    keys.set("n", "<leader>hk", function() toggle_telescope(harpoon:list()) end, { desc = "Open telescope" })
    keys.set("n", "<leader>ha", function() harpoon:list():select(1) end, { desc = "Select 1st" })
    keys.set("n", "<leader>hs", function() harpoon:list():select(2) end, { desc = "Select 2nd" })
    keys.set("n", "<leader>hd", function() harpoon:list():select(3) end, { desc = "Select 3rd" })
    keys.set("n", "<leader>hf", function() harpoon:list():select(4) end, { desc = "Select 4th" })
    keys.set("n", "<leader>hr", function() harpoon:list():prev() end, { desc = "Previous" })
    keys.set("n", "<leader>hc", function() harpoon:list():next() end, { desc = "Next" })
    -- stylua: ignore end
  end,
}
