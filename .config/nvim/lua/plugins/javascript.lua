return {
  { import = "lazyvim.plugins.extras.lang.typescript" },
  { import = "lazyvim.plugins.extras.lang.json" },
  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      if type(opts.sources) == "table" then
        local nls = require("null-ls")
        vim.list_extend(opts.sources, {
          nls.builtins.formatting.prettierd,
          nls.builtins.diagnostics.eslint_d,
          nls.builtins.code_actions.eslint_d,
          nls.builtins.formatting.eslint_d,
        })
      end
    end,
  },
}
