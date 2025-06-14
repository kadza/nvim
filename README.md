# TODO:

- harpoon
- check coc plugin
- https://blog.productsway.com/c-spell-setup-in-neovim-a-comprehensive-guide

# Plugins

- noice
  - search, cmdline in a popup in a middle instead of bottom
  - messages in nofications
- gitsigns
  - current line blame
- neotest
  - unit tests
- spellwarn
  - spell errors in diagnostics window
  * doesn't refresh after I added a word in dictionary
  * couldn't find a way to not display errors in lines

# References

- https://www.lazyvim.org/
- https://github.com/josean-dev/dev-environment-files/tree/main/.config/nvim
- https://github.com/ThePrimeagen/init.lua/tree/master
- spelling: https://johncodes.com/posts/2023/02-25-nvim-spell/
- option list: https://neovim.io/doc/user/quickref.html#option-list
- debugging infra: https://www.darricheng.com/posts/setting-up-nodejs-debugging-in-neovim/
- attach to process running inside of Docker container: https://medium.com/@ryan.matthews.professional/debug-a-node-js-project-running-in-docker-6a16b786821d

# Tips

https://www.youtube.com/watch?v=5BU2gBOe9RU

# Lsp debugging

Uncomment in init.lua vim.lsp.set_log_level("debug"). Logs are in .local/state/nvim/lsp.log
Run `:LspInfo`
