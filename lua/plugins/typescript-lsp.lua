-- Always use tsrs for TypeScript, with no fallback to another server.
-- Requires `<root>/node_modules/.bin/tsrs` or `tsrs` on PATH.

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

local function start(argv, dispatchers, config, env)
  return vim.lsp.rpc.start(argv, dispatchers, {
    cwd = config.cmd_cwd,
    detached = config.detached,
    env = env,
  })
end

local function tsrs_cmd(dispatchers, config)
  local cmd = local_bin(config.root_dir, 'tsrs') or 'tsrs'
  return start({ cmd, '--lsp', '-stdio' }, dispatchers, config, config.cmd_env)
end

return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        tsgo = { enabled = false },
        vtsls = { enabled = false },
        ts_ls = { enabled = false },
        tsrs = {
          mason = false, -- not in mason; comes from the project's node_modules or PATH
          cmd = tsrs_cmd,
          filetypes = filetypes,
          root_dir = function(bufnr, on_dir)
            local root = project_root(bufnr)
            if root then
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
