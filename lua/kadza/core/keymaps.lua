vim.g.mapleader = " "
local keymap = vim.keymap

keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- move highlited text --
keymap.set("v", "J", ":m '>+1<CR>gv=gv")
keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- half page jumping with cursor in the middle --
keymap.set("n", "<C-d>", "<C-d>zz")
keymap.set("n", "<C-u>", "<C-u>zz")

-- search term cursor in the middle --
keymap.set("n", "n", "nzzzv")
keymap.set("n", "N", "Nzzzv")

-- keeps the pasted value in a buffer instead of replacing it
keymap.set("x", "<leader>p", [["_dP]])

-- copies to system clipboard
keymap.set({ "n", "v" }, "<leader>y", [["+y]])
keymap.set("n", "<leader>Y", [["+Y]])

-- This is going to get me cancelled
keymap.set("i", "<C-c>", "<Esc>")
keymap.set("i", "jk", "<Esc>")

keymap.set("n", "Q", "<nop>")
keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
keymap.set("n", "<leader>f", vim.lsp.buf.format)

-- replace work you're currently on
keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- it desn't work because it's overidden by lazy vim TBD
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })
