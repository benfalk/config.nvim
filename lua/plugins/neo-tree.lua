return {
  "nvim-neo-tree/neo-tree.nvim",
  keys = {
    {
      "<C-n>",
      function()
        require("neo-tree.command").execute({
          toggle = true,
          dir = LazyVim.root(),
        })
      end,
    },
  },
  opts = {
    window = {
      mappings = {
        ["o"] = "open",
      },
    },
  },
}
