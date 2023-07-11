return {
  { "folke/noice.nvim", cond = not (vim.g.neovide or false) },
  "gpanders/editorconfig.nvim",
  {
    "NMAC427/guess-indent.nvim",
    config = true,
  },
  {
    "telescope.nvim",
    ---@type LazySpec[]
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        config = function()
          require("telescope").load_extension("fzf")
        end,
      },
    },
    opts = {
      defaults = {
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 0,
      },
    },
  },
  {
    "debugloop/telescope-undo.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
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
  {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
    keys = {
      { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" },
    },
    config = true,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "Fildo7525/pretty_hover",
      event = "LspAttach",
      opts = {},
    },
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
