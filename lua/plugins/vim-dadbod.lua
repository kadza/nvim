return {
  "tpope/vim-dadbod",
  "kristijanhusak/vim-dadbod-ui",
  "kristijanhusak/vim-dadbod-completion",
  config = function()
    -- Example configuration for vim-dadbod
    vim.g.db_ui_save_location = "~/.config/nvim/db_ui" -- Set the location to save queries and connections
    -- Example key mappings for vim-dadbod-ui
    vim.api.nvim_set_keymap("n", "<leader>du", ":DBUIToggle<CR>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("n", "<leader>df", ":DBUIFindBuffer<CR>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("n", "<leader>dr", ":DBUIRenameBuffer<CR>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("n", "<leader>dl", ":DBUILastQueryInfo<CR>", { noremap = true, silent = true })

    -- Setup vim-dadbod-completion
    vim.api.nvim_exec(
      [[
      augroup DadbodCompletion
        au!
        au FileType sql setlocal omnifunc=vim_dadbod_completion#omni
        au FileType mysql setlocal omnifunc=vim_dadbod_completion#omni
        au FileType plsql setlocal omnifunc=vim_dadbod_completion#omni
      augroup END
    ]],
      false
    )
  end,
}
