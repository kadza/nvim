return {
  "tpope/vim-dadbod",
  cmd = "DB",
  init = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "dbout" },
      callback = function()
        vim.opt.foldenable = false
      end,
    })
  end,
}
