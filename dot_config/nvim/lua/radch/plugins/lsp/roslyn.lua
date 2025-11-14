return {
  "seblyng/roslyn.nvim",
  dependencies = {
    "j-hui/fidget.nvim",
    {
      -- By loading as a dependencies, we ensure that we are available to set
      -- the handlers for roslyn
      "tris203/rzls.nvim",
      config = true,
    },
  },
  config = function()
    local mason_registry = require("mason-registry")
    local roslyn_package = mason_registry.get_package("roslyn")
    local cmd = {}
    if roslyn_package:is_installed() then
      vim.list_extend(cmd, {
        "roslyn",
        "--stdio",
        "--logLevel=Information",
        "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
      })

      local rzls_package = mason_registry.get_package("rzls")
      if rzls_package:is_installed() then
        local rzls_path = vim.fn.expand("$MASON/packages/rzls/libexec")
        table.insert(cmd,
          "--razorSourceGenerator=" .. vim.fs.joinpath(rzls_path, "Microsoft.CodeAnalysis.Razor.Compiler.dll"))
        table.insert(cmd,
          "--razorDesignTimePath=" .. vim.fs.joinpath(rzls_path, "Targets", "Microsoft.NET.Sdk.Razor.DesignTime.targets"))
        vim.list_extend(cmd, {
          "--extension",
          vim.fs.joinpath(rzls_path, "RazorExtension", "Microsoft.VisualStudioCode.RazorExtension.dll"),
        })
      end
    end

    require("roslyn").setup({
      ignore_target = function(target)
        return string.match(target, "$project$.sln") ~= nil
      end,
      lock_target = true,
    })
    vim.lsp.config("roslyn", {
      cmd = cmd,
      handlers = require("rzls.roslyn_handlers"),
      settings = {
        ["csharp|inlay_hints"] = {
          csharp_enable_inlay_hints_for_implicit_object_creation = true,
          csharp_enable_inlay_hints_for_implicit_variable_types = true,
          csharp_enable_inlay_hints_for_lambda_parameter_types = true,
          csharp_enable_inlay_hints_for_types = true,

          dotnet_enable_inlay_hints_for_indexer_parameters = true,
          dotnet_enable_inlay_hints_for_literal_parameters = true,
          dotnet_enable_inlay_hints_for_object_creation_parameters = true,
          dotnet_enable_inlay_hints_for_other_parameters = true,
          dotnet_enable_inlay_hints_for_parameters = true,
          dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
          dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
          dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
        },
        ["csharp|code_lens"] = {
          dotnet_enable_references_code_lens = true,
          dotnet_enable_tests_code_lens = true,
        },
        ["csharp|symbol_search"] = {
          dotnet_search_reference_assemblies = false,
        },
        ["csharp|background_analysis"] = {
          dotnet_analyzer_diagnostics_scope = "openFiles",
          dotnet_compiler_diagnostics_scope = "fullSolution",
        },
      },
    })
  end,
  init = function()
    local handles = {}

    vim.api.nvim_create_autocmd("User", {
      pattern = "RoslynRestoreProgress",
      callback = function(ev)
        local token = ev.data.params[1]
        local handle = handles[token]
        if handle then
          handle:report({
            title = ev.data.params[2].state,
            message = ev.data.params[2].message,
          })
        else
          handles[token] = require("fidget.progress").handle.create({
            title = ev.data.params[2].state,
            message = ev.data.params[2].message,
            lsp_client = {
              name = "roslyn",
            },
          })
        end
      end,
    })

    vim.api.nvim_create_autocmd("User", {
      pattern = "RoslynRestoreResult",
      callback = function(ev)
        local handle = handles[ev.data.token]
        handles[ev.data.token] = nil

        if handle then
          handle.message = ev.data.err and ev.data.err.message or "Restore completed"
          handle:finish()
        end
      end,
    })
    -- we add the razor filetypes before the plugin loads
    vim.filetype.add {
      extension = {
        razor = 'razor',
        cshtml = 'razor',
      },
    }
  end,
}
