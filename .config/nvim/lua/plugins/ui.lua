return {
  { import = "lazyvim.plugins.extras.ui.mini-animate" },
  { import = "lazyvim.plugins.extras.ui.mini-starter" },
  { import = "lazyvim.plugins.extras.util.project" },
  {
    "rcarriga/nvim-notify",
    opts = {
      stages = "fade_in_slide_out",
      timeout = 3000,
      render = "compact",
    },
  },
  {
    "echasnovski/mini.starter",
    opts = function(_, opts)
      local items = {
        {
          name = "Projects",
          action = "Telescope projects",
          section = string.rep(" ", 22) .. "Telescope",
        },
      }
      vim.list_extend(opts.items, items)
    end,
  },
}
