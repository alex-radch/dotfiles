return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local function set_encoding(name)
      local fe = ""
      local bomb = false

      if name == "utf-8" then
        fe = "utf-8"
        bomb = false
      elseif name == "utf-8-bom" then
        fe = "utf-8"
        bomb = true
      elseif name == "windows-1251" then
        fe = "cp1251"
        bomb = false
      else
        print("Unsupported encoding: " .. name)
        return
      end

      -- Set encoding and BOM flag
      vim.bo.fileencoding = fe
      vim.bo.bomb = bomb

      -- Write file using correct encoding
      vim.cmd("w ++enc=" .. fe)

      print("File saved with encoding: " .. name)
    end

    local function set_fileformat(line_endings)
      if line_endings == "LF" then
        vim.bo.fileformat = "unix"
      elseif line_endings == "CRLF" then
        vim.bo.fileformat = "dos"
      else
        print("Unsupported line ending format: " .. line_endings)
        return
      end

      -- Save the file with the correct line endings
      vim.cmd("w")

      print("File saved with line endings: " .. line_endings)
    end

    local function encoding_click()
      local encodings = { "utf-8", "utf-8-bom", "windows-1251" }
      vim.ui.select(encodings, { prompt = "Select encoding:" }, function(choice)
        if choice then
          set_encoding(choice)
        end
      end)
    end

    local function fileformat_click()
      local line_endings = { "LF", "CRLF" }
      vim.ui.select(line_endings, { prompt = "Select encoding:" }, function(choice)
        if choice then
          set_fileformat(choice)
        end
      end)
    end

    require("lualine").setup({
      options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '|', right = '|' },
        section_separators = { left = '', right = '' },
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diagnostics' },
        lualine_c = { { 'filename', path = 1 } }, -- 1: Relative path
        lualine_x = { { 'encoding', show_bomb = true, on_click = function() encoding_click() end }, { 'fileformat', on_click = function() fileformat_click() end }, 'filetype' },
        lualine_y = { 'lsp_status' },
        lualine_z = { 'location', 'searchcount' }
      },
    })
  end
}
