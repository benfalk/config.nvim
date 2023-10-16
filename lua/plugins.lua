-- Install Packer automatically if it's not installed(Bootstraping)
-- Hint: string concatenation is done by `..`
local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end
local packer_bootstrap = ensure_packer()


-- Reload configurations if we modify plugins.lua
-- Hint
--     <afile> - replaced with the filename of the buffer being manipulated
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Install plugins here - `use ...`
-- Packer.nvim hints
--     after = string or list,           -- Specifies plugins to load before this plugin. See "sequencing" below
--     config = string or function,      -- Specifies code to run after this plugin is loaded
--     requires = string or list,        -- Specifies plugin dependencies. See "dependencies". 
--     ft = string or list,              -- Specifies filetypes which load this plugin.
--     run = string, function, or table, -- Specify operations to be run after successful installs/updates of a plugin
require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use { -- Indentation line helper
        'lukas-reineke/indent-blankline.nvim',
        config = function()
            require('ibl').setup()
        end,
    }

    -- Detect tabstop and shiftwidth automatically
    use 'tpope/vim-sleuth'

    -- Allows for moving better navigation between vim and tmux panes
    use 'christoomey/vim-tmux-navigator'

    -- Amazing vim icons
    use 'nvim-tree/nvim-web-devicons'

    use { -- Those who do not know history are doomed to repeat it
        'tpope/vim-fugitive'
    }

    use { -- Hop around the buffer like a boss
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

    use { -- File Explore... because I'm a pleeb
        'nvim-tree/nvim-tree.lua',
        config = function()
            require("nvim-tree").setup()
            vim.keymap.set('n', '<C-n>', ':NvimTreeToggle<cr>', { silent = true })
        end
    }

    use { -- My prefered colorscheme
        'EdenEast/nightfox.nvim',
        config = function()
            vim.cmd [[colorscheme nightfox]]
        end,
    }

    use { -- Make Finding in Telescope BLAZINGLY FAST
        'nvim-telescope/telescope-fzf-native.nvim',
        run = 'make',
    }

    use { -- I saw the GitSign, and it opened up my eyes
        'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup({
                signs = {
                    add = { text = '+' },
                    change = { text = '~' },
                    delete = { text = '_' },
                    topdelete = { text = '‾' },
                    changedelete = { text = '~' },
                },
            })
        end
    }

    use { -- Modal System for filtering collections such as files
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        requires = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope-fzf-native.nvim'
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

    use { -- LSP Configuration & Plugins
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

    use { -- Fancier Statusline
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

    use { -- Highlight, edit, and navigate code
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

    use {
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

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require('packer').sync()
    end
end)
