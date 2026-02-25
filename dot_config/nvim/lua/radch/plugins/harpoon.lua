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

    -- =====================================================
    -- Harpoon Tabline - auto-switch between harpoon and native tabs
    -- Shows harpoon when 1 tab, native tabs when >1 tabs
    -- =====================================================

    local function get_harpoon_files()
      local list = harpoon:list()
      local items = list.items or {}
      local files = {}
      for i, item in ipairs(items) do
        if item and item.value then
          files[i] = item.value
        end
      end
      return files, #items
    end

    local function get_current_file()
      local bufname = vim.api.nvim_buf_get_name(0)
      if bufname == "" then
        return nil
      end
      return vim.fn.fnamemodify(bufname, ":.")
    end

    local function find_current_in_harpoon(files, current)
      if not current then return nil end
      for i, file in pairs(files) do
        if file == current then return i end
      end
      return nil
    end

    local function update_showtabline()
      local _, harpoon_count = get_harpoon_files()
      local tab_count = vim.fn.tabpagenr("$")
      vim.o.showtabline = (harpoon_count > 0 or tab_count > 1) and 2 or 0
    end

    -- VimScript function for harpoon click handling
    vim.cmd([[
      function! HarpoonTablineClick(idx, clicks, button, mods)
        call v:lua.HarpoonTablineClickHandler(a:idx)
      endfunction
    ]])

    _G.HarpoonTablineClickHandler = function(idx)
      harpoon:list():select(idx)
    end

    local function harpoon_tabline()
      local files, harpoon_count = get_harpoon_files()
      local current_file = get_current_file()
      local current_idx = find_current_in_harpoon(files, current_file)
      local tab_count = vim.fn.tabpagenr("$")

      local tabline = ""

      -- Native tabs when >1 tab exists
      if tab_count > 1 then
        local current_tab = vim.fn.tabpagenr()
        for t = 1, tab_count do
          tabline = tabline .. "%" .. t .. "T"
          tabline = tabline .. (t == current_tab and "%#TabLineSel#" or "%#TabLine#")

          local buflist = vim.fn.tabpagebuflist(t)
          local bufnr = buflist[vim.fn.tabpagewinnr(t)]
          local bufname = vim.fn.bufname(bufnr)
          local label = bufname ~= "" and vim.fn.fnamemodify(bufname, ":t") or "[No Name]"

          tabline = tabline .. " " .. t .. ":" .. label .. " "
        end
        tabline = tabline .. "%T%#TabLineFill#"
        return tabline
      end

      -- Harpoon marks when only 1 tab
      if harpoon_count == 0 then return "" end

      for i = 1, harpoon_count do
        local file = files[i]
        if file then
          local filename = vim.fn.fnamemodify(file, ":t")
          local is_current = (i == current_idx)

          tabline = tabline .. "%" .. i .. "@HarpoonTablineClick@"
          tabline = tabline .. (is_current and "%#TabLineSel#" or "%#TabLine#")
          tabline = tabline .. " " .. i .. ":" .. filename .. " "
          tabline = tabline .. "%X"
        end
      end

      tabline = tabline .. "%#TabLineFill#"
      return tabline
    end

    -- Set the tabline
    vim.o.tabline = "%!v:lua.HarpoonTabline()"

    -- Global function that Neovim calls to render tabline
    _G.HarpoonTabline = harpoon_tabline

    -- Refresh tabline
    local function refresh_tabline()
      update_showtabline()
      vim.cmd("redrawtabline")
    end

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "TabEnter", "TabClosed" }, {
      callback = refresh_tabline,
    })

    -- Hook into harpoon events to refresh tabline
    harpoon:extend({
      ADD = function()
        refresh_tabline()
      end,
      REMOVE = function()
        refresh_tabline()
      end,
      REORDER = function()
        refresh_tabline()
      end,
      LIST_CHANGE = function()
        refresh_tabline()
      end,
    })

    -- Initial update
    update_showtabline()
  end,
}
