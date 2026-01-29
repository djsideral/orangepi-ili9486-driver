#!/bin/bash
# ILI9486 + Touch Display Driver Uninstaller

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}Uninstalling ILI9486 + Touch display driver...${NC}"

if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Please run as root (sudo ./uninstall.sh)${NC}"
    exit 1
fi

# Remove overlay
rm -f /boot/dtb/allwinner/overlay/sun50i-h616-ili9486-waveshare.dtbo

# Remove from boot config
sed -i '/^overlays=ili9486-waveshare/d' /boot/armbianEnv.txt
sed -i 's/swiotlb=65536 //' /boot/armbianEnv.txt

# Remove X11 configs
rm -f /etc/X11/xorg.conf.d/99-fbdev.conf
rm -f /etc/X11/xorg.conf.d/99-touch-calibration.conf

echo -e "${GREEN}Uninstall complete. Reboot to restore default display.${NC}"
