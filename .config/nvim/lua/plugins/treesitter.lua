return {
  {
    "nvim-treesitter/nvim-treesitter-context",
    config = true,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-context",
    },
  },
}
