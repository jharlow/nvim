local function tsgo_cmd(dispatchers, config)
  local cmd = "tsgo"
  if config.root_dir then
    local local_cmd = vim.fs.joinpath(config.root_dir, "node_modules/.bin", cmd)
    if vim.fn.executable(local_cmd) == 1 then
      cmd = local_cmd
    end
  end

  local env = vim.fn.environ()
  env.GOMEMLIMIT = "14GiB"
  env.GOGC = "50"

  -- nvim-lspconfig's tsgo command is a function, so cmd_env is not forwarded
  -- automatically. Pass the limits directly to the RPC process instead.
  return vim.lsp.rpc.start({ cmd, "--lsp", "--stdio" }, dispatchers, {
    cwd = config.cmd_cwd,
    detached = config.detached,
    env = env,
  })
end

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tsgo = {
          cmd = tsgo_cmd,
          flags = {
            debounce_text_changes = 1000,
          },
        },
      },
    },
  },
}
