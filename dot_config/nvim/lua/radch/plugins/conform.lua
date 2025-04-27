return {
  "stevearc/conform.nvim",
  config = function()
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = {
        javascript = { "prettier" },
        typescript = { "prettier" },
        -- lua = { "stylua" },
        ["_"] = { "default_indent", lsp_format = "prefer" }
      },
      formatters = {
        -- Custom formatter to auto indent buffer.
        -- - Indents with neovim's builtin indentation `=`.
        -- - Saves and restores cursor position in ` mark.
        default_indent = {
          format = function(_, ctx, _, callback)
            -- no range, use whole buffer otherwise use selection
            local cmd = ctx.range == nil and 'gg=G' or '='
            vim.cmd.normal({ 'm`' .. cmd .. '``', bang = true })
            callback()
          end,
        },
      }
    })

    vim.keymap.set("n", "<leader>fd", function() require("conform").format({ async = true }) end,
      { desc = "Format document" })
  end
}
