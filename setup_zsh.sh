#!/bin/bash

# Color Variables
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}>>> Starting Full Environment Setup & Dotfiles Sync...${NC}"

# ==============================================================================
# 1. Install Dependencies & Tools
# ==============================================================================

# 1-1. Check & Install Homebrew
if ! command -v brew &> /dev/null; then
    echo -e "${GREEN}[1/9] Homebrew not found. Installing...${NC}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo -e "${GREEN}[1/9] Homebrew is already installed.${NC}"
fi

# 1-2. Install Git (Required for cloning)
echo -e "${GREEN}[2/9] Checking Git installation...${NC}"
brew install git

# 1-3. Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo -e "${GREEN}[3/9] Installing Oh My Zsh...${NC}"
    # --unattended: Install without user interaction
    # --keep-zshrc: We will replace it later with symlink
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
else
    echo -e "${GREEN}[3/9] Oh My Zsh is already installed.${NC}"
fi

# 1-4. Install Powerlevel10k Theme
P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
if [ ! -d "$P10K_DIR" ]; then
    echo -e "${GREEN}[4/9] Downloading Powerlevel10k theme...${NC}"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
else
    echo -e "${GREEN}[4/9] Powerlevel10k theme already exists.${NC}"
fi

# 1-5. Install Zsh Plugins (Autosuggestions & Syntax Highlighting)
PLUGIN_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"

if [ ! -d "$PLUGIN_DIR/zsh-autosuggestions" ]; then
    echo -e "${GREEN}[5/9] Installing zsh-autosuggestions...${NC}"
    git clone https://github.com/zsh-users/zsh-autosuggestions "$PLUGIN_DIR/zsh-autosuggestions"
fi

if [ ! -d "$PLUGIN_DIR/zsh-syntax-highlighting" ]; then
    echo -e "${GREEN}[5/9] Installing zsh-syntax-highlighting...${NC}"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$PLUGIN_DIR/zsh-syntax-highlighting"
fi

# 1-6. Download Fonts (MesloLGS NF)
echo -e "${GREEN}[6/9] Downloading Powerline fonts (MesloLGS NF)...${NC}"
FONT_DIR="$HOME/Library/Fonts"
curl -L -o "$FONT_DIR/MesloLGS NF Regular.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf"
curl -L -o "$FONT_DIR/MesloLGS NF Bold.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf"
curl -L -o "$FONT_DIR/MesloLGS NF Italic.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf"

# 1-7. Install Pyenv & Python
echo -e "${GREEN}[7/9] Installing Pyenv & LLVM...${NC}"
brew update
brew install pyenv llvm

if ! pyenv versions | grep -q "3.12.1"; then
    echo -e "${GREEN}[7/9] Installing Python 3.12.1...${NC}"
    pyenv install 3.12.1
    pyenv global 3.12.1
else
    echo -e "${GREEN}[7/9] Python 3.12.1 is already installed.${NC}"
fi

# ==============================================================================
# 2. Clone Dotfiles & Setup Symlinks
# ==============================================================================

DOTFILES_DIR="$HOME/dotfiles"
REPO_URL="https://github.com/blankroad/dotfiles.git"

echo -e "${GREEN}[8/9] Cloning dotfiles repository...${NC}"

if [ -d "$DOTFILES_DIR" ]; then
    echo "Dotfiles directory already exists. Pulling latest changes..."
    cd "$DOTFILES_DIR" && git pull
else
    git clone "$REPO_URL" "$DOTFILES_DIR"
fi

echo -e "${GREEN}[9/9] Setting up Symbolic Links...${NC}"

# Backup existing .zshrc if it's not already a symlink
if [ -f "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ]; then
    mv "$HOME/.zshrc" "$HOME/.zshrc.backup_$(date +%Y%m%d_%H%M%S)"
    echo "Existing .zshrc backed up."
fi

# Create Symlink
# Force link (-f) to overwrite if it exists
ln -sf "$DOTFILES_DIR/zshrc" "$HOME/.zshrc"
echo "Symbolic link created: ~/.zshrc -> ~/dotfiles/.zshrc"

# Create dummy folder for compatibility (as per your config)
mkdir -p "$HOME/.antigravity/antigravity/bin"

echo -e "${BLUE}>>> ===================================================== <<<${NC}"
echo -e "${BLUE}>>> Setup Complete!                                       <<<${NC}"
echo -e "${BLUE}>>> 1. Restart iTerm2.                                    <<<${NC}"
echo -e "${BLUE}>>> 2. Set Font to 'MesloLGS NF' in Preferences.          <<<${NC}"
echo -e "${BLUE}>>> ===================================================== <<<${NC}"cho -e "${BLUE}>>> IMPORTANT: Go to iTerm2 Preferences -> Profiles -> Text -> Font and select 'MesloLGS NF'.${NC}"
