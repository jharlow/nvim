return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          -- Include hidden (dotfiles) in live grep / grep word
          grep = { hidden = true },
          grep_word = { hidden = true },
          grep_buffers = { hidden = true },
        },
      },
    },
  },
}
