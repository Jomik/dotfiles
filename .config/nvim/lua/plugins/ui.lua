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
    "glepnir/dashboard-nvim",
    optional = true,
    opts = function(_, opts)
      local projects = {
        action = "Telescope projects",
        desc = " Projects",
        icon = " ",
        key = "p",
      }
      table.insert(opts.config.center, 3, projects)
    end,
  },
}
