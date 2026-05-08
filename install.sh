#!/bin/bash

# ==========================================
# Project: MamadWhyt-UI (Premium Edition)
# ==========================================

red='\033[0;31m'
green='\033[0;32m'
blue='\033[0;34m'
cyan='\033[0;36m'
plain='\033[0m'

BRAND="MamadWhyt-UI"

# Check Root
[[ $EUID -ne 0 ]] && echo -e "${red}Error: Please run with root!${plain}" && exit 1

echo -e "${blue}==================================================${plain}"
echo -e "${cyan}          WELCOME TO $BRAND INSTALLER            ${plain}"
echo -e "${blue}==================================================${plain}"

# Clean old versions
systemctl stop x-ui 2>/dev/null
rm -rf /usr/local/x-ui

# Download & Install
cd /usr/local/
# لینک جدید و مستقیم برای جلوگیری از خطای 404
wget -N --no-check-certificate https://github.com/MHSanaei/3x-ui/releases/download/v2.4.9/x-ui-linux-amd64.tar.gz

if [[ $? -ne 0 ]]; then
    echo -e "${red}Download failed! Checking alternative link...${plain}"
    wget -N --no-check-certificate https://github.com/MHSanaei/3x-ui/releases/latest/download/x-ui-linux-amd64.tar.gz
fi

tar zxvf x-ui-linux-amd64.tar.gz
rm x-ui-linux-amd64.tar.gz -f
cd x-ui
chmod +x x-ui bin/xray-linux-amd64

# --- Branding Surgery ---
echo -e "${blue}Applying $BRAND Branding...${plain}"
find . -type f -exec sed -i "s/3x-ui/$BRAND/g" 2>/dev/null {} +
find . -type f -exec sed -i "s/Sanaei/$BRAND/g" 2>/dev/null {} +

# Setup Service
cp -f x-ui.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable x-ui
systemctl restart x-ui

# Set Default Credentials
./x-ui setting -username admin -password admin123 -port 2053

echo -e "${green}==================================================${plain}"
echo -e "${cyan}   $BRAND INSTALLED SUCCESSFULLY!${plain}"
echo -e "${blue}   URL: http://$(curl -s ipv4.icanhazip.com):2053 ${plain}"
echo -e "${blue}   User: admin | Pass: admin123 ${plain}"
echo -e "${green}==================================================${plain}"
