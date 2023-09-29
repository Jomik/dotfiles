-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--

vim.g.maplocalleader = " "

local opt = vim.opt

opt.wrap = true
opt.linebreak = true
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true
opt.foldcolumn = "0"

if vim.g.neovide then
  opt.guifont = "VictorMono Nerd Font Mono-SemiBold:h14"
  opt.shell = "/usr/local/bin/fish"
  vim.g.neovide_cursor_vfx_mode = "railgun"
end
