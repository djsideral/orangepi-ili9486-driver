# ILI9486 3.5" TFT Display + XPT2046 Touch Driver
## Orange Pi Zero 2W (Allwinner H618)

### Features
- 480x320 resolution, 90° rotation (landscape)
- XPT2046 resistive touchscreen support
- Pre-calibrated touch axes

### Pin Connections

| Pin | Function      | GPIO  | Description          |
|-----|---------------|-------|----------------------|
| 17  | 3.3V          | -     | Power                |
| 19  | LCD_SI/TP_SI  | PH7   | SPI1 MOSI (shared)   |
| 21  | TP_SO         | PH6   | SPI1 MISO (touch)    |
| 23  | LCD_SCK/TP_SCK| PH5   | SPI1 CLK (shared)    |
| 24  | LCD_CS        | PH8   | Display chip select  |
| 26  | TP_CS         | PH9   | Touch chip select    |
| 18  | LCD_RS/DC     | PH4   | Data/Command         |
| 22  | RST           | PI6   | Reset                |
| 11  | TP_IRQ        | PH2   | Touch interrupt      |
| 6   | GND           | -     | Ground               |

### Installation
```bash
sudo ./install.sh
sudo reboot
```

### Uninstallation
```bash
sudo ./uninstall.sh
sudo reboot
```

### Compatibility
- Armbian Bookworm (tested)
- Orange Pi Zero 2W with H618 SoC
- Waveshare-style 3.5" ILI9486 displays with XPT2046 touch

### Troubleshooting
- No display: Check SPI connections, verify `dmesg | grep ili`
- No touch: Check `dmesg | grep ads7846`, verify IRQ pin 11 connection
- Wrong touch axes: Edit transformation matrix in 99-touch-calibration.conf
