return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "Issafalcon/neotest-dotnet"
  },
  config = function()
    local neotest = require("neotest")
    neotest.setup({
      adapters = {
        require("neotest-dotnet")({
          dap = {
            args = { justMyCode = true },
            adapter_name = "coreclr"
          },
          discovery_root = "solution"
        })
      }
    })

    local keymap = vim.keymap

    keymap.set("n", "<leader>tts", function() neotest.summary.toggle() end, { desc = "Neotest toggle summary" })
    keymap.set("n", "<leader>ttr", function() neotest.run.run() end, { desc = "Neotest run nearest" })
    keymap.set("n", "<leader>ttd", function() neotest.run.run({ strategy = "dap" }) end,
      { desc = "Neotest debug nearest" })
    keymap.set("n", "<leader>ttf", function() neotest.run.run(vim.fn.expand("%")) end, { desc = "Neotest current file" })
    keymap.set("n", "<leader>tta", function() neotest.run.run(vim.fn.getcwd()) end, { desc = "Neotest run all" })
  end
}
