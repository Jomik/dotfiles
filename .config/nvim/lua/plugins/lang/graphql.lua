return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "graphql",
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.graphql = {}
      if vim.fn.filereadable(vim.fn.getcwd() .. "/node_modules/.bin/relay-compiler") == 1 then
        opts.servers.relay_lsp = {}
      end
    end,
  },
}
