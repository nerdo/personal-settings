-- setup packer + plugins
local install_path = vim.fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"

-- swiped from nvchad, to auto clone and install Packer on first startup
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#1e222a" })
  print "Cloning Packer..."
  vim.fn.system { "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path }
end

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Declare the rest of the plugins
  require "nerdo.plugins"
end)
