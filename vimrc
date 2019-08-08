" Specify a directory for plugins
call plug#begin('~/.vim/plugged')

Plug 'editorconfig/editorconfig-vim'
Plug 'mileszs/ack.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'matze/vim-move'
Plug 'vim-airline/vim-airline'
Plug 'joshdick/onedark.vim'
Plug 'sheerun/vim-polyglot'
Plug 'mhinz/vim-signify'
Plug 'iamcco/mathjax-support-for-mkdp'
Plug 'iamcco/markdown-preview.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'heavenshell/vim-jsdoc'
Plug 'udalov/kotlin-vim'
" Note: extensions are auto updated and initial install is in install.sh
" auto update isn't support for in-line Plug based install :(
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Initialize plugin system
call plug#end()


" soft tabs, 2 spaces, show line numbers, 80 width col
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set number
set colorcolumn=80

" cursor line highlighting
set cursorline
" backspace works across lines and between edit - less flipping between
" insert/normal
set backspace=indent,eol,start
" polyglot/coc, syntax highlighting
syntax on

" --- begin COC config ---
set hidden
set nobackup
set nowritebackup
set cmdheight=2
set updatetime=300
set shortmess+=c
set signcolumn=yes

inoremap <silent><expr> <c-space> coc#refresh()

" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

nmap <leader>rn <Plug>(coc-rename)
" --- end COC config ---

set wildmode=longest,list,full
set wildmenu

" show all other types of whitespace besides plain space
"set list
"set listchars=eol:,tab:>-,trail:~,extends:>,precedes:<

" polyglot, syntax highlighting on
"syntax on
"let g:syntastic_jsx_checkers = ['eslint']
"let g:syntastic_jsx_eslint_exe = '$(yarn bin)/eslint'
"let g:syntastic_javascript_checkers = ['eslint']
"let g:syntastic_javascript_eslint_exe = '$(yarn bin)/eslint'
"let g:syntastic_json_checkers = ['jsonlint']
"let g:syntastic_json_jsonlint_exe = '$(yarn bin)/jsonlint'
"let g:syntastic_typescript_checkers = ['tslint']
"let g:syntastic_typescript_tslint_exe = '$(yarn bin)/tslint'

" onedark coloring
colorscheme onedark

set wildignore+=*/package-lock.json

" search for text globally
map <c-f> :Ack 
" fuzzy search for files
map <c-p> :FZF <enter>
" file tree
map <c-n> :NERDTreeToggle <enter>

" leader maps
let mapleader = ','
nmap <leader>n :NERDTreeFind <enter>
nmap <leader>m <Plug>MarkdownPreview
nmap <leader>j <Plug>(jsdoc)
"nmap <leader>s :SyntasticCheck <enter>
"nmap <leader>sd :SyntasticReset <enter>

" Use silver searcher with ack/fzf
let g:ackprg = 'ag --vimgrep'
let $FZF_DEFAULT_COMMAND = 'ag -g ""'

" vim-move ctrl+j, ctrl+k to move line
let g:move_key_modifier = 'c'

let NERDTreeRespectWildIgnore = 1
let NERDTreeShowHidden = 1

" open markdown preview in chrome
let g:mkdp_path_to_chrome = "open -a Google\\ Chrome"

" working dir = nearest dir w/ .git
let g:ctrlp_working_path_mode='r'

" vim-jsdoc
let g:jsdoc_allow_input_prompt = 1
let g:jsdoc_input_description = 1

" Add all gitignore entries to wildignore
" Ref: https://github.com/vim-scripts/gitignore
let globalIgnore = '/Users/druotic/.gitignore'
if filereadable(globalIgnore)
    let igstring = ''
    for oline in readfile(globalIgnore)
        let line = substitute(oline, '\s|\n|\r', '', "g")
        if line =~ '^#' | con | endif
        if line == '' | con  | endif
        if line =~ '^!' | con  | endif
        " strip trailing / for directories so that they are correctly ignored
        if line =~ '/$' | let igstring .= "," . substitute(line, '/$', '', '') | con | endif
        let igstring .= "," . line
    endfor
    let execstring = "set wildignore=".substitute(igstring, '^,', '', "g")
    execute execstring
endif

set clipboard=unnamed

" highlight character beyond 80 character column
highlight OverLength ctermbg=red ctermfg=white guibg=#592929
match OverLength /\%81v.\+/

" syntastic defaults
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*
"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1

""fuck you and your slow syntax checkinglet
"let g:syntastic_mode_map = { 'mode': 'passive',
                            "\ 'active_filetypes': [],
                            "\ 'passive_filetypes': [] }
"let g:syntastic_check_on_open = 0
"let g:syntastic_check_on_wq = 0
