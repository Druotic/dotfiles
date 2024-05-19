local Plug = vim.fn['plug#']

-- Specify a directory for plugins
vim.call('plug#begin', '~/.vim/plugged')

Plug 'tpope/vim-sensible'
Plug 'editorconfig/editorconfig-vim'
Plug('prettier/vim-prettier', {
  ['do'] = 'yarn install --frozen-lockfile --production',
  ['for'] = {'javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'svelte', 'yaml', 'html'} })

-- required dep for telescope
Plug 'nvim-lua/plenary.nvim'
-- file fuzzy search
Plug('nvim-telescope/telescope.nvim', { tag = '0.1.5' })
Plug('nvim-telescope/telescope-fzf-native.nvim', { ['do'] = 'make' })
Plug 'nvim-telescope/telescope-live-grep-args.nvim'

Plug 'mhinz/vim-grepper'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'matze/vim-move'
Plug 'vim-airline/vim-airline'
Plug 'joshdick/onedark.vim'
Plug 'sheerun/vim-polyglot'
Plug 'mhinz/vim-signify'
Plug 'iamcco/mathjax-support-for-mkdp'
Plug('iamcco/markdown-preview.nvim', { ['do'] = 'cd app & yarn install'  })
Plug 'scrooloose/nerdcommenter'
Plug('heavenshell/vim-jsdoc', {
  ['for'] = {'javascript', 'javascript.jsx','typescript'},
  ['do'] = 'make install'
})
Plug 'dense-analysis/ale'

Plug 'udalov/kotlin-vim'
Plug('neoclide/coc.nvim', {branch = 'release'})
-- sometimes causes zsh issues?
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'

Plug 'kyazdani42/nvim-web-devicons'
Plug('kyazdani42/nvim-tree.lua', { on = 'NvimTreeToggle' })

--"""" TODO - future exploration
-- luasnip for common/custom snippets
-- nvim-dap for debugger support
-- harpoon w/ telescope for frequent file nav
-- telescope smart history for easier use of telescope search

-- Initialize plugin system
vim.call('plug#end')

-- TODO: convert to lua
vim.cmd [[
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  autocmd VimEnter * CocInstall coc-json coc-tsserver coc-html coc-python coc-jest coc-sh coc-eslint coc-docker coc-prettier --sync
endif

set wildignore+=*/package-lock.json

"
" Add all gitignore entries to wildignore
" Ref: https://github.com/vim-scripts/gitignore
let globalIgnore = '~/.gitignore'
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
]]

function require_all_in_directory(dir)
  local scan_dir = vim.fn.stdpath('config') .. '/lua/' .. dir
  local files = vim.fn.globpath(scan_dir, '*.lua', false, true)

  for _, file in ipairs(files) do
      local file_no_extension = file:match(".*/lua/(.+)%.lua")
      require(file_no_extension)
  end
end

require_all_in_directory('config')
require_all_in_directory('plugins')
