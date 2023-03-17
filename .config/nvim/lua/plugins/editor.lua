return {
  "gpanders/editorconfig.nvim",
  {
    "NMAC427/guess-indent.nvim",
    config = true,
  },

  -- Add projects
  {
    "ahmedkhalf/project.nvim",
    name = "projects",
    config = function(_, opts)
      require("project_nvim").setup(opts)
      require("telescope").load_extension("projects")
    end,
  },
  {
    "telescope.nvim",
    dependencies = {
      {
        "debugloop/telescope-undo.nvim",
        config = function()
          require("telescope").load_extension("undo")
        end,

        keys = {
          {
            "<leader>U",
            function()
              return require("telescope").extensions.undo.undo()
            end,
            desc = "Undo History",
          },
        },
      },
    },
  },
}
