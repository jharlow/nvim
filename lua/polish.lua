-- This will run last in the setup process and is a good place to configure
-- things like custom filetypes. This just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

-- load snippets paths
require("luasnip.loaders.from_vscode").lazy_load {
  paths = { vim.fn.stdpath "config" .. "/snippets" },
}
