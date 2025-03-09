vim.filetype.add({
  extension = {
    ["http"] = "http",
  },
})
return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "http", "graphql" },
    },
  },
  {
    "abidibo/nvim-httpyac",
    ft = "http",
    keys = {
      { "<leader>R", "", desc = "+Rest", ft = "http" },
      { "<Leader>Rr", "<cmd>:NvimHttpYac --env local<CR>", desc = "Run request", ft = "http" },
      { "<Leader>Ra", "<cmd>:NvimHttpYacAll --env local<CR>", desc = "Run all requests", ft = "http" },
    },
    opts = {},
  },
}
