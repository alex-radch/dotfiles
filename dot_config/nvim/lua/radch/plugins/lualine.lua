return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("lualine").setup {
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
        lualine_x = { 'encoding', 'fileformat', { 'filetype', icon_only = true } },
        lualine_y = { 'lsp_status' },
        lualine_z = { 'location', 'searchcount' }
      },
    }
  end
}
