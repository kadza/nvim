return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    -- import mason
    local mason = require("mason")

    local mason_tool_installer = require("mason-tool-installer")

    -- enable mason and configure icons
    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    mason_tool_installer.setup({
      ensure_installed = {
        "black", -- python formatter
        "eslint_d",
        "isort", -- python formatter
        "js-debug-adapter", -- javascript/typescript debugger
        "prettierd", -- prettier formatter
        "pylint",
        "stylelint",
        "rustfmt", -- Rust formatter
        "stylua", -- lua formatter
      },
    })
  end,
}
