return {
  "sindrets/diffview.nvim",
  dependencies = {
    {
      "lewis6991/gitsigns.nvim",
      config = function()
        local gitsigns = require('gitsigns')
        gitsigns.setup()

        vim.keymap.set("n", "<leader>gp", gitsigns.preview_hunk_inline, { desc = "Git preview hunk inline" })
        vim.keymap.set("n", "<leader>gb", gitsigns.blame, { desc = "Git blame" })
      end,
    }
  },
  config = function()
    local diffview = require("diffview")
    local actions = require("diffview.actions")

    -- Add keymaps for DiffView file history
    vim.keymap.set("n", "<leader>gh", "<cmd>DiffviewFileHistory<cr>", { desc = "Git file history" })
    vim.keymap.set("n", "<leader>gH", "<cmd>DiffviewFileHistory %<cr>", { desc = "Git file history (current file)" })
    vim.keymap.set("n", "<leader>gB", function()
      vim.ui.select(
        vim.fn.systemlist("git branch --format='%(refname:short)'"),
        { prompt = "Select branch for history:" },
        function(branch)
          if branch then
            vim.cmd("DiffviewFileHistory --range=" .. branch)
          end
        end
      )
    end, { desc = "Git branch history" })
    vim.keymap.set("n", "<leader>gC", function()
      vim.ui.input({ prompt = "Commits range (e.g. HEAD~5..HEAD):" }, function(range)
        if range and range ~= "" then
          vim.cmd("DiffviewFileHistory " .. range)
        end
      end)
    end, { desc = "Git commits range history" })

    local function set_diff_highlights()
      local is_dark = vim.o.background == 'dark'

      if is_dark then
        vim.api.nvim_set_hl(0, 'DiffAdd', { fg = 'none', bg = '#2e4b2e', bold = true })
        vim.api.nvim_set_hl(0, 'DiffDelete', { fg = 'none', bg = '#4c1e15', bold = true })
        vim.api.nvim_set_hl(0, 'DiffChange', { fg = 'none', bg = '#45565c', bold = true })
        vim.api.nvim_set_hl(0, 'DiffText', { fg = 'none', bg = '#996d74', bold = true })
      else
        vim.api.nvim_set_hl(0, 'DiffAdd', { fg = 'none', bg = 'palegreen', bold = true })
        vim.api.nvim_set_hl(0, 'DiffDelete', { fg = 'none', bg = 'tomato', bold = true })
        vim.api.nvim_set_hl(0, 'DiffChange', { fg = 'none', bg = 'lightblue', bold = true })
        vim.api.nvim_set_hl(0, 'DiffText', { fg = 'none', bg = 'lightpink', bold = true })
      end
    end

    set_diff_highlights()

    vim.api.nvim_create_autocmd('ColorScheme', {
      group = vim.api.nvim_create_augroup('DiffColors', { clear = true }),
      callback = set_diff_highlights
    })

    diffview.setup({
      enhanced_diff_hl = true,
      view = {
        default = {
          layout = "diff2_horizontal",
        },
        merge_tool = {
          -- Config for conflicted files in diff views during a merge or rebase.
          layout = "diff4_mixed",
        },
        file_history = {
          layout = "diff2_vertical",
        },
      },
      file_panel = {
        listing_style = "list",            -- One of 'list' or 'tree'
        tree_options = {                   -- Only applies when listing_style is 'tree'
          flatten_dirs = true,             -- Flatten dirs that only contain one single dir
          folder_statuses = "only_folded", -- One of 'never', 'only_folded' or 'always'.
        },
        win_config = {                     -- See |diffview-config-win_config|
          type = "split",
          position = "right",
          width = 40,
          win_opts = {},
        },
      },
      keymaps = {
        diff4 = {
          { { "n", "x" }, "<leader>J", actions.diffget("ours"),   { desc = "Obtain the diff hunk from the OURS version of the file" } },
          { { "n", "x" }, "<leader>K", actions.diffget("base"),   { desc = "Obtain the diff hunk from the BASE version of the file" } },
          { { "n", "x" }, "<leader>L", actions.diffget("theirs"), { desc = "Obtain the diff hunk from the THEIRS version of the file" } },
        },
      },
    })
  end,
}
