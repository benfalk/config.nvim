return {
    'RRethy/nvim-treesitter-endwise',
    after = { 'nvim-treesitter' },
    config = function()
        require('nvim-treesitter.configs').setup({
            endwise = {
                enable = true
            }
        })
    end,
}
