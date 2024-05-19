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
map('i', '<c-space>', 'coc#refresh()', { expr = true })
map('i', '<CR>', 'coc#pum#visible() ? coc#pum#confirm() : "\\<CR>"', { expr = true })

--" Use `[c` and `]c` to navigate diagnostics
map('n', '[c', '<Plug>(coc-diagnostic-prev)')
map('n', ']c', '<Plug>(coc-diagnostic-next)')

map('n', 'gd', '<Plug>(coc-definition)')
map('n', 'gy', '<Plug>(coc-type-definition)')
map('n', 'gi', '<Plug>(coc-implementation)')
map('n', 'gr', '<Plug>(coc-references)')

map('n', '<leader>rn', '<Plug>(coc-rename)')

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
