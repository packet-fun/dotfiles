set nocompatible              " required
filetype off                  " required

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'morhetz/gruvbox'

"{{ The Basics }}
Plugin 'itchyny/lightline.vim'
Plugin 'shinchu/lightline-gruvbox.vim'
"Plugin 'suan/vim-instant-markdown', {'rtp': 'after'} " Markdown Preview
Plugin 'neoclide/coc.nvim', {'branch': 'release'}

"{{ File management }}
"Plugin 'scrooloose/nerdtree'                         " Nerdtree
Plugin 'vifm/vifm.vim'

"{{ Productivity }}
Plugin 'vimwiki/vimwiki'
Plugin 'tools-life/taskwiki'
Plugin 'ap/vim-css-color'                            " Color previews for CSS
"
"{{ Junegunn Choi Plugins }}
Plugin 'junegunn/goyo.vim'                           " Distraction-free viewing
Plugin 'junegunn/limelight.vim'                      " Hyperfocus on a range

call vundle#end()


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set expandtab                   " Use spaces instead of tabs.
set smarttab                    " Be smart using tabs ;)
set shiftwidth=4                " One tab == four spaces.
set tabstop=4                   " One tab == four spaces.
set spelllang=en_au

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Misc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set mouse=nicr                  " mouse scrolling
set noswapfile
set hidden
set number relativenumber
set noshowmode                  "lightline does this already
set t_Co=256                    " 256 colors
set cc=80                       " column width
noremap <Space> za

" Bind CTRL+S -> Save
nnoremap <silent> <C-s> :w<cr>
inoremap <silent> <C-s> <C-o><C-s>
cnoremap <silent> <C-s> <C-\><C-c><C-s>

set fillchars+=vert:\ 

"autocmd vimenter * colorscheme gruvbox
colorscheme gruvbox

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Splits and Tabbed Files
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set splitbelow splitright
"set nowrap
nnoremap <silent> \| :vs<CR>
nnoremap <silent> _ :split<CR>
" Remap splits navigation to just CTRL + hjkl
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => limelight
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Color name (:help cterm-colors) or ANSI code
let g:limelight_conceal_ctermfg = 'gray'
let g:limelight_conceal_ctermfg = 240

let g:limelight_priority = -1 "play nice with hilight searching

let g:lightline = {}
let g:lightline.colorscheme = 'gruvbox'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Vifm
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <Leader>vv :Vifm<CR>
map <Leader>vs :VsplitVifm<CR>
map <Leader>sp :SplitVifm<CR>
map <Leader>dv :DiffVifm<CR>
map <Leader>tv :TabVifm<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vimwiki
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"let g:vimwiki_list = [{'path': '~/vimwiki/',
"                      \ 'syntax': 'markdown', 'ext': '.md'}]

" Automatically generate wiki HTML on save, only display errors
autocmd BufWritePost *.wiki silent Vimwiki2HTML
"autocmd BufWritePost *.wiki set syntax=vimwiki

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => NERDTree
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Uncomment to autostart the NERDTree
" autocmd vimenter * NERDTree
map <C-n> :NERDTreeToggle<CR>
let g:NERDTreeDirArrowExpandable = '📁'
let g:NERDTreeDirArrowCollapsible = '📂'
let NERDTreeShowLineNumbers=1
let NERDTreeShowHidden=1
let NERDTreeMinimalUI = 1
let g:NERDTreeWinSize=38

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Coc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set updatetime=300
set shortmess+=c

" tab complete
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif
