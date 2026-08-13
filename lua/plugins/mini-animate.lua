return {
  {
    "folke/snacks.nvim",
    opts = {
      -- Smooth scrolling moves the real cursor through intermediate positions.
      scroll = { enabled = false },
    },
  },
  {
    "nvim-mini/mini.animate",
    opts = {
      -- These animations fight rapid/held resize and scroll commands.
      resize = { enable = false },
      scroll = { enable = false },
    },
  },
  {
    "sphamba/smear-cursor.nvim",
    optional = true,
    opts = {
      enabled = false,
    },
  },
}
