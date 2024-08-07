return {
  {
    "shortcuts/no-neck-pain.nvim",
    cmd = "NoNeckPain",
    keys = {
      { "<leader>nn", "<cmd>NoNeckPain<cr>", desc = "[N]o [N]eckpain" },
    },
    config = function()
      require("no-neck-pain").setup({
        width = 160,
      })
    end,
  },
}
