return {
  "mfussenegger/nvim-dap",
  {
    "williamboman/mason.nvim",
    dependencies = {
      "jay-babu/mason-nvim-dap.nvim",
    },
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = {
      ensure_installed = {
        "node2",
      },
      automatic_setup = true,
    },
    config = function(_, opts)
      require("mason-nvim-dap").setup(opts)
      require("mason-nvim-dap").setup_handlers()
    end,
  },
  {
    "telescope.nvim",
    dependencies = {
      "nvim-telescope/telescope-dap.nvim",
      config = function()
        require("telescope").load_extension("dap")
      end,
    },
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    config = true,
  },
}
