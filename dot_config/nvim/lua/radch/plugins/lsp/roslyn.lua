return {
  "seblyng/roslyn.nvim",
  dependencies = {
    {
      -- By loading as a dependencies, we ensure that we are available to set
      -- the handlers for roslyn
      'tris203/rzls.nvim',
      config = function()
        ---@diagnostic disable-next-line: missing-fields
        require('rzls').setup({})
      end,
    },
  },
  ft = { "cs", "razor" },
  config = function()
    require("roslyn").setup({
      config = {
        handlers = require('rzls.roslyn_handlers'),
        cmd = {
          "dotnet",
          vim.fs.joinpath(vim.fn.stdpath('data'), 'mason', 'packages', 'roslyn', 'libexec',
            'Microsoft.CodeAnalysis.LanguageServer.dll'),
          "--razorSourceGenerator=" ..
          vim.fs.joinpath(vim.fn.stdpath('data'), 'mason', 'packages', 'roslyn', 'libexec',
            'Microsoft.CodeAnalysis.Razor.Compiler.dll'),
          "--razorDesignTimePath=" ..
          vim.fs.joinpath(vim.fn.stdpath('data'), 'mason', 'packages', 'rzls', 'libexec', 'Targets',
            'Microsoft.NET.Sdk.Razor.DesignTime.targets'),
          "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
          "--logLevel=Information",
          "--stdio",
        }
      },
    })
  end,
  init = function()
    -- we add the razor filetypes before the plugin loads
    vim.filetype.add {
      extension = {
        razor = 'razor',
        cshtml = 'razor',
      },
    }
  end,
}
