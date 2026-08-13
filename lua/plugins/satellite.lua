return {
  "lewis6991/satellite.nvim",
  event = "VeryLazy",
  opts = {
    current_only = true,
    handlers = {
      -- Avoid a full scrollbar redraw on every cursor movement.
      cursor = { enable = false },
    },
  },
}
