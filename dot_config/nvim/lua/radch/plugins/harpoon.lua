return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")
    harpoon.setup()

    local keymap = vim.keymap
    keymap.set("n", "<leader>a", function() harpoon:list():add() end, { desc = "Add buffer to harpoon" })
    keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Toggle harpoon menu" })

    keymap.set("n", "<C-j>", function() harpoon:list():select(1) end, { desc = "Harpoon 1" })
    keymap.set("n", "<C-k>", function() harpoon:list():select(2) end, { desc = "Harpoon 2" })
    keymap.set("n", "<C-l>", function() harpoon:list():select(3) end, { desc = "Harpoon 3" })
    keymap.set("n", "<C-;>", function() harpoon:list():select(4) end, { desc = "Harpoon 4" })

    -- Toggle previous & next buffers stored within Harpoon list
    keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end, { desc = "Previos harpoon buffer" })
    keymap.set("n", "<C-S-N>", function() harpoon:list():next() end, { desc = "Next harpoon buffer" })
  end
}
