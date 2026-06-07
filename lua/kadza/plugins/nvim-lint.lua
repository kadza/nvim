return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      javascript = { "eslint_d" },
      typescript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      typescriptreact = { "eslint_d" },
    }

    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

    local js_fts = { javascript = true, typescript = true, javascriptreact = true, typescriptreact = true }

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = function(ev)
        local ft = vim.bo[ev.buf].filetype
        local linters = vim.deepcopy(lint.linters_by_ft[ft] or {})

        if js_fts[ft] then
          local dir = vim.fn.expand("%:p:h")
          if vim.fn.findfile(".oxlintfmt.json", dir .. ";") ~= "" then
            table.insert(linters, "oxlint")
          end
        end

        lint.try_lint(linters)
      end,
    })

    vim.keymap.set("n", "<leader>l", function()
      lint.try_lint()
    end, { desc = "Trigger linting for current file" })
  end,
}
