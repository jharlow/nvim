return {
  -- mini.animate's resize animation fights rapid/held resize keys (e.g. the
  -- Windows hydra's HJKL), making windows "resize a little but never much".
  -- Disable resize animation; keep the rest.
  "nvim-mini/mini.animate",
  opts = {
    resize = { enable = false },
  },
}
