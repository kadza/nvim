vim.g.mapleader = " "
local keymap = vim.keymap

keymap.set("v", "<C-j>", ":m '>+1<CR>gv=gv", { desc = "Move highlited text down" })
keymap.set("v", "<C-k>", ":m '<-2<CR>gv=gv", { desc = "Move highlited text up" })
keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page jump down with cursor in the middle" })
keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page jump up with cursor in the middle" })
keymap.set("n", "n", "nzzzv", { desc = "Next search term with cursor in the middle" })
keymap.set("n", "N", "Nzzzv", { desc = "Previous search term with cursor in the middle" })
keymap.set("x", "<leader>p", [["_dP]], { desc = "keeps the pasted value in a buffer instead of replacing it" })
keymap.set("i", "jk", "<Esc>", { desc = "Esc" })
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window
keymap.set("n", "<leader>nc", ":nohl<CR>", { desc = "Clear search highlights" })
