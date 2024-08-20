return {
  "gpanders/editorconfig.nvim",
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "Fildo7525/pretty_hover",
      event = "LspAttach",
      opts = {},
      init = function()
        local keys = require("lazyvim.plugins.lsp.keymaps").get()
        keys[#keys + 1] = {
          "K",
          function()
            require("pretty_hover").hover()
          end,
          desc = "Hover",
        }
      end,
    },
  },
  {
    "rgroli/other.nvim",
    main = "other-nvim",
    keys = {
      { "<leader>tf", "<cmd>Other test<cr>", desc = "Open test" },
      { "<leader>ti", "<cmd>Other implementation<cr>", desc = "Open implementation" },
    },
    opts = {
      mappings = { "golang" },
    },
  },
}
