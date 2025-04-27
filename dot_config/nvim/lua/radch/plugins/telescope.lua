return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.8",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
    "folke/todo-comments.nvim",
  },
  config = function()
    local telescope = require("telescope")
    local builtin = require("telescope.builtin")

    telescope.setup {
      defaults = {
        file_ignore_patterns = { '%__virtual.cs$' },
        sorting_strategy = "ascending",
        layout_strategy = "vertical",
        layout_config = {
          vertical = {
            prompt_position = "top",
            mirror = true
          }
        }
      },
      pickers = {
        buffers = {
          theme = "ivy"
        },
        help_tags = {
          theme = "ivy"
        },
      },
      extensions = {
        fzf = {}
      }
    }
    telescope.load_extension("fzf")

    local keymap = vim.keymap

    keymap.set("n", "<leader>fc", function()
      builtin.find_files {
        cwd = vim.fn.stdpath("config")
      }
    end, { desc = "Telescope Neovim config" })

    keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
    keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
    keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
    keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "Telescope find word" })
    keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "Telescope keymaps" })
    keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
    keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Telescope TODOs" })
  end
}
