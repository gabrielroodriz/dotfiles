#!/bin/bash

# Cores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Iniciando instalação dos dotfiles...${NC}"

# Criar diretório principal
DOTFILES_DIR="$HOME/.dotfiles"
mkdir -p "$DOTFILES_DIR"/{git,npm,vscode,terminal,expo}

# Detectar sistema operacional
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
    echo -e "${YELLOW}📦 Sistema detectado: Linux${NC}"
    
    # VS Code no Linux
    VSCODE_CONFIG_DIR="$HOME/.config/Code/User"
    
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
    echo -e "${YELLOW}📦 Sistema detectado: macOS${NC}"
    
    # VS Code no macOS
    VSCODE_CONFIG_DIR="$HOME/Library/Application Support/Code/User"
else
    echo -e "${RED}❌ Sistema operacional não suportado${NC}"
    exit 1
fi

# Função para criar symlink com verificação
create_symlink() {
    local source=$1
    local target=$2
    
    if [ -L "$target" ]; then
        echo -e "${YELLOW}⚠️  Symlink já existe: $target${NC}"
    elif [ -f "$target" ] || [ -d "$target" ]; then
        echo -e "${YELLOW}⚠️  Arquivo/diretório existe: $target. Criando backup...${NC}"
        mv "$target" "$target.backup.$(date +%Y%m%d%H%M%S)"
        ln -sf "$source" "$target"
        echo -e "${GREEN}✅ Symlink criado: $target${NC}"
    else
        ln -sf "$source" "$target"
        echo -e "${GREEN}✅ Symlink criado: $target${NC}"
    fi
}

# Git configuration
echo -e "\n${GREEN}📝 Configurando Git...${NC}"
create_symlink "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"
create_symlink "$DOTFILES_DIR/git/.gitignore_global" "$HOME/.gitignore_global"

# NPM configuration
echo -e "\n${GREEN}📦 Configurando NPM...${NC}"
create_symlink "$DOTFILES_DIR/npm/.npmrc" "$HOME/.npmrc"

# VS Code configuration
echo -e "\n${GREEN}💻 Configurando VS Code...${NC}"
mkdir -p "$VSCODE_CONFIG_DIR"
create_symlink "$DOTFILES_DIR/vscode/settings.json" "$VSCODE_CONFIG_DIR/settings.json"
create_symlink "$DOTFILES_DIR/vscode/extensions.json" "$VSCODE_CONFIG_DIR/extensions.json"

# Terminal configuration
echo -e "\n${GREEN}🖥️  Configurando Terminal...${NC}"
create_symlink "$DOTFILES_DIR/terminal/.zshrc" "$HOME/.zshrc"
create_symlink "$DOTFILES_DIR/terminal/.aliases" "$HOME/.aliases"

# Expo configuration
echo -e "\n${GREEN}📱 Configurando Expo...${NC}"
create_symlink "$DOTFILES_DIR/expo/.expo-shared" "$HOME/.expo-shared"

# Instalar dependências específicas do SO
if [ "$OS" = "linux" ]; then
    echo -e "\n${GREEN}🔧 Instalando dependências Linux...${NC}"
    
    # Detectar gerenciador de pacotes
    if command -v apt &> /dev/null; then
        PKG_MANAGER="apt"
        echo "Usando apt..."
        sudo apt update
        sudo apt install -y \
            curl \
            git \
            zsh \
            build-essential \
            eza \
            neovim \
            xclip
    elif command -v dnf &> /dev/null; then
        PKG_MANAGER="dnf"
        echo "Usando dnf..."
        sudo dnf install -y \
            curl \
            git \
            zsh \
            gcc \
            gcc-c++ \
            make \
            eza \
            neovim \
            xclip
    elif command -v pacman &> /dev/null; then
        PKG_MANAGER="pacman"
        echo "Usando pacman..."
        sudo pacman -Syu --noconfirm \
            curl \
            git \
            zsh \
            base-devel \
            eza \
            neovim \
            xclip
    fi
    
    # Instalar Oh My Zsh se não existir
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo -e "\n${GREEN}🚀 Instalando Oh My Zsh...${NC}"
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi
    
    # Instalar plugins do ZSH
    echo -e "\n${GREEN}🔌 Instalando plugins ZSH...${NC}"
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions 2>/dev/null || true
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting 2>/dev/null || true
    
    # Instalar Starship
    if ! command -v starship &> /dev/null; then
        echo -e "\n${GREEN}⭐ Instalando Starship...${NC}"
        curl -sS https://starship.rs/install.sh | sh
    fi
fi

# Recarregar configurações
echo -e "\n${GREEN}🔄 Recarregando configurações...${NC}"
if [ -n "$ZSH_VERSION" ]; then
    source ~/.zshrc
elif [ -n "$BASH_VERSION" ]; then
    source ~/.bashrc
fi

echo -e "\n${GREEN}✨ Instalação concluída com sucesso!${NC}"
echo -e "${YELLOW}💡 Dica: Abra um novo terminal para aplicar todas as configurações${NC}"

# Verificar se precisa mudar o shell padrão para zsh
if [ "$SHELL" != "$(which zsh)" ]; then
    echo -e "\n${YELLOW}💡 Para definir ZSH como shell padrão, execute:${NC}"
    echo -e "   chsh -s $(which zsh)"
fi