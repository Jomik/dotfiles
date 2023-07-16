return {
  {
    "neovim/nvim-lspconfig",
    servers = {
      opts = {
        clangd = {},
      },
    },
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      vim.list_extend(opts.sources, {
        nls.builtins.formatting.clang_format,
      })
    end,
    dependencies = {
      "mason.nvim",
      opts = function(_, opts)
        vim.list_extend(opts.ensure_installed, {
          "clang-format",
        })
      end,
    },
  },
}
