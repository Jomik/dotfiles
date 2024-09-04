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
}
