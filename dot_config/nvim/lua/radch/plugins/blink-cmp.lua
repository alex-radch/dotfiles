return {
  'saghen/blink.cmp',
  dependencies = { 'rafamadriz/friendly-snippets' },
  -- use a release tag to download pre-built binaries
  version = '1.*',

  opts = {
    keymap = { preset = 'default' },
    appearance = {
      nerd_font_variant = 'mono'
    },

    -- (Default) Only show the documentation popup when manually triggered
    completion = { documentation = { auto_show = false } },

    sources = {
      default = { 'snippets', 'lsp', 'path' },
    },

    -- turn off ghost autocompletion in cmdline
    cmdline = { completion = { ghost_text = { enabled = false } } },

    -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
    fuzzy = { implementation = "prefer_rust_with_warning" },

    -- Automatically triggered when typing trigger characters, defined by the LSP, such as `(` for `lua`. The menu will be updated when pressing a retrigger character, such as `,`
    signature = {
      enabled = true,
      window = { show_documentation = false }
    }
  },
}
