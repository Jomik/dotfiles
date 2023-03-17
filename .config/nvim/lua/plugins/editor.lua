return {
  {
    "gpanders/editorconfig.nvim",
  },
  {
    "NMAC427/guess-indent.nvim",
    config = true,
  },
  -- Add projects
  {
    "ahmedkhalf/project.nvim",
    config = function(_, opts)
      require("project_nvim").setup(opts)
      require("telescope").load_extension("projects")
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      { "<leader>sP", "<cmd>Telescope projects<cr>", desc = "Browse Projects" },
    },
  },
}
