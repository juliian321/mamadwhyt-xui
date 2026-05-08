#!/bin/bash

# ==========================================
# Project: MamadWhyt-UI (Premium Edition)
# Custom Rebranded & Cleaned Version
# ==========================================

red='\033[0;31m'
green='\033[0;32m'
blue='\033[0;34m'
yellow='\033[0;33m'
cyan='\033[0;36m'
plain='\033[0m'

BRAND="MamadWhyt-UI"
cur_dir=$(pwd)

xui_folder="${XUI_MAIN_FOLDER:=/usr/local/x-ui}"
xui_service="${XUI_SERVICE:=/etc/systemd/system}"

# check root
[[ $EUID -ne 0 ]] && echo -e "${red}Fatal error: ${plain} Please run this script with root privilege \n " && exit 1

# Check OS
if [[ -f /etc/os-release ]]; then
    source /etc/os-release
    release=$ID
elif [[ -f /usr/lib/os-release ]]; then
    source /usr/lib/os-release
    release=$ID
else
    echo "Failed to check the system OS, please contact MamadWhyt!" >&2
    exit 1
fi

echo -e "${cyan}System OS: $release${plain}"

arch() {
    case "$(uname -m)" in
        x86_64 | x64 | amd64) echo 'amd64' ;;
        i*86 | x86) echo '386' ;;
        armv8* | armv8 | arm64 | aarch64) echo 'arm64' ;;
        armv7* | armv7 | arm) echo 'armv7' ;;
        *) echo -e "${red}Unsupported CPU architecture! ${plain}" && rm -f install.sh && exit 1 ;;
    esac
}

install_base() {
    case "${release}" in
        ubuntu | debian | armbian)
            apt-get update && apt-get install -y -q cron curl tar tzdata socat ca-certificates openssl
            ;;
        *)
            apt-get update && apt-get install -y -q cron curl tar tzdata socat ca-certificates openssl
            ;;
    esac
}

# --- Personalization Engine ---
apply_branding() {
    echo -e "${blue}Applying $BRAND Branding to system files...${plain}"
    cd /usr/local/x-ui
    # Deep search and replace all old names with MamadWhyt
    find . -type f -exec sed -i "s/3x-ui/$BRAND/g" 2>/dev/null {} +
    find . -type f -exec sed -i "s/3X-UI/$BRAND/g" 2>/dev/null {} +
    find . -type f -exec sed -i "s/Sanaei/$BRAND/g" 2>/dev/null {} +
    find . -type f -exec sed -i "s/alireza0/MamadWhyt/g" 2>/dev/null {} +
}

install_x-ui() {
    echo -e "${cyan}Starting $BRAND Installation...${plain}"
    install_base
    
    # Download Core
    wget -N --no-check-certificate -O /usr/local/x-ui-linux-amd64.tar.gz https://github.com/mhzard/v2ray-sanaei/releases/download/v0.3.2/x-ui-linux-amd64.tar.gz
    cd /usr/local/
    tar zxvf x-ui-linux-amd64.tar.gz
    rm x-ui-linux-amd64.tar.gz -f
    
    cd x-ui
    chmod +x x-ui bin/xray-linux-amd64
    cp -f x-ui.service /etc/systemd/system/
    
    # Apply Branding before starting
    apply_branding
    
    systemctl daemon-reload
    systemctl enable x-ui
    systemctl restart x-ui
    
    echo -e "${green}$BRAND installed successfully!${plain}"
}

# --- Start Process ---
clear
echo -e "${blue}==================================================${plain}"
echo -e "${cyan}          WELCOME TO $BRAND INSTALLER            ${plain}"
echo -e "${blue}==================================================${plain}"

install_x-ui

# تنظیمات نهایی یوزر و پورت
/usr/local/x-ui/x-ui setting -username admin -password admin123 -port 2053

echo -e "${green}==================================================${plain}"
echo -e "${cyan}   $BRAND IS LIVE! (Anti-Chinese/Full Brand)${plain}"
echo -e "${blue}   URL: http://$(curl -s ipv4.icanhazip.com):2053 ${plain}"
echo -e "${green}==================================================${plain}"
