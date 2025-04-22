return {
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      -- Customize the keymap here
      opts.keymap = {
        preset = "super-tab", -- Choose your preferred preset: "default", "super-tab", "enter", "none"
        ["<Tab>"] = { "accept", "select_next", "show" }, -- Accept, select next, or show completions
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
