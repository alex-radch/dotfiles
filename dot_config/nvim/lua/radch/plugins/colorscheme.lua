return {
    "catppuccin/nvim",
    name = "cattpuccin",
    priority = 1000,
    config = function()
        vim.cmd("colorscheme catppuccin-mocha")
    end
}
