#!/bin/bash
# Adiciona a diretiva para parar o script em caso de erro
set -e

# ===================================================================
# GHOOOOST - Instalador v16.0 (KALI LINUX STYLE)
#
# Versão: 16.0 (Kali Edition) - Visual profissional, prompt de duas
#         linhas e cores de alto contraste (Azul/Vermelho).
# ===================================================================

# ===== CORES KALI STYLE =====
BOLD_BLUE='\033[1;34m'
BOLD_RED='\033[1;31m'
WHITE='\033[1;37m'
GREY='\033[0;37m'
GREEN='\033[1;32m'
NC='\033[0m' # No Color

# ===== SÍMBOLOS =====
TICK="${GREEN}[✔]${NC}"
INFO="${BOLD_BLUE}[*]${NC}"
CROSS="${BOLD_RED}[✖]${NC}"
KALI_PROMPT_HEAD="${BOLD_BLUE}┌──${NC}"
KALI_PROMPT_TAIL="${BOLD_BLUE}└─${NC}"

# ===== BANNER =====
print_banner() {
    clear
    echo -e "${BOLD_BLUE}┌───────────────────────────────────────────────────┐${NC}"
    echo -e "${BOLD_BLUE}│${NC}      ${WHITE}Instalador de Ambiente - KALI EDITION v16.0${NC}  ${BOLD_BLUE}│${NC}"
    echo -e "${BOLD_BLUE}└───────────────────────────────────────────────────┘${NC}\n"
}

