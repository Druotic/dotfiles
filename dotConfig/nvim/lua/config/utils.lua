local Utils = {}

Utils.map = function(mode, lhs, rhs, opts)
  local options = { noremap=true, silent=true } -- FYI! This almost always is the right default
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

return Utils
