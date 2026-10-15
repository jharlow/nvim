-- Stop idle LSP clients (tsgo can hold 5-11 GB per instance in the Owner
-- monorepo) after nvim loses focus for a while; they restart on refocus.
return {
  "zeioth/garbage-day.nvim",
  dependencies = "neovim/nvim-lspconfig",
  event = "VeryLazy",
  opts = {
    -- Stop clients after 15 minutes without focus.
    grace_period = 60 * 15,
    -- Delay restart after refocus so quick window switches don't thrash.
    wakeup_delay = 1000,
    excluded_lsp_clients = {
      "null-ls",
      "jdtls",
      "marksman",
      "lua_ls",
      "copilot",
    },
    notifications = false,
  },
}
