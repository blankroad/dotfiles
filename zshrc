# ==============================================================================
# 1. Powerlevel10k Instant Prompt (Must stay at the very top)
# ==============================================================================
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ==============================================================================
# 2. Oh My Zsh Basic Settings
# ==============================================================================
export ZSH="$HOME/.oh-my-zsh"

# Theme Configuration: Powerlevel10k
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugin Configuration
# (Ensure plugins are installed via git clone before enabling here)
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# ==============================================================================
# 3. OS Specific Configuration (Mac vs Linux)
# ==============================================================================
SYSTEM_TYPE=$(uname -s)

if [[ "$SYSTEM_TYPE" == "Darwin" ]]; then
    # [macOS]
    if [[ -d "/opt/homebrew/bin" ]]; then
        export PATH="/opt/homebrew/bin:$PATH"
    fi
    
    # LLVM (C/C++ dev)
    if [[ -d "/opt/homebrew/opt/llvm/bin" ]]; then
        export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
    fi

    # ls colors and aliases for macOS
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
# 4. Development Environment (Python, Editor, Lang)
# ==============================================================================
# [Python] Pyenv Configuration
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Default Editor and Language Settings
export EDITOR='vim'
alias vi="vim"
export LANG=ko_KR.UTF-8
export LC_ALL=ko_KR.UTF-8

# ==============================================================================
# 5. User Aliases & Additional Paths
# ==============================================================================
alias c="clear"
alias h="history"
alias ..="cd .."
alias ...="cd ../.."

# Git Shortcuts
alias gst="git status"
alias gco="git checkout"
alias gcm="git commit -m"
alias gp="git push"
alias gl="git pull"

# ==============================================================================
# 6. Load Local Config and P10k Config (Bottom)
# ==============================================================================
if [[ -f ~/.zshrc.local ]]; then
    source ~/.zshrc.local
fi

# Load Powerlevel10k Configuration File
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
