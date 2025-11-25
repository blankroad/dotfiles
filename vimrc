" ==========================================
" 1. 기본 설정 (Basic Settings)
" ==========================================
set nocompatible            " Vi 호환 모드 끄기 (Vim 기능 사용)
filetype off                " 플러그인 로딩을 위해 잠시 끔

set number                  " 라인 번호 표시
set relativenumber          " 상대 라인 번호 표시 (점프하기 편함, 싫으면 지우세요)
set cursorline              " 현재 커서 라인 강조
set ruler                   " 커서 위치 표시
set showcmd                 " 입력 중인 명령어 표시

" 들여쓰기 설정 (파이썬 PEP8 기준)
set autoindent              " 자동 들여쓰기
set smartindent             " 스마트 들여쓰기
set tabstop=4               " 탭을 4칸으로
set shiftwidth=4            " 자동 들여쓰기 너비 4칸
set expandtab               " 탭을 공백으로 변환
set backspace=indent,eol,start " 백스페이스 동작 설정

" 검색 설정
set ignorecase              " 검색 시 대소문자 무시
set smartcase               " 대문자가 포함되면 대소문자 구분
set hlsearch                " 검색어 강조
set incsearch               " 입력과 동시에 검색

set mouse=a                 " 마우스 사용 허용
set encoding=utf-8          " 인코딩 설정
syntax on                   " 문법 강조 켜기

" ==========================================
" 2. 플러그인 목록 (Plugins via vim-plug)
" ==========================================
call plug#begin('~/.vim/plugged')

    " [파일 탐색기] NERDTree (Ctrl+n으로 열기)
    Plug 'preservim/nerdtree'
    
    " [하단 상태바] Airline (예쁜 상태바)
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    
    " [테마] Gruvbox (눈이 편안한 테마)
    Plug 'morhetz/gruvbox'
    
    " [검색] FZF (맥 brew로 설치된 fzf 연동)
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'

    " [Git] Fugitive (Git 명령어 연동)
    Plug 'tpope/vim-fugitive'
    
    " [Git] 라인 옆에 수정사항 표시 (+, -, ~)
    Plug 'airblade/vim-gitgutter'

    " [자동완성/LSP] Coc.nvim (VS Code급 자동완성 엔진)
    " 주의: Node.js가 설치되어 있어야 합니다.
    Plug 'neoclide/coc.nvim', {'branch': 'release'}

    " [파이썬] 들여쓰기 보정
    Plug 'vim-scripts/indentpython.vim'

    " [디버깅] GUI 스타일 디버거
    Plug 'puremourning/vimspector'

call plug#end()

" ==========================================
" 3. 플러그인 및 단축키 설정
" ==========================================
filetype plugin indent on   " 파일 타입별 플러그인/들여쓰기 활성화

" [테마 설정]
set background=dark
colorscheme gruvbox

" [NERDTree] Ctrl + n 으로 켜고 끄기
map <C-n> :NERDTreeToggle<CR>

" [FZF] Ctrl + p 로 파일 검색 (VS Code 스타일)
map <C-p> :Files<CR>

" [Coc.nvim] 탭 키로 자동완성 선택
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" [Coc.nvim] 파이썬 정의로 이동 (gd)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gr <Plug>(coc-references)

" ==========================================
" 4. C/C++ 전용 설정 (Added for C/C++)
" ==========================================

" [C/C++] F9: 컴파일 (Make가 있으면 make, 없으면 단순 g++ 빌드)
autocmd FileType c,cpp map <F9> :call CompileCode()<CR>
func! CompileCode()
    exec "w"
    if &filetype == 'c'
        exec "!clang -g % -o %<"
    elseif &filetype == 'cpp'
        " C++17 표준으로 빌드 (필요시 -std=c++20 등으로 변경)
        exec "!clang++ -g -std=c++17 % -o %<"
    endif
endfunc

" [C/C++] F10: 실행 (터미널 하단에 결과 출력)
autocmd FileType c,cpp map <F10> :call RunCode()<CR>
func! RunCode()
    exec "!./%<"
endfunc

" [Vim-Inspector] 디버깅을 위한 플러그인 설정 (선택 사항)
" F5: 디버깅 시작 / F8: 브레이크포인트 추가
let g:vimspector_enable_mappings = 'HUMAN'
