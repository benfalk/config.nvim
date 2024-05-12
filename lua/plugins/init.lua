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
    local load = function(plugin)
        use(require('plugins/'.. plugin))
    end

    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- Detect tabstop and shiftwidth automatically
    use 'tpope/vim-sleuth'

    -- Allows for moving better navigation between vim and tmux panes
    use 'christoomey/vim-tmux-navigator'

    -- Amazing vim icons
    use 'nvim-tree/nvim-web-devicons'

    -- Those who do not know history are doomed to repeat it
    use 'tpope/vim-fugitive'

    -- Better Inputs and Selects
    use 'stevearc/dressing.nvim'

    -- adds indent gutters to UI
    load('indent-blankline')

    -- arbitrary vim navigation
    load('hop')

    -- file tree explorer
    load('nvim-tree')

    -- prefered colorscheme
    load('nightfox')

    -- side bar git-status indicator
    load('gitsigns')

    -- window overlay finder
    load('telescope')

    -- code completion with LSP
    load('nvim-lspconfig')

    -- gui bar at the bottom of nvim
    load('lualine')

    -- greater language AST query functionality for code
    load('nvim-treesitter')

    -- auto-completes function ends for ruby, elixir, lua, etc
    load('nvim-treesitter-endwise')

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require('packer').sync()
    end
end)
