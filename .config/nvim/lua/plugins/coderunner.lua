return {

  {
    "CRAG666/code_runner.nvim",
    lazy = false,
    config = function()
      require("code_runner").setup({
        mode = "term",
        focus = true,
        startinsert = true,
        filetype = {
          python = "python3 -u",
          cpp = "g++ -o $fileNameWithoutExt $fileName && ./$fileNameWithoutExt",
          c = "gcc -o $fileNameWithoutExt $fileName && ./$fileNameWithoutExt",
          java = "javac $fileName && java $fileNameWithoutExt",
          bash = "bash",
          javascript = "node",
          typescript = "ts-node",
        },
      })

      -- Autocommand to save before running code
      vim.cmd([[
        augroup CodeRunnerAutoSave
          autocmd!
          autocmd User RunCodePre :w
        augroup END
      ]])

      -- Keybinding to save and run
      vim.api.nvim_set_keymap("n", "<leader>b", ":w<CR>:RunCode<CR>", { noremap = true, silent = true })
    end,
  },
}
