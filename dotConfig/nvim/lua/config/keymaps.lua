-----------------------------------------------------------
-- Define keymaps
-----------------------------------------------------------

local map = require('config/utils').map
local tsBuiltin = require('telescope/builtin')

vim.g.mapleader = ','

-----------------------------------------------------------
-- COC (TODO: delete, moving away)
-----------------------------------------------------------

--" coc trigger refresh/autocompletion manually (insert mode)
--inoremap <silent><expr> <c-space> coc#refresh()
--inoremap <expr> <Enter> coc#pum#visible() ? coc#pum#confirm() : "\<Enter>"

--" Use `[c` and `]c` to navigate diagnostics
--nnoremap <silent> [c <Plug>(coc-diagnostic-prev)
--nnoremap <silent> ]c <Plug>(coc-diagnostic-next)

--nnoremap <silent> gd <Plug>(coc-definition)
--nnoremap <silent> gy <Plug>(coc-type-definition)
--nnoremap <silent> gi <Plug>(coc-implementation)
--nnoremap <silent> gr <Plug>(coc-references)

--nnoremap <leader>rn <Plug>(coc-rename)



-----------------------------------------------------------
-- Vanilla Neovim
-----------------------------------------------------------

map('v', '<leader>j', ':!python -m json.tool <enter>')
map('v', '<leader>jc', ':!python -m json.tool --compact<enter>')

-----------------------------------------------------------
-- Plugins
-----------------------------------------------------------

-- fuzzy search for filenames
map('n', '<c-p>', tsBuiltin.find_files)
-- file tree toggle
map('n', '<c-n>', ':NERDTreeToggle <enter>')
-- open curr file in tree
map('n', '<leader>n', ':NERDTreeFind <enter>')
map('n', '<leader>m', '<Plug>MarkdownPreview')
-- generate jsdoc on current
map('n', '<leader>j', '<Plug>(jsdoc)')
-- global text search
map('n', '<c-f>', ':Grepper<Enter>')
