return {
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = [[
The things that make me different
are the things that make me]],
        },
      },
    },
    init = function()
      -- Gentle blue header instead of the default green.
      local function set_header_hl()
        vim.api.nvim_set_hl(0, "SnacksDashboardHeader", { fg = "#89b4fa" })
      end
      set_header_hl()
      vim.api.nvim_create_autocmd("ColorScheme", { callback = set_header_hl })
    end,
  },
}
