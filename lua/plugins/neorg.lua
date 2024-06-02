return {
  {
    "vhyrro/luarocks.nvim",
    priority = 1000,
    config = true,
    opts = {
      rocks = { "magick" },
    },
  },
  {
    "3rd/image.nvim",
    dependencies = { "luarocks.nvim" },
    opts = {
      backend = "ueberzug",
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto) can go here
        },
        neorg = {
          enabled = true,
          clear_in_insert_mode = true,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { "norg" },
        },
        html = {
          enabled = false,
        },
        css = {
          enabled = false,
        },
      },
      max_width = nil,
      max_height = nil,
      max_width_window_percentage = nil,
      max_height_window_percentage = 50,
      window_overlap_clear_enabled = false, -- toggles images when windows are overlapped
      window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
      editor_only_render_when_focused = false, -- auto show/hide images when the editor gains/looses focus
      tmux_show_only_in_active_window = false, -- auto show/hide images in the correct Tmux window (needs visual-activity off)
      hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp" },
    },
  },
  {
    "nvim-neorg/neorg",
    dependencies = { "luarocks.nvim" },
    lazy = false, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
    version = "8.6.0", -- Pin Neorg to the latest stable release
    config = true,
    opts = {
      load = {
        ["core.defaults"] = {}, -- Loads default behaviour
        ["core.concealer"] = {}, -- Adds pretty icons to your documents
        ["core.integrations.image"] = {},
        ["core.latex.renderer"] = {},
        ["core.dirman"] = { -- Manages Neorg workspaces
          config = {
            workspaces = {
              notes = "~/neorg",
            },
            default_workspace = "notes",
          },
        },
      },
      dependencies = {
        { "nvim-lua/plenary.nvim" },
        {
          -- YOU ALMOST CERTAINLY WANT A MORE ROBUST nvim-treesitter SETUP
          -- see https://github.com/nvim-treesitter/nvim-treesitter
          "nvim-treesitter/nvim-treesitter",
          opts = {
            auto_install = true,
            highlight = {
              enable = true,
              additional_vim_regex_highlighting = false,
            },
          },
          config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)
          end,
        },
        {
          "folke/tokyonight.nvim",
          config = function(_, _)
            vim.cmd.colorscheme("tokyonight-storm")
          end,
        },
      },
    },
  },
}
