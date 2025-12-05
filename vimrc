" ==========================================
" 1. Basic Settings
" ==========================================
set nocompatible            " Disable Vi compatibility mode (Use Vim features)
filetype off                " Temporarily disable filetype detection for plugin loading

set number                  " Show line numbers
set relativenumber          " Show relative line numbers (Easier for jumping, remove if preferred)
set cursorline              " Highlight the current cursor line
set ruler                   " Show cursor position
set showcmd                 " Show incomplete commands

" Indentation Settings (Python PEP8 Standard)
set autoindent              " Auto-indent new lines
set smartindent             " Smart auto-indenting
set tabstop=4               " Number of spaces that a <Tab> counts for
set shiftwidth=4            " Number of spaces to use for each step of (auto)indent
set expandtab               " Use spaces instead of tabs
set backspace=indent,eol,start " Configure backspace behavior

" Search Settings
set ignorecase              " Ignore case when searching
set smartcase               " Override ignorecase if search pattern contains uppercase
set hlsearch                " Highlight search matches
set incsearch               " Search as characters are entered

set mouse=a                 " Enable mouse support
set encoding=utf-8          " Set file encoding to UTF-8
syntax on                   " Enable syntax highlighting

" ==========================================
" 1.1 Swap & Backup Settings (New)
" ==========================================
" Enable swap files for crash recovery
set swapfile

" Centralize swap files to ~/.vim/swap to avoid cluttering project directories
" The // at the end ensures unique filenames based on full path
set directory=$HOME/.vim/swap//

" Persistent Undo (Optional but recommended)
" Keeps undo history even after closing and reopening Vim
set undofile
set undodir=$HOME/.vim/undo//

" Disable backup files (file~)
set nobackup
set nowritebackup

" ==========================================
" 2. Plugin List (Plugins via vim-plug)
" ==========================================
call plug#begin('~/.vim/plugged')

    " [File Explorer] Coc-Explorer replaces NERDTree
    " (NERDTree is kept just in case, but Ctrl+n will open Coc-Explorer)
    Plug 'preservim/nerdtree'
    
    " [Status Bar] Airline (Fancy status bar)
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    
    " [Theme] Gruvbox (Eye-friendly theme)
    Plug 'morhetz/gruvbox'
    
    " [Search] FZF (Requires fzf installed via brew)
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'

    " [Git] Fugitive (Git wrapper)
    Plug 'tpope/vim-fugitive'
    
    " [Git] GitGutter (Show diffs +, -, ~ in the gutter)
    " Note: coc-git also provides gutter signs, you might want to disable this if using coc-git
    Plug 'airblade/vim-gitgutter'

    " [Autocomplete/LSP] Coc.nvim (VS Code-like intelligence)
    " Note: Node.js must be installed
    Plug 'neoclide/coc.nvim', {'branch': 'release'}

    " [Python] Better indentation
    Plug 'vim-scripts/indentpython.vim'

    " [Debugging] GUI-style debugger
    Plug 'puremourning/vimspector'

call plug#end()

" ==========================================
" 3. General Plugin & Keymap Settings
" ==========================================
filetype plugin indent on   " Enable filetype plugins and indentation

" [Theme Settings]
set background=dark
colorscheme gruvbox

" [FZF] File Search with Ctrl + p (VS Code style)
map <C-p> :Files<CR>

" ==========================================
" 4. Coc.nvim Specific Settings (Enhanced)
" ==========================================

" [Auto-Install Extensions]
" Automatically installs these extensions if missing
" Added 'coc-explorer' and 'coc-git' to the list
let g:coc_global_extensions = [
  \ 'coc-explorer',
  \ 'coc-git',
  \ 'coc-pyright',
  \ 'coc-clangd', 
  \ 'coc-json', 
  \ 'coc-sh', 
  \ 'coc-yaml',
  \ 'coc-snippets',
  \ 'coc-vimlsp'
  \ ]

" [Coc-Explorer] Toggle with Ctrl + n (Replaces NERDTree)
nmap <C-n> :CocCommand explorer<CR>

" [Autocomplete] Tab to select, Enter to confirm
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> (Enter) accept selected completion item or notify coc.nvim to format
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" [Navigation] Go to Definition/Type/Implementation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" [Diagnostics] Navigate between errors ( like [g and ]g )
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" [Git] coc-git navigation & actions
" [c : Prev chunk, ]c : Next chunk
nmap <silent> [c <Plug>(coc-git-prevchunk)
nmap <silent> ]c <Plug>(coc-git-nextchunk)
" gs : Show chunk info at current cursor
nmap <silent> gs <Plug>(coc-git-chunkinfo)
" <leader>gb : Show git blame info
nmap <silent> <leader>gb :CocCommand git.showBlameDoc<CR>

" [Documentation] Show documentation with K
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" [Rename] Rename variable across files (<leader>rn)
nmap <leader>rn <Plug>(coc-rename)

" [Highlight] Highlight symbol under cursor on hold
autocmd CursorHold * silent call CocActionAsync('highlight')

" [Format] Format code (<leader>f)
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" ==========================================
" 5. C/C++ Specific Settings
" ==========================================

" [C/C++] F9: Compile (Uses Make if available, else simple clang build)
autocmd FileType c,cpp map <F9> :call CompileCode()<CR>
func! CompileCode()
    exec "w"
    if &filetype == 'c'
        exec "!clang -g % -o %<"
    elseif &filetype == 'cpp'
        " Build with C++17 standard (Change to -std=c++20 if needed)
        exec "!clang++ -g -std=c++17 % -o %<"
    endif
endfunc

" [C/C++] F10: Run (Output to terminal)
autocmd FileType c,cpp map <F10> :call RunCode()<CR>
func! RunCode()
    exec "!./%<"
endfunc

" [Vim-Inspector] Debugger settings (Optional)
" F5: Start debugging / F8: Add breakpoint
let g:vimspector_enable_mappings = 'HUMAN'

" ==========================================
" 6. Mac Clipboard Integration
" ==========================================
" y (yank) -> Cmd+V (paste) works
" Cmd+C (copy) -> p (paste) works
set clipboard=unnamed
