vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.keymap.set('i', 'jj', "<ESC>", { silent = true })
vim.keymap.set('n', 'qq', ":q<cr>", { silent = true })

vim.keymap.set('v', '<leader>y', '"+y', { silent = true })
vim.keymap.set('n', '<leader>p', '"+p', { silent = true })

vim.keymap.set('n', '{', ':tabprevious<cr>', { silent = true })
vim.keymap.set('n', '}', ':tabnext<cr>', { silent = true })
