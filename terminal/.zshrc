# Oh My Zsh Configuration
export ZSH="$HOME/.oh-my-zsh"
export XDG_CONFIG_HOME=$HOME/.config

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

# Path Configuration (Consolidated)
export PATH="/opt/homebrew/bin:$PATH"                                 # Homebrew
export PATH="$PATH:/Users/gabrielsouza/Development/flutter/bin"      # Flutter
export PATH="$PATH:/Users/gabrielsouza/Library/Android/sdk/platform-tools"  # Android
export PATH="$PATH:/Users/gabrielsouza/Library/Android/sdk/tools"
export PATH="$PATH:/Users/gabrielsouza/Library/Android/sdk/tools/bin"
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"                      # PostgreSQL
export PATH="/opt/homebrew/opt/mysql@5.7/bin:$PATH"                  # MySQL
export PATH="~/tools/nvim-macos/bin:$PATH"                          # Neovim
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"                      # LLVM

# Go Configuration
export GOPATH=$(go env GOPATH)
export PATH="$PATH:$GOPATH/bin"
export PATH="~/go/bin:$PATH"

# Compiler Flags
export CPPFLAGS="-I/opt/homebrew/opt/openjdk/include -I/opt/homebrew/opt/llvm/include"
export LDFLAGS="-L/opt/homebrew/opt/llvm/lib"

# NVM (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# PNPM
export PNPM_HOME="$HOME/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# SST
export PATH="/Users/gabrielsouza/.sst/bin:$PATH"

# Sentry
export PATH="$HOME/.local/share/sentry-devenv/bin:$PATH"

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Starship Prompt
eval "$(starship init zsh)"

# Functions
findandkill() {
    $(lsof -ti:3000 | xargs kill)
}

# Load aliases
[[ -f ~/.aliases ]] && source ~/.aliases

# Keyboard Settings
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Terraform Completion
autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/terraform terraform
