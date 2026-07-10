return {
  {
    "nvimtools/hydra.nvim",
    event = "VeryLazy",
    config = function()
      local Hydra = require("hydra")

      Hydra({
        name = "Windows",
        hint = [[
 _h_ _j_ _k_ _l_: move   _v_: vsplit   _s_: split
 _H_ _J_ _K_ _L_: resize   _=_: equalize
 _c_: close   _o_: only   _<Enter>_: pick
 _q_ / _<Esc>_: exit
]],
        config = {
          invoke_on_body = true,
          hint = { type = "window", position = "bottom" },
        },
        mode = "n",
        body = "<C-w>",
        heads = {
          -- move focus
          { "h", "<C-w>h" },
          { "j", "<C-w>j" },
          { "k", "<C-w>k" },
          { "l", "<C-w>l" },
          -- resize
          { "H", "<C-w>3<" },
          { "J", "<C-w>3-" },
          { "K", "<C-w>3+" },
          { "L", "<C-w>3>" },
          { "=", "<C-w>=", { desc = "equalize" } },
          -- split
          { "v", "<C-w>v", { desc = "vsplit" } },
          { "s", "<C-w>s", { desc = "split" } },
          -- manage
          { "c", "<C-w>c", { desc = "close" } },
          { "o", "<C-w>o", { desc = "only", exit = true } },
          { "<Enter>", "<Cmd>lua Snacks.picker.buffers()<CR>", { exit = true, desc = "pick" } },
          { "q", nil, { exit = true, nowait = true } },
          { "<Esc>", nil, { exit = true, nowait = true } },
        },
      })
    end,
  },
}
