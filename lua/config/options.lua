-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Open pickers/explorer/grep at the current working directory rather than
-- walking up to the git root. Falls back to git root, then cwd.
vim.g.root_spec = { "cwd", "lsp", { ".git", "lua" } }

-- Use the native Go-based `tsgo` LSP server for TypeScript instead of vtsls.
-- Requires `tsgo` on PATH (npm i -g @typescript/native-preview) or in the
-- project's node_modules/.bin.
vim.g.lazyvim_ts_lsp = "tsgo"