# ===== FUNÇÃO PRINCIPAL =====
main() {
    print_banner

    # --- 1. VERIFICANDO E INSTALANDO DEPENDÊNCIAS ---
    echo -e "${INFO} Atualizando repositórios e verificando dependências..."
    apt update -y > /dev/null 2>&1
    
    DEPENDENCIAS_PKG="python git nano ruby figlet toilet"
    for pkg_name in $DEPENDENCIAS_PKG; do
        if ! command -v "$pkg_name" &> /dev/null; then
            echo -e "${INFO} Instalando ${WHITE}$pkg_name${NC}..."
            apt install -y "$pkg_name" > /dev/null 2>&1
            echo -e "    ${TICK} $pkg_name instalado."
        else
            echo -e "    ${TICK} ${GREY}$pkg_name já instalado.${NC}"
        fi
    done
    
    # Lolcat é opcional no estilo Kali, mas mantivemos para compatibilidade se quiser
    if ! gem list -i lolcat &> /dev/null; then
        echo -e "${INFO} Instalando lolcat..."
        gem install lolcat > /dev/null 2>&1
    fi
    echo -e "${TICK} Dependências verificadas.\n"

    # --- 2. PERSONALIZAÇÃO ---
    echo -e "${BOLD_BLUE}┌──(${NC}${WHITE}CONFIGURAÇÃO${NC}${BOLD_BLUE})-[Personalizar]${NC}"
    echo -e "${BOLD_BLUE}│${NC}"
    
    # Pergunta pelo nome do banner
    echo -ne "${BOLD_BLUE}└─${NC}${BOLD_RED} Nome do Banner${NC} [Enter p/ 'GHOOOOST']: "
    read CUSTOM_BANNER_NAME
    if [ -z "$CUSTOM_BANNER_NAME" ]; then
        CUSTOM_BANNER_NAME="GHOOOOST"
    fi

    # Pergunta pela mensagem de boas-vindas
    echo -ne "${BOLD_BLUE}└─${NC}${BOLD_RED} Frase de entrada${NC} [Enter p/ Padrão]: "
    read CUSTOM_WELCOME_MESSAGE
    if [ -z "$CUSTOM_WELCOME_MESSAGE" ]; then
        CUSTOM_WELCOME_MESSAGE="System Ready."
    fi

    # Pergunta pelo nome de usuário para o prompt (ex: root@kali)
    echo -ne "${BOLD_BLUE}└─${NC}${BOLD_RED} Usuário Fake do Prompt${NC} [ex: root]: "
    read PROMPT_USER
    if [ -z "$PROMPT_USER" ]; then
        PROMPT_USER="ghost"
    fi

    echo -e "\n${TICK} Configurações salvas na memória.\n"

    # --- 3. PRÉ-RENDERIZAR BANNER ---
    BANNER_FILE="$HOME/.ghooost_banner.txt"
    MENU_HEADER_FILE="$HOME/.ghooost_menu_header.txt"
    
    echo -e "${INFO} Renderizando assets visuais..."
    # Estilo Kali prefere cor sólida, mas se quiser lolcat, descomente a linha do lolcat
    # Usando 'standard' ou 'rectangles' fica mais técnico
    figlet -f standard "$CUSTOM_BANNER_NAME" > "$BANNER_FILE" 
    
    # Se quiser forçar a cor azul no arquivo de texto:
    sed -i 's/^/\x1b[1;34m/' "$BANNER_FILE"
    sed -i 's/$/\x1b[0m/' "$BANNER_FILE"

    figlet -f small "MENU" > "$MENU_HEADER_FILE"
    sed -i 's/^/\x1b[1;31m/' "$MENU_HEADER_FILE" # Vermelho para o menu
    sed -i 's/$/\x1b[0m/' "$MENU_HEADER_FILE"

    # --- 4. ARMAZENAMENTO ---
    echo -e "${INFO} Configurando armazenamento..."
    if [ ! -d "/storage/emulated/0" ]; then
        termux-setup-storage
        echo -e "${BOLD_RED}[!] Por favor, aceite a permissão de armazenamento no popup.${NC}"
        read -p "Pressione Enter após aceitar..."
    fi
    
    GHOST_DIR="/storage/emulated/0/scriptdoghost"
    mkdir -p "$GHOST_DIR/python/webchk"
    mkdir -p "$GHOST_DIR/repos"
    echo -e "${TICK} Diretórios criados em: ${GREY}$GHOST_DIR${NC}\n"

    # --- 5. CONFIGURAR .bashrc COM ESTILO KALI ---
    BASHRC_FILE="$HOME/.bashrc"
    echo -e "${INFO} Injetando configurações Kali Style no ${WHITE}.bashrc${NC}..."

    touch "$BASHRC_FILE"
    # Remove configurações antigas do script
    sed -i '/# GHOOOOST CONFIG START/,/# GHOOOOST CONFIG END/d' "$BASHRC_FILE"
        
    cat <<EOF >> "$BASHRC_FILE"

# GHOOOOST CONFIG START
# ==================================
# PROMPT ESTILO KALI LINUX
# ==================================
# Define o prompt: ┌──(user㉿termux)-[path]
#                  └─$
PS1='\[\033[1;34m\]┌──(\[\033[1;31m\]$PROMPT_USER㉿termux\[\033[1;34m\])-[\[\033[0;37m\]\w\[\033[1;34m\]]\n└─\[\033[1;31m\]$\[\033[0m\] '

# ==================================
# BOAS-VINDAS
# ==================================
BANNER_FILE="\$HOME/.ghooost_banner.txt"
if [ -f "\$BANNER_FILE" ]; then
    clear
    cat "\$BANNER_FILE"
    echo -e "\n\033[1;37m$CUSTOM_WELCOME_MESSAGE\033[0m"
    echo -e "\033[1;34m──────────────────────────────────────────────────\033[0m"
fi

# ==================================
# SISTEMA DE SEGURANÇA (ALIAS LOCK)
# ==================================
export GHOST_ALIASES_ENABLED=0

_ghost_check_unlocked() {
    if [[ "\$GHOST_ALIASES_ENABLED" != "1" ]]; then
        echo -e "\033[1;31m[✖] Acesso negado. Execute 'menu' para autenticar ferramentas.\033[0m"
        return 1
    fi
    return 0
}

# ==================================
# COMANDOS
# ==================================
gopy() { if _ghost_check_unlocked; then cd /storage/emulated/0/scriptdoghost/python/; fi; }
gorepos() { if _ghost_check_unlocked; then cd /storage/emulated/0/scriptdoghost/repos/; fi; }
gochk() { if _ghost_check_unlocked; then cd /storage/emulated/0/scriptdoghost/python/webchk/; fi; }
tvx() { if _ghost_check_unlocked; then cd /storage/emulated/0/scriptdoghost/repos/matrix/; fi; }
chkn() { if _ghost_check_unlocked; then nano \$HOME/.bashrc; fi; }

alias rr='source \$HOME/.bashrc'
alias bb='cd ~'
alias xx='exit'

# ==================================
# MENU STYLE KALI
# ==================================
menu() {
    clear
    MENU_HEADER_FILE="\$HOME/.ghooost_menu_header.txt"
    if [ -f "\$MENU_HEADER_FILE" ]; then
        cat "\$MENU_HEADER_FILE"
    fi
    
    echo -e "\033[1;34m┌──(\033[1;37mFerramentas\033[1;34m)\033[0m"
    echo -e "\033[1;34m│\033[0m"
    echo -e "\033[1;34m├──\033[1;31m gopy    \033[0m:: Scripts Python"
    echo -e "\033[1;34m├──\033[1;31m gorepos \033[0m:: Repositórios Git"
    echo -e "\033[1;34m├──\033[1;31m gochk   \033[0m:: Web Checker"
    echo -e "\033[1;34m├──\033[1;31m tvx     \033[0m:: StreamX TV"
    echo -e "\033[1;34m│\033[0m"
    echo -e "\033[1;34m├──\033[1;32m chkn    \033[0m:: Configurar (.bashrc)"
    echo -e "\033[1;34m├──\033[1;32m rr      \033[0m:: Reload System"
    echo -e "\033[1;34m└──\033[1;32m xx      \033[0m:: Sair"
    echo ""

    if [[ "\$GHOST_ALIASES_ENABLED" != "1" ]]; then
        export GHOST_ALIASES_ENABLED=1
        echo -e "\033[1;32m[✔] Ambiente desbloqueado. Comandos ativos.\033[0m"
    fi
}

export PATH=\$HOME/.local/bin:\$PATH
# GHOOOOST CONFIG END
EOF

    echo -e "${TICK} Configuração aplicada."

    # --- MENSAGEM FINAL ---
    echo -e "\n${BOLD_BLUE}┌───────────────────────────────────────────────────┐${NC}"
    echo -e "${BOLD_BLUE}│${NC}             ${GREEN}INSTALAÇÃO FINALIZADA${NC}                 ${BOLD_BLUE}│${NC}"
    echo -e "${BOLD_BLUE}└───────────────────────────────────────────────────┘${NC}"
    echo -e "${WHITE}Reinicie o Termux para carregar o novo Prompt Kali.${NC}\n"
}

main