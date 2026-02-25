return {
  "NeogitOrg/neogit",
  lazy = true,
  dependencies = {
    "nvim-lua/plenary.nvim",         -- required

    -- Only one of these is needed.
    "sindrets/diffview.nvim",        -- optional
    -- "esmuellert/codediff.nvim",      -- optional

    "nvim-telescope/telescope.nvim", -- optional
  },
  cmd = "Neogit",
  keys = {
    { "<leader>gg", "<cmd>Neogit<cr>", desc = "Show Neogit UI" }
  }
}
