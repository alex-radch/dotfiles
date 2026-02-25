return {
  "seblyng/roslyn.nvim",
  dependencies = {
    "j-hui/fidget.nvim",
  },
  config = function()
    require("roslyn").setup({
      ignore_target = function(target) return string.match(target, "$project$.sln") ~= nil end,
      lock_target = true,
    })
    vim.lsp.config("roslyn", {
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
        ["csharp|formatting"] = {
          dotnet_organize_imports_on_format = true,
        },
      },
    })
  end,
  init = function()
    -- Custom progress tracking for Roslyn solution loading
    local loading_handles = {}
    local initialized_clients = {} -- Track clients that have finished initializing

    -- Start progress when Roslyn attaches (before initialization completes)
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and (client.name == "roslyn" or client.name == "roslyn_ls") then
          -- Only show progress if this client hasn't initialized yet
          if not initialized_clients[args.data.client_id] and not loading_handles[args.data.client_id] then
            local ok, fidget = pcall(require, "fidget.progress")
            if ok then
              loading_handles[args.data.client_id] = fidget.handle.create({
                title = "Initializing",
                message = "Loading solution...",
                lsp_client = { name = "roslyn" },
                percentage = 0,
              })
            end
          end
        end
      end,
    })

    -- Finish progress when Roslyn initialization completes
    vim.api.nvim_create_autocmd("User", {
      pattern = "RoslynInitialized",
      callback = function(ev)
        local client_id = ev.data and ev.data.client_id
        if client_id then
          -- Mark this client as initialized
          initialized_clients[client_id] = true
          if loading_handles[client_id] then
            loading_handles[client_id].message = "Ready"
            loading_handles[client_id]:finish()
            loading_handles[client_id] = nil
          end
        else
          -- If we don't have a specific client_id, finish all handles
          for cid, handle in pairs(loading_handles) do
            initialized_clients[cid] = true
            handle.message = "Ready"
            handle:finish()
            loading_handles[cid] = nil
          end
        end
      end,
    })

    -- Clean up when client detaches
    vim.api.nvim_create_autocmd("LspDetach", {
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and (client.name == "roslyn" or client.name == "roslyn_ls") then
          initialized_clients[args.data.client_id] = nil
          if loading_handles[args.data.client_id] then
            loading_handles[args.data.client_id]:finish()
            loading_handles[args.data.client_id] = nil
          end
        end
      end,
    })

    -- Auto-insert XML doc comments on '/'
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        local bufnr = args.buf

        if client and (client.name == "roslyn" or client.name == "roslyn_ls") then
          vim.api.nvim_create_autocmd("InsertCharPre", {
            desc = "Roslyn: Trigger an auto insert on '/'.",
            buffer = bufnr,
            callback = function()
              local char = vim.v.char

              if char ~= "/" then return end

              local eol_map = { unix = "\n", dos = "\r\n", mac = "\r" }
              local eol = eol_map[vim.bo.fileformat] or "\n"

              local row, col = unpack(vim.api.nvim_win_get_cursor(0))
              row, col = row - 1, col + 1
              local uri = vim.uri_from_bufnr(bufnr)

              local params = {
                _vs_textDocument = { uri = uri },
                _vs_position = { line = row, character = col },
                _vs_ch = char,
                _vs_options = {
                  tabSize = vim.bo[bufnr].tabstop,
                  insertSpaces = vim.bo[bufnr].expandtab,
                  eol = eol,
                },
              }

              vim.defer_fn(function()
                client:request(
                  ---@diagnostic disable-next-line: param-type-mismatch
                  "textDocument/_vs_onAutoInsert",
                  params,
                  function(err, result, _)
                    if err or not result then return end

                    local textEdit = result._vs_textEdit
                    local range = textEdit.range

                    local lines = vim.split(textEdit.newText:gsub("\r", ""), "\n", { plain = true })
                    for i = 2, #lines do
                      lines[i] = lines[i]:gsub("^[\t ]+", "")
                    end

                    if result._vs_textEditFormat == 2 then
                      vim.api.nvim_win_set_cursor(0, { range.start.line + 1, range.start.character })
                      if range.start.line ~= range["end"].line or range.start.character ~= range["end"].character then
                        vim.api.nvim_buf_set_text(bufnr, range.start.line, range.start.character, range["end"].line, range["end"].character, {})
                      end
                      vim.snippet.expand(table.concat(lines, "\n"))
                    else
                      vim.api.nvim_buf_set_text(bufnr, range.start.line, range.start.character, range["end"].line, range["end"].character, lines)
                    end
                  end,
                  bufnr
                )
              end, 1)
            end,
          })
        end
      end,
    })

    -- Register razor filetypes before the plugin loads
    vim.filetype.add({
      extension = {
        razor = "razor",
        cshtml = "razor",
      },
    })
  end,
}
