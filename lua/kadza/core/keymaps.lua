vim.g.mapleader = " "
local keymap = vim.keymap

keymap.set("v", "<C-j>", ":m '>+1<CR>gv=gv", { desc = "Move highlited text down" })
keymap.set("v", "<C-k>", ":m '<-2<CR>gv=gv", { desc = "Move highlited text up" })
keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page jump down with cursor in the middle" })
keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page jump up with cursor in the middle" })
keymap.set("n", "n", "nzzzv", { desc = "Next search term with cursor in the middle" })
keymap.set("n", "N", "Nzzzv", { desc = "Previous search term with cursor in the middle" })
keymap.set("x", "<leader>p", [["_dP]], { desc = "keeps the pasted value in a buffer instead of replacing it" })
keymap.set("i", "<C-c>", "<Esc>", { desc = "Esc" })
keymap.set("v", "<C-c>", "<Esc>", { desc = "Esc" })
keymap.set("i", "jk", "<Esc>", { desc = "Esc" })
keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Rename under cursor" })
keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })
