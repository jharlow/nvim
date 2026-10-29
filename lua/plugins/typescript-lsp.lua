-- TypeScript language servers: tsrs (Rust port of tsgo) where available,
-- otherwise tsgo.
--
-- For each project root (nearest lockfile, else .git, else cwd) exactly one
-- of the two attaches:
--   * tsrs  if `<root>/node_modules/.bin/tsrs` or `tsrs` on PATH exists
--   * tsgo  otherwise
--
-- Set `vim.g.ts_use_tsrs = false` (options.lua) to always use tsgo.
-- `:TsrsToggle` flips it at runtime and restarts the TypeScript clients.

local filetypes = {
  'javascript',
  'javascriptreact',
  'javascript.jsx',
  'typescript',
  'typescriptreact',
  'typescript.tsx',
}

-- Same inlay hint settings LazyVim's tsgo extra uses.
local settings = {
  typescript = {
    inlayHints = {
      enumMemberValues = { enabled = true },
      functionLikeReturnTypes = { enabled = false },
      parameterNames = {
        enabled = 'literals',
        suppressWhenArgumentMatchesName = true,
      },
      parameterTypes = { enabled = true },
      propertyDeclarationTypes = { enabled = true },
      variableTypes = { enabled = false },
    },
  },
}

-- nvim-lspconfig's tsgo root logic: nearest lockfile, else .git; skip Deno
-- files (returns nil).
local function project_root(bufnr)
  local lockfiles = { 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock' }
  local deno_root = vim.fs.root(bufnr, { 'deno.json', 'deno.jsonc' })
  local deno_lock_root = vim.fs.root(bufnr, { 'deno.lock' })
  local root = vim.fs.root(bufnr, { lockfiles, { '.git' } })
  if deno_lock_root and (not root or #deno_lock_root > #root) then
    return nil
  end
  if deno_root and (not root or #deno_root >= #root) then
    return nil
  end
  return root or vim.fn.getcwd()
end

local function local_bin(root, name)
  if root then
    local cmd = vim.fs.joinpath(root, 'node_modules/.bin', name)
    if vim.fn.executable(cmd) == 1 then
      return cmd
    end
  end
  if vim.fn.executable(name) == 1 then
    return name
  end
end

---@return string? tsrs executable for this root, nil if tsrs should not be used
local function tsrs_bin(root)
  if vim.g.ts_use_tsrs == false then
    return nil
  end
  return local_bin(root, 'tsrs')
end

local function start(argv, dispatchers, config, env)
  return vim.lsp.rpc.start(argv, dispatchers, {
    cwd = config.cmd_cwd,
    detached = config.detached,
    env = env,
  })
end

local function tsgo_cmd(dispatchers, config)
  local env = vim.fn.environ()
  env.GOMEMLIMIT = '14GiB'
  env.GOGC = '50'
  -- The command is a function, so cmd_env is not forwarded automatically.
  local cmd = local_bin(config.root_dir, 'tsgo') or 'tsgo'
  return start({ cmd, '--lsp', '--stdio' }, dispatchers, config, env)
end

local function tsrs_cmd(dispatchers, config)
  local cmd = tsrs_bin(config.root_dir) or 'tsrs'
  return start({ cmd, '--lsp', '-stdio' }, dispatchers, config, config.cmd_env)
end

vim.api.nvim_create_user_command('TsrsToggle', function()
  vim.g.ts_use_tsrs = vim.g.ts_use_tsrs == false
  for _, client in ipairs(vim.lsp.get_clients({ name = 'tsrs' })) do
    client:stop()
  end
  for _, client in ipairs(vim.lsp.get_clients({ name = 'tsgo' })) do
    client:stop()
  end
  -- Re-run root detection for open TS buffers so the other server attaches.
  vim.defer_fn(function()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(buf) and vim.tbl_contains(filetypes, vim.bo[buf].filetype) then
        vim.api.nvim_exec_autocmds('FileType', { buffer = buf })
      end
    end
  end, 500)
  vim.notify('TypeScript LSP: ' .. (vim.g.ts_use_tsrs == false and 'tsgo' or 'tsrs (when available)'))
end, { desc = 'Toggle between tsrs and tsgo' })

return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        tsgo = {
          cmd = tsgo_cmd,
          root_dir = function(bufnr, on_dir)
            local root = project_root(bufnr)
            if root and not tsrs_bin(root) then
              on_dir(root)
            end
          end,
          flags = {
            debounce_text_changes = 1000,
          },
        },
        tsrs = {
          mason = false, -- not in mason; comes from the project's node_modules or PATH
          cmd = tsrs_cmd,
          filetypes = filetypes,
          root_dir = function(bufnr, on_dir)
            local root = project_root(bufnr)
            if root and tsrs_bin(root) then
              on_dir(root)
            end
          end,
          settings = settings,
          flags = {
            debounce_text_changes = 1000,
          },
        },
      },
    },
  },
}
