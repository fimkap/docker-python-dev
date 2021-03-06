if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
" }}}
call plug#begin('~/.config/nvim/plugged')
Plug 'rakr/vim-one'
Plug 'ervandew/supertab'
Plug 'neomake/neomake'
" Plug 'artur-shaik/vim-javacomplete2'
Plug 'junegunn/fzf', { 'do': './install --all' }
Plug 'junegunn/fzf.vim'
"Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'maralla/completor.vim'
Plug 'tpope/vim-fugitive'
" Plug 'google/vim-maktaba'
" Plug 'google/vim-codefmt'
" Plug 'google/vim-glaive'
Plug 'ludovicchabant/vim-gutentags'
" Plug 'airblade/vim-rooter'
Plug 'davidhalter/jedi-vim'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
augroup nerd_loader
    autocmd!
    autocmd VimEnter * silent! autocmd! FileExplorer
    autocmd BufEnter,BufNew *
                \  if isdirectory(expand('<amatch>'))
                \|   call plug#load('nerdtree')
                \|   execute 'autocmd! nerd_loader'
                \| endif
augroup END
call plug#end()
let mapleader      = ' '
let maplocalleader = ' '
filetype plugin indent on
set nobackup
set nowritebackup
set noswapfile
set autoread
set shortmess+=c
set mousemodel=extend
set mouse=a
set pumheight=15
colorscheme one
set background=dark
set noshowmode
set signcolumn=yes
set shiftwidth=4
set tabstop=4
set softtabstop=4
set expandtab
set ic
set is
set diffopt=filler,vertical,iwhite
nnoremap <BS> :e #<CR>
nnoremap <leader>te :below 25sp term:///bin/bash<cr>i
"let g:deoplete#enable_at_startup=1
" autocmd FileType java setlocal omnifunc=javacomplete#Complete
if has('termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif
let g:python3_host_prog='/usr/bin/python3'
let g:python_host_prog='/usr/bin/python'
" When writing a buffer (no delay).
call neomake#configure#automake('w')
" let g:completor_java_omni_trigger = '(\w+\.)$'
" }}}
" ============================================================================
" FZF {{{
" ============================================================================

if has('nvim') || has('gui_running')
  let $FZF_DEFAULT_OPTS .= ' --inline-info'
endif

" Hide statusline of terminal buffer
autocmd! FileType fzf
autocmd  FileType fzf set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

" nnoremap <silent> <Leader><Leader> :Files<CR>
nnoremap <silent> <expr> <Leader><Leader> (expand('%') =~ 'NERD_tree' ? "\<c-w>\<c-w>" : '').":Files\<cr>"
nnoremap <silent> <Leader>C        :Colors<CR>
nnoremap <silent> <Leader><Enter>  :Buffers<CR>
nnoremap <silent> <Leader>l        :Lines<CR>
nnoremap <silent> <Leader>ag       :Ag <C-R><C-W><CR>
nnoremap <silent> <Leader>AG       :Ag <C-R><C-A><CR>
xnoremap <silent> <Leader>ag       y:Ag <C-R>"<CR>
nnoremap <silent> <Leader>`        :Marks<CR>

inoremap <expr> <c-x><c-t> fzf#complete('tmuxwords.rb --all-but-current --scroll 500 --min 5')
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
inoremap <expr> <c-x><c-d> fzf#vim#complete#path('blsd')
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)

nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

highlight NeomakeErrorSign ctermfg=red ctermbg=234 guifg=#ff0000 guibg=bg
highlight NeomakeWarningSign ctermfg=yellow ctermbg=234 guifg=#e6e600 guibg=bg

let g:neomake_error_sign = {
    \ 'text': '',
    \ 'texthl': 'NeomakeErrorSign',
    \ }
let g:neomake_warning_sign = {
    \ 'text': '',
    \ 'texthl': 'NeomakeWarningSign',
    \ }

" codefmt
" call glaive#Install()
" Optional: Enable codefmt's default mappings on the <Leader>= prefix.
" Glaive codefmt plugin[mappings]
" Glaive codefmt google_java_executable="java -jar /root/google-java-format-1.6-all-deps.jar"

let g:NERDTreeDirArrowExpandable=""
let g:NERDTreeDirArrowCollapsible=""

hi NonText ctermfg=bg

" JSON format
nmap <Leader>jf :%!python -m json.tool<CR>

nmap <Leader>nt :NERDTreeToggle<CR>

hi EndOfBuffer guibg=bg guifg=bg
hi VertSplit guibg=bg guifg=bg
hi LineNr guibg=bg
hi SignColumn guibg=bg
