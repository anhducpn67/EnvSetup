" Uncomment following lines if use Vundle plugin manager
" let $vimhome=fnamemodify(resolve(expand("~/.vimrc")), ':p:h')."/.vim"
" let $vundle=$vimhome."/bundle/Vundle.vim"

set nocompatible

"================================
"" Vundle settings
"================================
" Uncomment following lines if use Vundle plugin manager
"filetype off
"set rtp+=$vundle
"call vundle#begin()

"    Plugin 'VundleVim/Vundle.vim'

"    "----------------=== Code/Project navigation ===----------------
"    " Uncomment this if want to use NertTree plugin
"    " Plugin 'scrooloose/nerdtree'

"    "----------------=== Languages support ===----------------
"    Plugin 'tpope/vim-commentary'
"    " Uncomment this if want to use YouCompleteMe
"    " Plugin 'ycm-core/YouCompleteMe'

"    "----------------=== Python ===----------------
"    " Uncomment this if want to use syntastic plugin
"    " Plugin 'scrooloose/syntastic'

"    "----------------=== Other ===----------------
"    Plugin 'bling/vim-airline'
"    Plugin 'vim-airline/vim-airline-themes'
"    Plugin 'tpope/vim-fugitive'
"    Plugin 'tpope/vim-surround'
"    Plugin 'tpope/vim-unimpaired'

"call vundle#end()
filetype plugin indent on

"================================
"" General settings
"================================
syntax enable

set termguicolors
set t_Co=256
set background=dark
colorscheme molokayo

set hls
set number
set ruler
set ttyfast
set hidden

set tabstop=4
set shiftwidth=4
set smarttab
set expandtab
set autoindent

set cursorline
set showmatch

set wildmode=longest,list

set enc=utf-8

set backspace=indent,eol,start
set textwidth=79
set pumheight=20

set clipboard^=unnamed
set foldmethod=manual

"" Cursor setting for Window Terminal
if &term =~ '^xterm'
    " 1 -> blinking block
    " 2 -> solid block
    " 3 -> blinking underscore
    " 4 -> solid underscore
    " 5 -> blinking vertical bar
    " 6 -> solid vertical bar
    autocmd VimEnter * silent !echo -ne "\e[1 q"
    let &t_SI.="\e[5 q" " insert mode
    let &t_SR.="\e[4 q" " replace mode
    let &t_EI.="\e[1 q" " normal mode
    autocmd VimLeave * silent !echo -ne "\e[2 q"
endif

"================================
"" Key binding
"================================
inoremap " ""<left>
inoremap ' ''<left>
inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>

inoremap {<CR> {<CR>}<ESC>O

"================================
"" vim airline
"================================
let g:airline_theme='badwolf'
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#tabline#formatter='unique_tail'
let g:airline_powerline_fonts=1
let g:airline_section_y = ''
let g:airline_section_z = ''

"================================
"" syntastic
"================================
" Uncomment this part if use syntastic plugin
" let g:syntastic_always_populate_loc_list=1
" let g:syntastic_auto_loc_list=1
" let g:syntastic_enable_signs=1
" let g:syntastic_check_on_wq=0
" let g:syntastic_aggregate_errors=1
" let g:syntastic_loc_list_height=5
" let g:syntastic_error_symbol='X'
" let g:syntastic_style_error_symbol='X'
" let g:syntastic_warning_symbol='x'
" let g:syntastic_style_warning_symbol='x'
" let g:syntastic_python_checkers=['flake8', 'pydocstyle', 'python']
" let g:syntastic_c_checkers=['gcc', 'make']
" let g:syntastic_cpp_checkers=['gcc']

"================================
"" YouCompleteMe 
"================================
" Uncomment this part if use YouCompleteMe plugin
" let g:ycm_autoclose_preview_window_after_insertion = 1
" let g:ycm_autoclose_preview_window_after_completion = 1

" nnoremap <leader>g :YcmCompleter GoTo<CR>
" nnoremap <leader>d :YcmCompleter GoToDefinition<CR>
"
" ===============================
"" Coc.nvim
" ===============================
" Uncomment following lines if use coc.nvim plugin
" disable startup warning
" let g:coc_disable_startup_warning = 1

" " Use tab for trigger completion with characters ahead and navigate
" inoremap <silent><expr> <TAB>
"         \ coc#pum#visible() ? coc#pum#next(1) :
"         \ <SID>CheckBackSpace() ? "\<TAB>" :
"         \ coc#refresh()

" inoremap <silent><expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
"                                 \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" function! s:CheckBackSpace() abort
"     let col = col('.') - 1
"     return !col || getline('.')[col - 1] =~# '\s'
" endfunction
