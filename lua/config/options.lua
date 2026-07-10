-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Use the native Go-based `tsgo` LSP server for TypeScript instead of vtsls.
-- Requires `tsgo` on PATH (npm i -g @typescript/native-preview) or in the
-- project's node_modules/.bin.
vim.g.lazyvim_ts_lsp = "tsgo"
