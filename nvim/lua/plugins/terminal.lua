return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        shell = "/bin/bash",
        -- ここでログインシェルとして立ち上げる
        shell_args = { "-l" },
        direction = "horizontal",
        size = 15,
        open_mapping = [[<Leader>tt]],
        -- close_on_exit = true,
      })
      vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n><C-w>p]], { noremap = true, silent = true })
    end,
  },
}
