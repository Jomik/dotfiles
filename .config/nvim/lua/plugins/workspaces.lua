return {
  {
    "natecraddock/workspaces.nvim",
    config = function(_, opts)
      require("workspaces").setup(opts)
      require("telescope").load_extension("workspaces")
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      { "<leader>sw", false },
      { "<leader>sW", "<cmd>Telescope workspaces<cr>", desc = "Browse Workspaces" },
    },
  },
}
