return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        cspell_ls = {
          -- Installed with npm install -g @vlabo/cspell-lsp.
          mason = false,
          filetypes = {
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
            "lua",
            "json",
            "markdown",
          },
        },
      },
    },
  },
}
