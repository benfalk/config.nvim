return { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    run = function()
        pcall(require('nvim-treesitter.install').update({ with_sync = true }))
    end,
    config = function()
        require('nvim-treesitter.configs').setup({
            ensure_installed = {
                'c', 'cpp', 'go', 'lua', 'python', 'rust',
                'vim', 'ruby', 'markdown', 'json', 'elixir',
                'html'
            },
            highlight = { enable = true }
        })
    end,
}
