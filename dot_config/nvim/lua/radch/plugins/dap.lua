return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "mason-org/mason.nvim",
  },
  config = function()
    local dap = require("dap")
    local widgets = require("dap.ui.widgets")

    -- Change breakpoint icons
    vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
    vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
    local break_icons = { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
    for type, icon in pairs(break_icons) do
      local tp = 'Dap' .. type
      local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
      vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
    end

    local keymap = vim.keymap
    keymap.set("n", "<leader>bs", dap.continue, { desc = "DAP continue" })
    keymap.set("n", "<leader>bj", dap.step_over, { desc = "DAP step over" })
    keymap.set("n", "<leader>bk", dap.step_into, { desc = "DAP step into" })
    keymap.set("n", "<leader>bl", dap.step_out, { desc = "DAP step out" })
    keymap.set("n", "<leader>bb", dap.toggle_breakpoint, { desc = "DAP toggle breakpoint" })
    keymap.set("n", "<leader>br", dap.repl.open, { desc = "DAP open REPL" })
    keymap.set({ "n", "v" }, "<leader>bh", widgets.hover, { desc = "DAP widgets hover" })
    keymap.set({ "n", "v" }, "<leader>bp", widgets.preview, { desc = "DAP widgets preview" })
    keymap.set("n", "<leader>bf", function() widgets.centered_float(widgets.frames) end,
      { desc = "DAP widgets centered frames float" })
    keymap.set("n", "<leader>ba", function() widgets.centered_float(widgets.scopes) end,
      { desc = "DAP widgets centered scopes float" })

    -- Languages configs
    local netcoredbg_path = vim.fn.expand("$MASON/packages/netcoredbg/netcoredbg")
    dap.adapters.coreclr = {
      type = "executable",
      command = netcoredbg_path,
      args = { "--interpreter=vscode" }
    }

    dap.configurations.cs = {
      {
        type = "coreclr",
        name = "Neovim .NET attach",
        request = "attach",
        processId = require("dap.utils").pick_process
      },
    }
  end
}
