return {
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      -- Customize the keymap here
      opts.keymap = {
        preset = "super-tab", -- Choose your preferred preset: "default", "super-tab", "enter", "none"
        -- ["<Tab>"] = { "accept", "select_next", "show" }, -- Accept, select next, or show completions
        -- Or define custom keymaps
        -- ["<C-space>"] = "open",
        -- ["<C-n>"] = "select_next",
        -- ["<C-p>"] = "select_prev",
        -- etc.
      }
      return opts
    end,
  },
}
--
-- return {
--   "saghen/blink.cmp",
--   dependencies = { "rafamadriz/friendly-snippets" },
--   version = "1.*",
--   opts = {
--     keymap = {
--       preset = "super-tab", -- Choose your preferred preset: "default", "super-tab", "enter", "none"
--       -- Use Tab to navigate to the next suggestion
--       ["<Tab>"] = { "select_next" },
--       -- Use Shift+Tab to navigate to the previous suggestion
--       ["<S-Tab>"] = { "select_prev" },
--       -- Use Enter to accept the selected completion
--       ["<CR>"] = { "accept" },
--     },
--     -- Optional: Additional settings for completion behavior
--     completion = {
--       menu = { auto_show = true },
--       documentation = { auto_show = true },
--       ghost_text = { enabled = true },
--     },
--     sources = {
--       default = { "lsp", "path", "snippets", "buffer" },
--     },
--   },
-- }
