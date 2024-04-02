-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--

vim.g.maplocalleader = " "

local opt = vim.opt

opt.wrap = true
opt.linebreak = true

if vim.g.neovide then
  opt.guifont = "VictorMono_Nerd_Font:h14"
  opt.shell = "/opt/homebrew/bin/fish"
  vim.g.neovide_cursor_vfx_mode = "railgun"
  vim.env.PATH = vim.env.XDG_DATA_HOME .. "/mise/shims:" .. vim.env.PATH
end
