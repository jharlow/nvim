local utils = require "astrocore"
local is_available = utils.is_available
local maps = utils.empty_map_table()

-- Smart Splits
if is_available "smart-splits.nvim" then
  maps.n["<C-h>"] = { function() require("smart-splits").move_cursor_left() end, desc = "Move to left split" }
  maps.n["<C-j>"] = { function() require("smart-splits").move_cursor_down() end, desc = "Move to below split" }
  maps.n["<C-k>"] = { function() require("smart-splits").move_cursor_up() end, desc = "Move to above split" }
  maps.n["<C-l>"] = { function() require("smart-splits").move_cursor_right() end, desc = "Move to right split" }
  maps.n["<M-k>"] = { function() require("smart-splits").resize_up() end, desc = "Resize split up" }
  maps.n["<M-j>"] = { function() require("smart-splits").resize_down() end, desc = "Resize split down" }
  maps.n["<M-h>"] = { function() require("smart-splits").resize_left() end, desc = "Resize split left" }
  maps.n["<M-l>"] = { function() require("smart-splits").resize_right() end, desc = "Resize split right" }
else
  maps.n["<C-h>"] = { "<C-w>h", desc = "Move to left split" }
  maps.n["<C-j>"] = { "<C-w>j", desc = "Move to below split" }
  maps.n["<C-k>"] = { "<C-w>k", desc = "Move to above split" }
  maps.n["<C-l>"] = { "<C-w>l", desc = "Move to right split" }
  maps.n["<M-k>"] = { "<cmd>resize -2<CR>", desc = "Resize split up" }
  maps.n["<M-j>"] = { "<cmd>resize +2<CR>", desc = "Resize split down" }
  maps.n["<M-h>"] = { "<cmd>vertical resize -2<CR>", desc = "Resize split left" }
  maps.n["<M-l>"] = { "<cmd>vertical resize +2<CR>", desc = "Resize split right" }
end

utils.set_mappings(utils.user_opts("mappings", maps))