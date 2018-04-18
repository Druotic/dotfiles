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


" Initialize plugin system
call plug#end()


" soft tabs, 2 spaces, show line numbers
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set number

" cursor line highlighting
set cursorline
" backspace works across lines and between edit - less flipping between
" insert/normal
set backspace=indent,eol,start

" show all other types of whitespace besides plain space
"set list
"set listchars=eol:,tab:>-,trail:~,extends:>,precedes:<


" onedark coloring
syntax on
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
nmap <leader>m <Plug>MarkdownPreview
nmap <leader>j <Plug>(jsdoc)

" Use silver searcher with ack/fzf
let g:ackprg = 'ag --vimgrep'
let $FZF_DEFAULT_COMMAND = 'ag -g ""'

" vim-move ctrl+j, ctrl+k to move line
let g:move_key_modifier = 'c'

let NERDTreeRespectWildIgnore = 1
let NERDTreeShowHidden = 1

" open markdown preview in chrome
let g:mkdp_path_to_chrome = "open -a Google\\ Chrome"

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
