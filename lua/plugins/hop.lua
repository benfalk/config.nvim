return { -- Hop around the buffer like a boss
    'smoka7/hop.nvim',
    config = function()
        local hop = require('hop')
        local dir = require('hop.hint').HintDirection

        hop.setup({
            keys = 'etovxqpdygfblzhckisuran'
        })

        vim.keymap.set('n', '<leader><leader>w', ':HopWordAC<cr>', { silent = true })
        vim.keymap.set('n', '<leader><leader>b', ':HopWordBC<cr>', { silent = true })
        vim.keymap.set('n', '<leader><leader>a', ':HopWord<cr>', { silent = true })
    end
}
