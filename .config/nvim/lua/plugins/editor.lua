return {
  "gpanders/editorconfig.nvim",
  -- {
  --   "neovim/nvim-lspconfig",
  --   dependencies = {
  --     "Fildo7525/pretty_hover",
  --     event = "LspAttach",
  --     opts = {},
  --     init = function()
  --       local keys = require("lazyvim.plugins.lsp.keymaps").get()
  --       keys[#keys + 1] = {
  --         "K",
  --         function()
  --           require("pretty_hover").hover()
  --         end,
  --         desc = "Hover",
  --       }
  --     end,
  --   },
  -- },
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
  {
    "echasnovski/mini.map",
    event = "VeryLazy",
    keys = {
      { "<leader>mc", "<cmd>lua MiniMap.close()<CR>", desc = "Close" },
      { "<leader>mo", "<cmd>lua MiniMap.open()<CR>", desc = "Open" },
      { "<leader>mm", "<cmd>lua MiniMap.toggle()<CR>", desc = "Toggle" },
      { "<leader>mf", "<cmd>lua MiniMap.toggle_focus()<CR>", desc = "Focus" },
      { "<leader>mr", "<cmd>lua MiniMap.refresh()<CR>", desc = "Refresh" },
    },
    dependencies = {
      "folke/which-key.nvim",
      optional = true,
      opts = {
        spec = {
          { "<leader>m", group = "minimap" },
        },
      },
    },
    opts = function(_, _)
      local mini_map = require("mini.map")
      return {
        integrations = {
          mini_map.gen_integration.builtin_search(),
          mini_map.gen_integration.diff(),
          mini_map.gen_integration.diagnostic(),
        },
        symbols = {
          encode = mini_map.gen_encode_symbols.dot("4x2"),
        },
      }
    end,
    config = function(_, opts)
      local mini_map = require("mini.map")
      mini_map.setup(opts)
      mini_map.open()
    end,
  },
}
