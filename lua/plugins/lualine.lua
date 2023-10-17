return { -- Fancier Statusline
    'nvim-lualine/lualine.nvim',
    config = function()
        require('lualine').setup({
            options = {
                icons_enabled = true,
                theme = 'nightfox',
                component_separators = '|',
                section_separators = '',
            },
        })
    end,
}
