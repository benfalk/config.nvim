-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local keymap = vim.keymap -- for conciseness

keymap.set("i", "jj", "<ESC>", { silent = true })
keymap.set("v", "<leader>y", '"+y', { silent = true })
keymap.set("n", "<leader>p", '"+p', { silent = true })
keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "[G]oto [D]efinition" })
keymap.set("n", "qq", "<cmd>q<enter>", { desc = "[Q]uit Buffer" })
keymap.set("n", "{", ":tabprevious<cr>", { silent = true })
keymap.set("n", "}", ":tabnext<cr>", { silent = true })
