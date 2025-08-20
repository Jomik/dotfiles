-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set

if vim.fn.executable("lazyjj") == 1 then
  map("n", "<leader>jj", function()
    Snacks.terminal({ "lazyjj" })
  end, { desc = "Lazyjj" })
end
