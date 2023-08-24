if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Specify a directory for plugins
call plug#begin('~/.vim/plugged')

Plug 'editorconfig/editorconfig-vim'
Plug 'prettier/vim-prettier'
Plug 'mileszs/ack.vim'
Plug 'mhinz/vim-grepper'
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
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }
Plug 'scrooloose/nerdcommenter'
Plug 'heavenshell/vim-jsdoc', {
  \ 'for': ['javascript', 'javascript.jsx','typescript'],
  \ 'do': 'make install'
\}
"Plug 'kkoomen/vim-doge', { 'do': { -> doge#install() } }
"Plug 'kkoomen/vim-doge', { 'do': 'npm i --no-save && npm run build:binary:unix' }

Plug 'udalov/kotlin-vim'
" Note: extensions are auto updated and initial install is in install.sh
" auto update isn't support for in-line Plug based install :(
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" TODO: re-enable, but having issues with zsh?
"Plug 'tpope/vim-fugitive'

" Initialize plugin system
call plug#end()

" use zsh shell
set shell=zsh\ -l

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

" use new window/buffer, split vertically (e.g. ack, fzf, but NOT nerdtree)
set switchbuf=vsplit

inoremap <silent><expr> <c-space> coc#refresh()
inoremap <expr> <Enter> coc#pum#visible() ? coc#pum#confirm() : "\<Enter>"

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
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<

" polyglot, syntax highlighting on
syntax on
let g:syntastic_jsx_checkers = ['eslint']
let g:syntastic_jsx_eslint_exe = '$(yarn bin)/eslint'
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_javascript_eslint_exe = '$(yarn bin)/eslint'
let g:syntastic_json_checkers = ['jsonlint']
let g:syntastic_json_jsonlint_exe = '$(yarn bin)/jsonlint'
let g:syntastic_typescript_checkers = ['eslint']
let g:syntastic_typescript_tslint_exe = '$(yarn bin)/eslint'

let g:coc_disable_startup_warning = 1

" onedark coloring
colorscheme onedark

set wildignore+=*/package-lock.json

" search for text globally
map <c-f> :Grepper<Enter>
" :Ack! 
" fuzzy search for files
map <c-p> :Files<CR>
"map <c-p> :call fzf#run({ 'source': 'ag -g ""', 'sink': 'e', 'window': 'enew' }) <enter>
" file tree
map <c-n> :NERDTreeToggle <enter>

" leader maps
let mapleader = ','
nmap <leader>n :NERDTreeFind <enter>
nmap <leader>m <Plug>MarkdownPreview
nmap <leader>j <Plug>(jsdoc)
vmap <leader>j :!python -m json.tool <enter>
"nmap <leader>s :SyntasticCheck <enter>
"nmap <leader>sd :SyntasticReset <enter>

" Use silver searcher with ack/fzf
let g:grepper = { 'tools': ['rg'] }
let $FZF_DEFAULT_COMMAND = 'rg --files'

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

" https://github.com/vim-airline/vim-airline/blob/master/doc/airline.txt#L392
" Show parent of parent directory name up to 20 chars. E.g. 'lifeomic',
" 'lifeomic-clone', etc to make working with multiple copies of the same project
" in parallel easier.
"let g:airline_section_b = '%-0.20{fnamemodify(getcwd(), ":h:t")}'
"let g:airline_section_b = '%-0.30{fnamemodify(getcwd(), ":hk")}'
" update: relative to root - e.g. /Users/druotic/repos/work/lifeomic/...
" TODO: re-enable
"let g:airline_section_b = '%-0.20{split(getcwd(), "/")[4]}'
"
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

let g:vim_pbcopy_local_cmd='pbcopy'
set clipboard=unnamedplus

" highlight character beyond 80 character column
highlight OverLength ctermbg=red ctermfg=white guibg=#592929
match OverLength /\%81v.\+/

" syntastic defaults
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*
"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1

"" slow syntax checking
"let g:syntastic_mode_map = { 'mode': 'passive',
                            "\ 'active_filetypes': [],
                            "\ 'passive_filetypes': [] }
"let g:syntastic_check_on_open = 0
"let g:syntastic_check_on_wq = 0