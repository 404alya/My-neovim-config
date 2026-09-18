-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
--
--
vim.keymap.set("n", "<leader>dg", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

local add_undo_point = {'-', '<CR>', ':', '<space>', ';', '[', ']', '{', '}', '=', '(', ')', '|', '~'}

for k, v in pairs(add_undo_point) do
  vim.keymap.set('i', v, v..'<c-g>u')
end










