-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.mouse = "a"
-- LazyVim turns clipboard sync off over SSH; keep it on and send yanks to the
-- local machine with OSC 52. OSC 52 paste would query the terminal and can hang,
-- so pasting returns the last yank instead.
vim.opt.clipboard = "unnamedplus"
if vim.env.SSH_CONNECTION then
  local osc52 = require("vim.ui.clipboard.osc52")
  local last = { {}, "v" }
  local function copy(reg)
    local send = osc52.copy(reg)
    return function(lines, regtype)
      last = { lines, regtype }
      send(lines)
    end
  end
  local function paste()
    return last
  end
  vim.g.clipboard = {
    name = "OSC 52",
    copy = { ["+"] = copy("+"), ["*"] = copy("*") },
    paste = { ["+"] = paste, ["*"] = paste },
  }
end
vim.g.mapleader = ","
vim.opt.termguicolors = true
vim.g.autoformat = false
vim.api.nvim_set_hl(0, "@lsp.type.comment", {})
vim.api.nvim_set_hl(0, "@lsp.type.comment.c", {})
vim.api.nvim_set_hl(0, "@lsp.type.comment.cpp", {})

vim.opt.listchars = {
  tab = "  ",
  nbsp = "␣",
  trail = "•",
  extends = "⟩",
  precedes = "⟨",
}

vim.api.nvim_create_autocmd("InsertLeave", {
  callback = function()
    local save = vim.fn.winsaveview()
    vim.opt.expandtab = true
    vim.cmd("retab")
    vim.cmd([[keeppatterns %s/\s\+$//e]])
    vim.fn.winrestview(save)
  end,
})

vim.api.nvim_create_user_command("TrimWhitespace", function()
  local save = vim.fn.winsaveview()
  vim.cmd([[keeppatterns %s/\s\+$//e]])
  vim.fn.winrestview(save)
end, {})

vim.api.nvim_create_user_command("TabsToSpaces", function()
  local save = vim.fn.winsaveview()
  vim.cmd([[keeppatterns %s/\t/\=repeat(' ', &tabstop)/ge]])
  vim.fn.winrestview(save)
end, {})
