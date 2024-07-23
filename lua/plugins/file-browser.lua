return {
  "nvim-telescope/telescope-file-browser.nvim",
  keys = {
    {
      "<leader>fb",
      ":Telescope file_browser path=%:p:h<CR>",
      desc = "Browse Files",
    },
  },
  config = function()
    require("telescope").load_extension("file_browser")
  end,
}
