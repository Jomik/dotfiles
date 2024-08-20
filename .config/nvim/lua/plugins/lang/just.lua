return {
  "NoahTheDuke/vim-just",
  ft = { "just" },
  dependencies = {
    "nvim-treesitter",
    opts = {
      highlight = {
        disable = { "just" },
      },
    },
  },
}
