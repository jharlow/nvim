return {
  "akinsho/bufferline.nvim",
  opts = {
    options = {
      -- Keep the bufferline visible even when only one buffer is open,
      -- so the current filename is always shown.
      always_show_bufferline = true,
    },
  },
  init = function()
    -- With always_show_bufferline on, bufferline reappears over the snacks
    -- dashboard. Hide the tabline whenever the dashboard is the active buffer.
    local function hide_if_dashboard()
      if vim.bo.filetype == "snacks_dashboard" then
        vim.o.showtabline = 0
      end
    end

    vim.api.nvim_create_autocmd("User", {
      pattern = "SnacksDashboardOpened",
      callback = hide_if_dashboard,
    })
    -- bufferline loads lazily *after* the dashboard is shown and re-enables the
    -- tabline; re-hide it the moment bufferline finishes loading.
    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyLoad",
      callback = function(ev)
        if ev.data == "bufferline.nvim" then
          hide_if_dashboard()
        end
      end,
    })
    vim.api.nvim_create_autocmd("User", {
      pattern = "SnacksDashboardClosed",
      callback = function()
        vim.o.showtabline = 2
      end,
    })
  end,
}
