return { -- Modal System for filtering collections such as files
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    requires = {
        'nvim-lua/plenary.nvim',
        {
            'nvim-telescope/telescope-fzf-native.nvim',
            run = 'make',
        }
    },
    config = function()
        require('telescope').setup({
            defaults = {
                mappings = {
                    i = {
                        ['<C-u>'] = false,
                        ['<C-d>'] = false,
                        ['<C-k>'] = "move_selection_previous",
                        ['<C-j>'] = "move_selection_next",
                    },
                },
            },
        })

        pcall(require('telescope').load_extension, 'fzf')

        local ts = require('telescope.builtin')

        vim.keymap.set('n', '<C-p>', ts.find_files, { desc = '[S]earch [F]iles' })
        vim.keymap.set('n', '<leader>sg', ts.live_grep, { desc = '[S]earch by [G]rep' })
        vim.keymap.set('n', '<leader>sb', ts.buffers, { desc = '[S]earch by [B]uffers' })
    end
}
