#!/bin/bash
# ILI9486 + XPT2046 Touch Display Driver Installer
# For Orange Pi Zero 2W (Allwinner H618)

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}╔════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  ILI9486 + Touch Display Driver Installer  ║${NC}"
echo -e "${GREEN}║     Orange Pi Zero 2W (H618)               ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════╝${NC}"

# Check root
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Please run as root (sudo ./install.sh)${NC}"
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OVERLAY_DIR="/boot/dtb/allwinner/overlay"
XORG_DIR="/etc/X11/xorg.conf.d"

# Check for required files
if [ ! -f "$SCRIPT_DIR/ili9486-waveshare.dts" ]; then
    echo -e "${RED}Error: ili9486-waveshare.dts not found${NC}"
    exit 1
fi

# Backup existing config
echo -e "${YELLOW}Backing up existing configuration...${NC}"
[ -f /boot/armbianEnv.txt ] && cp /boot/armbianEnv.txt /boot/armbianEnv.txt.backup.$(date +%Y%m%d%H%M%S)

# Compile overlay
echo -e "${YELLOW}Compiling device tree overlay...${NC}"
dtc -@ -I dts -O dtb -o "$OVERLAY_DIR/sun50i-h616-ili9486-waveshare.dtbo" "$SCRIPT_DIR/ili9486-waveshare.dts"

# Configure boot
echo -e "${YELLOW}Configuring boot parameters...${NC}"
if grep -q "^overlays=" /boot/armbianEnv.txt; then
    sed -i 's/^overlays=.*/overlays=ili9486-waveshare/' /boot/armbianEnv.txt
else
    echo "overlays=ili9486-waveshare" >> /boot/armbianEnv.txt
fi

# Add swiotlb if not present
if ! grep -q "extraargs=.*swiotlb" /boot/armbianEnv.txt; then
    if grep -q "^extraargs=" /boot/armbianEnv.txt; then
        sed -i 's/^extraargs=/extraargs=swiotlb=65536 /' /boot/armbianEnv.txt
    else
        echo "extraargs=swiotlb=65536" >> /boot/armbianEnv.txt
    fi
fi

# Install X11 configs
echo -e "${YELLOW}Installing X11 configuration...${NC}"
mkdir -p "$XORG_DIR"
cp "$SCRIPT_DIR/99-touch-calibration.conf" "$XORG_DIR/"

cat > "$XORG_DIR/99-fbdev.conf" << 'XORGEOF'
Section "Device"
    Identifier "FB Display"
    Driver "fbdev"
    Option "fbdev" "/dev/fb0"
EndSection
XORGEOF

echo -e "${GREEN}Installation complete!${NC}"
echo -e "${YELLOW}Please reboot to activate the display.${NC}"
echo ""
echo "Pinout reference:"
echo "  Display: SPI1 (MOSI=19, MISO=21, CLK=23, CS=24)"
echo "  Touch:   CS=26, IRQ=11 (PH2)"
echo "  Control: DC=18 (PH4), RST=22 (PI6)"
