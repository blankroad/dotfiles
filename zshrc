# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh
# ==============================================================================
# 1. Oh My Zsh 기본 설정 (Basic Oh My Zsh Settings)
# ==============================================================================
export ZSH="$HOME/.oh-my-zsh"

# 테마 설정 (선호하는 테마로 변경 가능: agnoster, powerlevel10k 등)
# 폰트 깨짐이 발생하면 "robbyrussell"로 변경하세요.
ZSH_THEME="agnoster"

# 사용할 플러그인 목록 (git은 기본, 나머지는 설치 필요 시 추가)
plugins=(git)

source $ZSH/oh-my-zsh.sh

# ==============================================================================
# 2. OS별 분기 설정 (Mac vs Linux)
# ==============================================================================
# OS 종류 감지
SYSTEM_TYPE=$(uname -s)

if [[ "$SYSTEM_TYPE" == "Darwin" ]]; then
    # ----------------------------------------
    # [Mac OS 설정]
    # ----------------------------------------
    
    # Apple Silicon Homebrew 경로 설정
    if [[ -d "/opt/homebrew/bin" ]]; then
        export PATH="/opt/homebrew/bin:$PATH"
    fi

    # C/C++ 개발용 LLVM(Clangd) 경로 (Brew로 설치한 버전 우선 사용)
    # coc-clangd가 시스템 기본 clang보다 최신 기능을 쓰기 위함
    if [[ -d "/opt/homebrew/opt/llvm/bin" ]]; then
        export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
    fi

    # Mac용 ls 컬러 및 별칭
    export CLICOLOR=1
    export LSCOLORS=Gxfxcxdxbxegedabagacad
    alias ll="ls -lG"
    alias la="ls -laG"
    
    # 네트워크 유틸리티 (포트 확인 등)
    alias ports="lsof -i -P"

elif [[ "$SYSTEM_TYPE" == "Linux" ]]; then
    # ----------------------------------------
    # [Ubuntu/Linux 설정]
    # ----------------------------------------
    
    # 리눅스용 ls 컬러 및 별칭
    alias ll="ls -l --color=auto"
    alias la="ls -la --color=auto"

    # 클립보드 공유 (xclip 설치 필요: sudo apt install xclip)
    # Mac의 pbcopy, pbpaste 명령어를 리눅스에서도 흉내 냄
    alias pbcopy='xclip -selection clipboard'
    alias pbpaste='xclip -selection clipboard -o'
fi

# ==============================================================================
# 3. 개발 언어 및 환경 설정 (Languages & Tools)
# ==============================================================================

# [Python] Pyenv 설정 (가장 중요)
# 시스템 파이썬 대신 우리가 설치한 파이썬을 우선순위로 둠
export PYENV_ROOT="$HOME/.pyenv"
if [[ -d $PYENV_ROOT/bin ]]; then
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
fi

# [Editor] 기본 에디터를 Vim으로 설정
export EDITOR='vim'
alias vi="vim"

# [Encoding] 한글 처리
export LANG=ko_KR.UTF-8
export LC_ALL=ko_KR.UTF-8

# ==============================================================================
# 4. 사용자 편의 별칭 (Aliases)
# ==============================================================================
alias c="clear"
alias h="history"
alias ..="cd .."
alias ...="cd ../.."

# Git 단축키 (자주 쓰는 것)
alias gst="git status"
alias gco="git checkout"
alias gcm="git commit -m"
alias gp="git push"
alias gl="git pull"

# ==============================================================================
# 5. 보안 및 로컬 설정 (Secret Keys)
# ==============================================================================
if [[ -f ~/.zshrc.local ]]; then
    source ~/.zshrc.local
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"

# Added by Antigravity
export PATH="/Users/ctmctm/.antigravity/antigravity/bin:$PATH"
