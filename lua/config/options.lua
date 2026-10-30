-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Open pickers/explorer/grep at the current working directory rather than
-- walking up to the git root. Falls back to git root, then cwd.
vim.g.root_spec = { "cwd", "lsp", { ".git", "lua" } }

-- LazyVim only supports vtsls/tsgo as built-in TypeScript presets.
-- Select the tsgo preset, then disable its server and use tsrs exclusively
-- in lua/plugins/typescript-lsp.lua (project-local binary or PATH required).
vim.g.lazyvim_ts_lsp = "tsgo"
