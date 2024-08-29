
if vim.g.vscode then
  vim.cmd.colorscheme = ""
else
  vim.cmd.colorscheme("github_dark_high_contrast")
  vim.opt.termguicolors = true
  vim.api.nvim_set_hl(0, "Normal", { bg = "#000000" })
end

if vim.g.vscode then
  vim.keymap.set('n', 'u', "<Cmd>call VSCodeNotify('undo')<CR>")
end

vim.keymap.set('n', 'gj', 'g0', { noremap = true, silent = true })
vim.keymap.set('n', 'gk', 'g$', { noremap = true, silent = true })

vim.opt.mouse = ''
vim.opt.whichwrap:append("<,>,h,l,[,]")
vim.opt.ignorecase = true
vim.opt.smartcase = true

