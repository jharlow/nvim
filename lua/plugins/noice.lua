return {
  "folke/noice.nvim",
  opts = {
    lsp = {
      hover = {
        -- Don't notify "No information available" when a second LSP client
        -- (e.g. tailwindcss) returns nothing while another shows the hover.
        silent = true,
      },
    },
  },
}
