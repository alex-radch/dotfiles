return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local treesitter = require("nvim-treesitter")

    local parsers = {
      "c_sharp",
      "razor",
      "go",
      "json",
      "javascript",
      "typescript",
      "tsx",
      "yaml",
      "toml",
      "html",
      "css",
      "scss",
      "bash",
      "lua",
      "vim",
      "regex",
      "markdown",
      "markdown_inline",
      "dockerfile",
      "gitignore",
      "vimdoc",
      "php",
    }
    treesitter.install(parsers)

    local patterns = {}
    for _, parser in ipairs(parsers) do
      local parser_patterns = vim.treesitter.language.get_filetypes(parser)
      for _, pp in pairs(parser_patterns) do
        table.insert(patterns, pp)
      end
    end

    vim.api.nvim_create_autocmd("FileType", {
      pattern = patterns,
      callback = function(args)
        local max_filesize = 1 * 1024 * 1024 -- 1 MB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(args.buf))
        if ok and stats and stats.size > max_filesize then return true end

        -- syntax highlighting, provided by Neovim
        vim.treesitter.start()
        -- folds, provided by Neovim
        -- vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        -- vim.wo.foldmethod = "expr"
        -- indentation, provided by nvim-treesitter
        -- vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
