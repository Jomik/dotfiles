return {
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    opts = {
      ensure_installed = {
        "node2",
      },
    },
    {
      "nvim-telescope/telescope-dap.nvim",
      dependencies = {
        "telescope.nvim",
      },
      config = function()
        require("telescope").load_extension("dap")
      end,
    },
    {
      "theHamsta/nvim-dap-virtual-text",
      dependencies = {
        "mfussenegger/nvim-dap",
      },
      opts = {},
    },
  },
}
