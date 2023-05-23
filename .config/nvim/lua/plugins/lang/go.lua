return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "go",
        "gomod",
        "gowork",
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          settings = {
            gopls = {
              buildFlags = { "-tags=integration" },
              expandWorkspaceToModule = true,
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
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      vim.list_extend(opts.sources, {
        nls.builtins.formatting.gofumpt,
        nls.builtins.diagnostics.golangci_lint,
      })
    end,
  },
  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {
      {
        "mason.nvim",
        opts = {
          ensure_installed = { "delve" },
        },
      },
    },
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/neotest-go",
    },
    optional = true,
    opts = function(_, opts)
      opts.adapters = vim.list_extend(opts.adapters or {}, {
        require("neotest-go")({ args = { "-tags=integration" } }),
      })
    end,
  },
}
