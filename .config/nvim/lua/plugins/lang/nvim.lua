return {
  "nvim-neotest/neotest",
  optional = true,
  dependencies = {
    "nvim-neotest/neotest-plenary",
  },
  opts = function(_, opts)
    opts.adapters = vim.list_extend(opts.adapters or {}, {
      require("neotest-plenary"),
    })
  end,
}
