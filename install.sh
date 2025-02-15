DOTFILES_DIR="$HOME/.dotfiles"

mkdir -p "$DOTFILES_DIR"/{git,npm,vscode,terminal,expo}

# Git configuration
ln -sf "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"
ln -sf "$DOTFILES_DIR/git/.gitignore_global" "$HOME/.gitignore_global"

# NPM configuration
ln -sf "$DOTFILES_DIR/npm/.npmrc" "$HOME/.npmrc"

# VS Code configuration
VSCODE_CONFIG_DIR="$HOME/Library/Application Suporte/Code/User"
mkdir -p "$VSCODE_CONFIG_DIR"
ln -sf "$DOTFILES_DIR/vscode/settings.json" "$VSCODE_CONFIG_DIR/settings.json"
ln -sf "$DOTFILES_DIR/vscode/extensions.json" "$VSCODE_CONFIG_DIR/extensions.json"

# Terminal configuration
ln -sf "$DOTFILES_DIR/terminal/.zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES_DIR/terminal/.aliases" "$HOME/.aliases"

# Expo configuration
ln -sf "$DOTFILES_DIR/expo/.expo-shared" "$HOME/.expo-shared"

echo "Success instalations"
