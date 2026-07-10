return {
  -- blink.cmp v2 requires nvim 0.12+. We're on 0.11, so pin to the latest
  -- v1.x tag. LazyVim's blink extra uses `version = "*"`, which now resolves
  -- to a v2 tag and errors on InsertEnter.
  "saghen/blink.cmp",
  version = "1.*",
}
