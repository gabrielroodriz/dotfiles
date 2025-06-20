# Oh My Zsh Configuration
export ZSH="$HOME/.oh-my-zsh"
export XDG_CONFIG_HOME=$HOME/.config

# Detectar sistema operacional
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    export OS_TYPE="linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    export OS_TYPE="macos"
fi

# Plugins
plugins=(
    git
    docker
    zsh-autosuggestions
    fzf
    zsh-syntax-highlighting
)

# Theme and Plugin Settings
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#663399,standout"

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# ===== PATH Configuration =====

# Base paths
export PATH="/usr/local/bin:$PATH"

# Homebrew (macOS) ou Linuxbrew
if [[ "$OS_TYPE" == "macos" ]]; then
    export PATH="/opt/homebrew/bin:$PATH"
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ "$OS_TYPE" == "linux" ]] && command -v brew &> /dev/null; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# Flutter - usar caminho relativo
if [ -d "$HOME/Development/flutter/bin" ]; then
    export PATH="$PATH:$HOME/Development/flutter/bin"
fi

# Android SDK - Cross-platform
if [[ "$OS_TYPE" == "macos" ]]; then
    export ANDROID_HOME="$HOME/Library/Android/sdk"
elif [[ "$OS_TYPE" == "linux" ]]; then
    export ANDROID_HOME="$HOME/Android/Sdk"
fi

if [ -d "$ANDROID_HOME" ]; then
    export PATH="$PATH:$ANDROID_HOME/platform-tools"
    export PATH="$PATH:$ANDROID_HOME/tools"
    export PATH="$PATH:$ANDROID_HOME/tools/bin"
    export PATH="$PATH:$ANDROID_HOME/emulator"
fi

# Java - Cross-platform
if [[ "$OS_TYPE" == "macos" ]]; then
    export JAVA_HOME=$(/usr/libexec/java_home 2>/dev/null)
elif [[ "$OS_TYPE" == "linux" ]]; then
    if [ -d "/usr/lib/jvm/java-11-openjdk-amd64" ]; then
        export JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"
    elif [ -d "/usr/lib/jvm/java-11-openjdk" ]; then
        export JAVA_HOME="/usr/lib/jvm/java-11-openjdk"
    fi
fi

# Go Configuration
if command -v go &> /dev/null; then
    export GOPATH=$(go env GOPATH)
    export PATH="$PATH:$GOPATH/bin"
fi

# PostgreSQL e MySQL (se instalados via package manager)
if [[ "$OS_TYPE" == "macos" ]]; then
    [ -d "/opt/homebrew/opt/libpq/bin" ] && export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
    [ -d "/opt/homebrew/opt/mysql@5.7/bin" ] && export PATH="/opt/homebrew/opt/mysql@5.7/bin:$PATH"
fi

# Neovim
if [ -d "$HOME/tools/nvim-macos/bin" ]; then
    export PATH="$HOME/tools/nvim-macos/bin:$PATH"
elif [ -d "$HOME/tools/nvim-linux64/bin" ]; then
    export PATH="$HOME/tools/nvim-linux64/bin:$PATH"
fi

# LLVM (se instalado)
if [[ "$OS_TYPE" == "macos" ]] && [ -d "/opt/homebrew/opt/llvm/bin" ]; then
    export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
    export LDFLAGS="-L/opt/homebrew/opt/llvm/lib"
    export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"
fi

# NVM (Node Version Manager) - Cross-platform
export NVM_DIR="$HOME/.nvm"

# macOS com Homebrew
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# Linux instalação padrão
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# PNPM
export PNPM_HOME="$HOME/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# SST
[ -d "$HOME/.sst/bin" ] && export PATH="$HOME/.sst/bin:$PATH"

# Sentry
[ -d "$HOME/.local/share/sentry-devenv/bin" ] && export PATH="$HOME/.local/share/sentry-devenv/bin:$PATH"

# Starship Prompt
if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
fi

# ===== Functions =====

# Find and kill process on port
findandkill() {
    local port=${1:-3000}
    if [[ "$OS_TYPE" == "linux" ]]; then
        local pid=$(lsof -t -i:$port)
        if [ -n "$pid" ]; then
            kill -9 $pid
            echo "Killed process on port $port"
        else
            echo "No process found on port $port"
        fi
    else
        lsof -ti:$port | xargs kill -9 2>/dev/null && echo "Killed process on port $port" || echo "No process found on port $port"
    fi
}

# Load aliases
[[ -f ~/.aliases ]] && source ~/.aliases

# ===== OS Specific Settings =====

if [[ "$OS_TYPE" == "macos" ]]; then
    # macOS keyboard settings
    # Descomente se quiser aplicar no macOS
    # defaults write NSGlobalDomain KeyRepeat -int 1
    # defaults write NSGlobalDomain InitialKeyRepeat -int 15
    # defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
elif [[ "$OS_TYPE" == "linux" ]]; then
    # Linux specific settings
    
    # Keyboard repeat rate (para X11)
    if command -v xset &> /dev/null && [ -n "$DISPLAY" ]; then
        xset r rate 200 30
    fi
    
    # Para Wayland/GNOME
    if command -v gsettings &> /dev/null; then
        gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 30
        gsettings set org.gnome.desktop.peripherals.keyboard delay 200
    fi
fi

# Terraform Completion (se instalado)
if command -v terraform &> /dev/null; then
    autoload -U +X bashcompinit && bashcompinit
    complete -o nospace -C $(which terraform) terraform
fi

# ===== Development Environment Variables =====

# React Native
export REACT_NATIVE_PACKAGER_HOSTNAME=$(hostname -I | awk '{print $1}' 2>/dev/null || echo "localhost")

# Expo
export EXPO_DEVTOOLS_LISTEN_ADDRESS="0.0.0.0"

# Editor
export EDITOR="nvim"
export VISUAL="nvim"

# FZF
if command -v fzf &> /dev/null; then
    export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"
fi

# ===== Custom Aliases/Functions for Development =====

# React Native Metro config helper
rn-metro-config() {
    if [[ "$OS_TYPE" == "linux" ]]; then
        echo "Metro temp dir: /tmp"
        echo "Clear with: rm -rf /tmp/metro-* /tmp/haste-*"
    else
        echo "Metro temp dir: $TMPDIR"
        echo "Clear with: rm -rf $TMPDIR/metro-* $TMPDIR/haste-*"
    fi
}

# Show current development environment
dev-info() {
    echo "🖥️  OS: $OS_TYPE"
    echo "🏠 Home: $HOME"
    [ -n "$JAVA_HOME" ] && echo "☕ Java: $JAVA_HOME"
    [ -n "$ANDROID_HOME" ] && echo "🤖 Android SDK: $ANDROID_HOME"
    command -v node &> /dev/null && echo "📦 Node: $(node -v)"
    command -v npm &> /dev/null && echo "📦 NPM: $(npm -v)"
    command -v yarn &> /dev/null && echo "📦 Yarn: $(yarn -v)"
    command -v pnpm &> /dev/null && echo "📦 PNPM: $(pnpm -v)"
    command -v expo &> /dev/null && echo "📱 Expo: $(expo --version)"
    command -v flutter &> /dev/null && echo "🦋 Flutter: $(flutter --version | head -n 1)"
}

# Final message
if [ -n "$FIRST_RUN" ]; then
    echo "✨ Zsh configured successfully!"
    echo "Run 'dev-info' to see your development environment"
fi