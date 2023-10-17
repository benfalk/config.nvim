return { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    requires = {
        -- Automatically install LSPs to stdpath for neovim
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',

        { -- Autocompletion
            'hrsh7th/nvim-cmp',
            requires = {
                'hrsh7th/cmp-nvim-lsp',
                'L3MON4D3/LuaSnip',
                'saadparwaiz1/cmp_luasnip'
            },
        },

        { -- Useful status updates for LSP
            'j-hui/fidget.nvim',
            tag = 'legacy',
        },
    },
    config = function()
        -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

        require('mason').setup()
        require('mason-lspconfig').setup()
        require('fidget').setup()
        -- see: :h mason-lspconfig.setup_handlers()
        require('mason-lspconfig').setup_handlers({
            function(server_name)
                require('lspconfig')[server_name].setup({
                    capabilities = capabilities,
                    on_attach = function(_, bufnr)
                        local nmap = function(keys, func, desc)
                            if desc then
                                desc = 'LSP' .. desc
                            end

                            vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
                        end

                        nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
                        nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
                        nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
                        nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
                    end
                })
            end
        })

        local luasnip = require('luasnip')
        local cmp = require('cmp')

        cmp.setup({
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<C-j>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    else
                        fallback()
                    end
                end, { 'i', 's' }),
                ['<C-k>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    else
                        fallback()
                    end
                end, { 'i', 's' }),
                ['<CR>'] = cmp.mapping.confirm {
                  behavior = cmp.ConfirmBehavior.Replace,
                  select = true,
                },
            }),
            sources = {
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
            },
        })
    end,
}
