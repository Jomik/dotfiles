return {
  { import = "lazyvim.plugins.extras.lang.go" },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          settings = {
            gopls = {
              buildFlags = { "-tags=integration,unittest" },
              semanticTokens = true,
              analyses = {
                nilness = true,
                unusedparams = true,
                unusedwrite = true,
                unusedvariable = true,
              },
            },
          },
        },
      },
    },
  },

  {
    "mfussenegger/nvim-lint",
    dependencies = {
      "williamboman/mason.nvim",
      opts = function(_, opts)
        table.insert(opts.ensure_installed, "golangci-lint")
      end,
    },
    opts = {
      linters_by_ft = {
        go = { "golangcilint" },
        gomod = { "golangcilint" },
        gowork = { "golangcilint" },
      },
    },
  },
}
