return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        cucumber_language_server = {
          handlers = {
            ["textDocument/publishDiagnostics"] = function() end,
          },
        },
      },
    },
  },
}
