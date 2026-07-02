return {
  "rebelot/kanagawa.nvim",
  priority = 1000,
  config = function()
    require("kanagawa").setup({
      keywordStyle = { italic = false },
      commentStyle = { italic = false },
    })
    vim.cmd("colorscheme kanagawa")
  end,
}
