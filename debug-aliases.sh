#!/bin/bash

echo "🔍 Diagnóstico de Aliases"
echo "========================="

# Cores
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# 1. Verificar shell atual
echo -e "\n${YELLOW}1. Shell atual:${NC}"
echo "SHELL: $SHELL"
echo "ZSH_VERSION: $ZSH_VERSION"

# 2. Verificar se .zshrc existe e contém a linha de aliases
echo -e "\n${YELLOW}2. Verificando .zshrc:${NC}"
if [ -f ~/.zshrc ]; then
    echo -e "${GREEN}✓ ~/.zshrc existe${NC}"
    if grep -q "source ~/.aliases" ~/.zshrc || grep -q ". ~/.aliases" ~/.zshrc; then
        echo -e "${GREEN}✓ .zshrc está configurado para carregar .aliases${NC}"
        grep "aliases" ~/.zshrc
    else
        echo -e "${RED}✗ .zshrc NÃO está carregando .aliases${NC}"
        echo -e "${YELLOW}Adicione esta linha ao seu .zshrc:${NC}"
        echo "[[ -f ~/.aliases ]] && source ~/.aliases"
    fi
else
    echo -e "${RED}✗ ~/.zshrc não existe${NC}"
fi

# 3. Verificar se .aliases existe
echo -e "\n${YELLOW}3. Verificando .aliases:${NC}"
if [ -f ~/.aliases ] || [ -L ~/.aliases ]; then
    echo -e "${GREEN}✓ ~/.aliases existe${NC}"
    
    # Verificar se é um symlink
    if [ -L ~/.aliases ]; then
        target=$(readlink ~/.aliases)
        echo "  É um symlink para: $target"
        
        if [ -f "$target" ]; then
            echo -e "  ${GREEN}✓ O arquivo alvo existe${NC}"
        else
            echo -e "  ${RED}✗ O arquivo alvo NÃO existe${NC}"
        fi
    fi
    
    # Mostrar primeiras linhas
    echo -e "\n  Primeiras 5 linhas do arquivo:"
    head -5 ~/.aliases | sed 's/^/  /'
else
    echo -e "${RED}✗ ~/.aliases não existe${NC}"
fi

# 4. Verificar diretório .dotfiles
echo -e "\n${YELLOW}4. Verificando estrutura .dotfiles:${NC}"
if [ -d ~/.dotfiles ]; then
    echo -e "${GREEN}✓ ~/.dotfiles existe${NC}"
    
    if [ -d ~/.dotfiles/terminal ]; then
        echo -e "${GREEN}✓ ~/.dotfiles/terminal existe${NC}"
        
        if [ -f ~/.dotfiles/terminal/.aliases ]; then
            echo -e "${GREEN}✓ ~/.dotfiles/terminal/.aliases existe${NC}"
        else
            echo -e "${RED}✗ ~/.dotfiles/terminal/.aliases NÃO existe${NC}"
        fi
    else
        echo -e "${RED}✗ ~/.dotfiles/terminal NÃO existe${NC}"
    fi
else
    echo -e "${RED}✗ ~/.dotfiles NÃO existe${NC}"
fi

# 5. Tentar carregar e testar
echo -e "\n${YELLOW}5. Testando carregamento:${NC}"
if [ -f ~/.aliases ]; then
    source ~/.aliases 2>/dev/null
    if alias | grep -q "\.\.="; then
        echo -e "${GREEN}✓ Aliases carregados com sucesso${NC}"
        echo "  Aliases de navegação encontrados:"
        alias | grep "^\.\." | sed 's/^/  /'
    else
        echo -e "${RED}✗ Aliases não foram carregados${NC}"
    fi
else
    echo -e "${RED}✗ Não é possível testar - .aliases não existe${NC}"
fi

# 6. Solução rápida
echo -e "\n${YELLOW}6. Solução Rápida:${NC}"
echo "Execute estes comandos para corrigir:"
echo ""
echo "# Criar o arquivo .aliases se não existir"
echo "mkdir -p ~/.dotfiles/terminal"
echo "curl -o ~/.dotfiles/terminal/.aliases https://raw.githubusercontent.com/gabrielroodriz/dotfiles/main/terminal/.aliases"
echo ""
echo "# Criar o symlink"
echo "ln -sf ~/.dotfiles/terminal/.aliases ~/.aliases"
echo ""
echo "# Recarregar o shell"
echo "source ~/.zshrc"
echo ""
echo "# Ou simplesmente feche e abra o terminal"