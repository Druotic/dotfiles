
-- Fix files with prettier, and then ESLint.
vim.g.ale_fixers = { 'prettier', 'eslint' }
-- Equivalent to the above.
--let b:ale_fixers = {'javascript': ['prettier', 'eslint']}
vim.g.ale_fix_on_save = true

--vim.g.coc_disable_startup_warning = true

-- Use silver searcher with ack/fzf
vim.g.grepper = { tools = { 'rg' } }
vim.fn.setenv('FZF_DEFAULT_COMMAND', 'rg --files')

-- vim-move ctrl+j, ctrl+k to move line
vim.g.move_key_modifier = 'c'

vim.g.NERDTreeRespectWildIgnore = true
vim.g.NERDTreeShowHidden = true

-- open markdown preview in chrome
vim.g.mkdp_path_to_chrome = 'open -a Google\\ Chrome'

-- working dir = nearest dir w/ .git
vim.g.ctrlp_working_path_mode = 'r'

-- vim-jsdoc
vim.g.jsdoc_allow_input_prompt = true
vim.g.jsdoc_input_description = true

-- https://github.com/vim-airline/vim-airline/blob/master/doc/airline.txt#L392
-- Show parent of parent directory name up to 20 chars. E.g. 'lifeomic',
-- 'lifeomic-clone', etc to make working with multiple copies of the same project
-- in parallel easier.
--vim.g.airline_section_b = '%-0.20{fnamemodify(getcwd(), ":h:t")}'
--vim.g.airline_section_b = '%-0.30{fnamemodify(getcwd(), ":hk")}'
-- update: relative to root - e.g. /Users/druotic/repos/work/lifeomic/...
-- TODO: re-enable
--vim.g.airline_section_b = '%-0.20{split(getcwd(), "/")[4]}'
--vim.g.airline_section_b = '%-'
--vim.g.airline_section_b = '%-0.20{getcwd()}'
vim.g.airline_section_b = '%{fnamemodify(expand("%:p:h"), ":t")}/'
--vim.g.airline_section_c = ''
--
--vim.g.airline_section_a       (mode, crypt, paste, spell, iminsert)
--vim.g.airline_section_b       (hunks, branch)[*]
--vim.g.airline_section_c = '%{fnamemodify(expand("%:p:h"), ":t")}/%t'
vim.g.airline_section_c = '%t'
--vim.g.airline_section_c       (bufferline or filename, readonly)
--vim.g.airline_section_gutter  (csv)
vim.g.airline_section_x = ''
--vim.g.airline_section_x       (tagbar, filetype, virtualenv)
vim.g.airline_section_y = ''
--vim.g.airline_section_y       (fileencoding, fileformat, 'bom', 'eol')
--vim.g.airline_section_z       (percentage, line number, column number)
--vim.g.airline_section_z       (percentage, line number, column number)
--vim.g.airline_section_error   (ycm_error_count, syntastic-err, eclim,
--                               "languageclient_error_count)
--vim.g.airline_section_warning (ycm_warning_count, syntastic-warn,
--                                 "languageclient_warning_count, whitespace)

vim.g.vim_pbcopy_local_cmd = 'pbcopy'
vim.o.clipboard = 'unnamedplus'


-- use zsh shell
--set shell=zsh\ -l
-- -l was causing issues with airline+fugitive combo
vim.o.shell = 'zsh'

-- soft tabs, 2 spaces, show line numbers, 80 width col
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.number = true
vim.o.colorcolumn = '80'

-- cursor line highlighting
vim.o.cursorline = true
-- backspace works across lines and between edit - less flipping between
-- insert/normal
vim.o.backspace = 'indent,eol,start'
-- polyglot/coc, syntax highlighting
vim.cmd('syntax on')

-- --- begin COC config ---
vim.o.hidden = true
vim.o.nobackup = true
vim.o.nowritebackup = true
vim.o.cmdheight = 2
vim.o.updatetime = 300
vim.o.shortmess = vim.o.shortmess .. 'c'
vim.o.signcolumn = 'yes'

-- use new window/buffer, split vertically (e.g. ack, fzf, but NOT nerdtree)
vim.o.switchbuf = 'vsplit'

-- --- end COC config ---

vim.o.wildmode = 'longest,list,full'
vim.o.wildmenu = true

-- show all other types of whitespace besides plain space

--vim.cmd('set list')
vim.o.listchars = 'eol:$,tab:>-,trail:~,extends:>,precedes:<'

-- onedark coloring
vim.cmd('colorscheme onedark')


-- highlight character beyond 80 character column
--vim.o.highlight = 'OverLength ctermbg=red ctermfg=white guibg=#592929'
--vim.api.nvim_command('highlight OverLength ctermbg=red ctermfg=white guibg=#592929')
vim.cmd('highlight OverLength ctermbg=red ctermfg=white guibg=#592929')
vim.o.match = 'OverLength /\\%81v.\\+/'

--"set statusline+=%#warningmsg#
--"set statusline+=%{SyntasticStatuslineFlag()}
--"set statusline+=%*
