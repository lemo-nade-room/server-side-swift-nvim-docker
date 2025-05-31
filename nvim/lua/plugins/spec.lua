return {
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeOpen", "NvimTreeClose" },
    config = function()
      require("nvim-tree").setup({
        view = { width = 30, side = "left" },
        filters = { dotfiles = false },
      })
      vim.keymap.set(
        "n",
        "<Leader>e",
        ":NvimTreeToggle<CR>:NvimTreeFocus<CR>",
        { noremap = true, silent = true }
      )
    end,
  },
  { 'arzg/vim-colors-xcode' },
}
