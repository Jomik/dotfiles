return {
  { import = "lazyvim.plugins.extras.lang.markdown" },
  {
    "lukas-reineke/headlines.nvim",
    optional = true,
    opts = {
      markdown = {
        fat_headline_lower_string = "▔",
      },
    },
  },
}
