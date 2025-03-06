return {
  {
    "rcarriga/nvim-notify",
    opts = {
      stages = "fade_in_slide_out",
      timeout = 3000,
      render = "compact",
    },
  },
  {
    "ahmedkhalf/project.nvim",
    optional = true,
    opts = {
      manual_mode = false,
    },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    optional = true,
    opts = {
      open_files_do_not_replace_types = { "edgy" },
    },
  },
}
