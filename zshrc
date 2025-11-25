# ==============================================================================
# 1. Powerlevel10k Instant Prompt (반드시 최상단에 위치)
# ==============================================================================
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ==============================================================================
# 2. Oh My Zsh 기본 설정
# ==============================================================================
export ZSH="$HOME/.oh-my-zsh"

# 테마 설정: Powerlevel10k
ZSH_THEME="powerlevel10k/powerlevel10k"

# 플러그인 설정
# (주의: autosuggestions 등이 설치되어 있지 않으면 에러가 나므로, 일단 git만 활성화합니다.
#  설치 방법은 아래 설명을 참고하세요.)
plugins=(git)

source $ZSH/oh-my-zsh.sh

# ==============================================================================
# 3. OS별 분기 설정 (Mac vs Linux)
# ==============================================================================
SYSTEM_TYPE=$(uname -s)

if [[ "$SYSTEM_TYPE" == "Darwin" ]]; then
    # [Mac OS]
    if [[ -d "/opt/homebrew/bin" ]]; then
        export PATH="/opt/homebrew/bin:$PATH"
    fi
    
    # LLVM (C/C++ dev)
    if [[ -d "/opt/homebrew/opt/llvm/bin" ]]; then
        export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
    fi

    # Mac용 ls 컬러 및 별칭
    alias ll="ls -lG"
    alias la="ls -laG"
    alias ports="lsof -i -P"

elif [[ "$SYSTEM_TYPE" == "Linux" ]]; then
    # [Linux]
    alias ll="ls -l --color=auto"
    alias la="ls -la --color=auto"
    alias pbcopy='xclip -selection clipboard'
    alias pbpaste='xclip -selection clipboard -o'
fi

# ==============================================================================
# 4. 개발 환경 설정 (Python, Editor, Lang)
# ==============================================================================
# Pyenv 설정
# [Python] Pyenv 설정
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# 기본 에디터 및 언어 설정
export EDITOR='vim'
alias vi="vim"
export LANG=ko_KR.UTF-8
export LC_ALL=ko_KR.UTF-8

# ==============================================================================
# 5. 사용자 편의 별칭 & 추가 경로
# ==============================================================================
alias c="clear"
alias h="history"
alias ..="cd .."
alias ...="cd ../.."

# Git 단축키
alias gst="git status"
alias gco="git checkout"
alias gcm="git commit -m"
alias gp="git push"
alias gl="git pull"

# Antigravity (User Added)
if [[ -d "/Users/ctmctm/.antigravity/antigravity/bin" ]]; then
    export PATH="/Users/ctmctm/.antigravity/antigravity/bin:$PATH"
fi

# ==============================================================================
# 6. 로컬 설정 및 P10k 설정 로드 (최하단)
# ==============================================================================
if [[ -f ~/.zshrc.local ]]; then
    source ~/.zshrc.local
fi

# Powerlevel10k 설정 파일 로드
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
