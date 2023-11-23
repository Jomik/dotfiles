local augroup = vim.api.nvim_create_augroup("user_cmds", { clear = true })

-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = augroup,
  pattern = { "structurizr" },
  callback = function()
    vim.opt_local.commentstring = "// %s"
  end,
})

-- Auto change ENV variables to enable bare git repository for dotfiles
local function update_git_env_for_dotfiles()
  -- Auto change ENV variables to enable
  -- bare git repository for dotfiles after
  -- loading saved session
  local home = vim.fn.expand("~")
  local git_dir = home .. "/.dotfiles"

  if vim.env.GIT_DIR ~= nil and vim.env.GIT_DIR ~= git_dir then
    return
  end

  -- check dotfiles dir exists on current machine
  if vim.fn.isdirectory(git_dir) ~= 1 then
    vim.env.GIT_DIR = nil
    vim.env.GIT_WORK_TREE = nil
    return
  end

  -- check if the current working directory should belong to dotfiles
  local cwd = vim.loop.cwd()
  if cwd ~= nil and (vim.startswith(cwd, home .. "/.config/") or cwd == home or cwd == home .. "/.local/bin") then
    if vim.env.GIT_DIR == nil then
      -- export git location into ENV
      vim.env.GIT_DIR = git_dir
      vim.env.GIT_WORK_TREE = home
    end
  else
    if vim.env.GIT_DIR == git_dir then
      -- unset variables
      vim.env.GIT_DIR = nil
      vim.env.GIT_WORK_TREE = nil
    end
  end
end

vim.api.nvim_create_autocmd("DirChanged", {
  pattern = { "*" },
  group = augroup,
  desc = "Update git env for dotfiles after changing directory",
  callback = function()
    update_git_env_for_dotfiles()
  end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = { "SessionLoadPost" },
  group = augroup,
  desc = "Update git env for dotfiles after loading session",
  callback = function()
    update_git_env_for_dotfiles()
  end,
})
