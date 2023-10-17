return { -- File Explore... because I'm a pleeb
    'nvim-tree/nvim-tree.lua',
    config = function()
        require("nvim-tree").setup()
        vim.keymap.set('n', '<C-n>', ':NvimTreeToggle<cr>', { silent = true })
    end
}
