#!/bin/bash

# Color Variables
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}>>> Starting Vim Environment Setup...${NC}"

# ==============================================================================
# 1. Install Dependencies (Node.js, FZF, etc.)
# ==============================================================================

# Check Homebrew
if ! command -v brew &> /dev/null; then
    echo -e "${GREEN}[1/5] Homebrew not found. Installing...${NC}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

echo -e "${GREEN}[2/5] Installing Vim dependencies (Node.js, FZF, Ripgrep)...${NC}"
# vim: Install updated vim (system vim is old)
# node: Required for coc.nvim
# fzf, ripgrep: Required for FZF plugin
brew install vim node fzf ripgrep

# Install FZF key bindings
$(brew --prefix)/opt/fzf/install --all --no-bash --no-fish

# ==============================================================================
# 2. Install Vim-Plug (Plugin Manager)
# ==============================================================================
echo -e "${GREEN}[3/5] Installing vim-plug...${NC}"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

mkdir -p ~/.vim/swap ~/.vim/undo

# ==============================================================================
# 3. Link .vimrc (Symlink)
# ==============================================================================
echo -e "${GREEN}[4/5] Linking .vimrc...${NC}"
DOTFILES_DIR="$HOME/dotfiles"

# Backup existing .vimrc
if [ -f "$HOME/.vimrc" ] && [ ! -L "$HOME/.vimrc" ]; then
    mv "$HOME/.vimrc" "$HOME/.vimrc.backup_$(date +%Y%m%d_%H%M%S)"
    echo "Backed up existing .vimrc."
fi

# Link file (Assuming you have cloned the repo in previous steps)
# If the file doesn't exist yet, we create a placeholder so setup doesn't fail
if [ -f "$DOTFILES_DIR/.vimrc" ]; then
    ln -sf "$DOTFILES_DIR/vimrc" "$HOME/.vimrc"
    echo "Linked ~/dotfiles/vimrc to ~/.vimrc"
else
    echo "Warning: ~/dotfiles/vimrc not found. Creating a temporary one."
    touch "$HOME/.vimrc"
fi

# ==============================================================================
# 4. Install Plugins via Vim
# ==============================================================================
echo -e "${GREEN}[5/5] Installing Vim plugins (Headless)...${NC}"

# Run PlugInstall without opening Vim interface
vim -es -u "$HOME/.vimrc" -i NONE -c "PlugInstall" -c "qa"

echo -e "${BLUE}>>> Vim Setup Complete!${NC}"
echo -e "${BLUE}>>> Note: For C/C++ functionality, ensure Xcode Command Line Tools are installed.${NC}"
