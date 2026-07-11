-- Neotest adapters for JavaScript / TypeScript.
--
-- Both neotest-vitest and neotest-jest claim any `*.test.*` / `*.spec.*` file by
-- filename alone, so registering both unconditionally makes neotest run every test
-- twice. Instead we detect the project's runner from its config files and register
-- only the matching adapter (detection runs once, when neotest is set up).

-- Walk up from the current working directory to a project root and figure out which
-- runner is in use. Returns "vitest", "jest", or nil.
local function detect_runner()
  local root = vim.fs.root(vim.uv.cwd() or ".", {
    "vitest.config.ts",
    "vitest.config.js",
    "vitest.config.mts",
    "vitest.workspace.ts",
    "vite.config.ts",
    "vite.config.js",
    "jest.config.ts",
    "jest.config.js",
    "jest.config.mjs",
    "jest.config.json",
    "package.json",
    ".git",
  }) or vim.uv.cwd()

  local function has(name)
    return vim.uv.fs_stat(root .. "/" .. name) ~= nil
  end

  if
    has("vitest.config.ts")
    or has("vitest.config.js")
    or has("vitest.config.mts")
    or has("vitest.workspace.ts")
    or has("vite.config.ts")
    or has("vite.config.js")
  then
    return "vitest"
  end

  if has("jest.config.ts") or has("jest.config.js") or has("jest.config.mjs") or has("jest.config.json") then
    return "jest"
  end

  -- Fall back to inspecting package.json for a `jest`/`vitest` key or dependency.
  local pkg = root .. "/package.json"
  if vim.uv.fs_stat(pkg) then
    local ok, data = pcall(function()
      return vim.json.decode(table.concat(vim.fn.readfile(pkg), "\n"))
    end)
    if ok and type(data) == "table" then
      local deps = vim.tbl_extend("keep", data.dependencies or {}, data.devDependencies or {})
      if deps.vitest or data.vitest then
        return "vitest"
      end
      if deps.jest or data.jest then
        return "jest"
      end
    end
  end

  return nil
end

return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "marilari88/neotest-vitest",
      "nvim-neotest/neotest-jest",
    },
    opts = function(_, opts)
      opts.adapters = opts.adapters or {}

      local runner = detect_runner()

      if runner == "jest" then
        table.insert(
          opts.adapters,
          require("neotest-jest")({
            -- run jest through the project's package manager so monorepo/workspace
            -- setups resolve the right binary; jest auto-discovers its own config
            jestCommand = "npm test --",
            env = { CI = true },
            cwd = function()
              return vim.fn.getcwd()
            end,
          })
        )
      else
        -- default to vitest (covers explicit vitest detection and the no-config case)
        table.insert(opts.adapters, require("neotest-vitest"))
      end
    end,
  },
}
