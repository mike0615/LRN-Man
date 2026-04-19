#!/usr/bin/env bash
# ============================================================
# LRN Man: Defender of the Network
# Linux Installer
# Created by Mike Anderson
# ============================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

# Default install location
INSTALL_DIR="$HOME/LRN-Man"

echo ""
echo " ====================================================="
echo "  LRN MAN: DEFENDER OF THE NETWORK"
echo "  Linux Installer — Created by Mike Anderson"
echo " ====================================================="
echo ""
echo " Default install location: $INSTALL_DIR"
echo ""
read -r -p " Press ENTER to accept, or type a custom path: " CUSTOM_PATH
[ -n "$CUSTOM_PATH" ] && INSTALL_DIR="$CUSTOM_PATH"

echo ""
echo " Installing to: $INSTALL_DIR"

# Create directories
mkdir -p "$INSTALL_DIR/issues"
mkdir -p "$INSTALL_DIR/art"

# Copy files
echo " Copying comic files..."
cp -r "$SRC_DIR/issues/"* "$INSTALL_DIR/issues/"
echo " Copying artwork..."
cp -r "$SRC_DIR/art/"* "$INSTALL_DIR/art/"

# Create launcher script
cat > "$INSTALL_DIR/lrn-man" << 'LAUNCHER'
#!/usr/bin/env bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INDEX="$DIR/issues/index.html"
if command -v xdg-open &>/dev/null; then
    xdg-open "$INDEX"
elif command -v firefox &>/dev/null; then
    firefox "$INDEX"
elif command -v google-chrome &>/dev/null; then
    google-chrome "$INDEX"
elif command -v chromium-browser &>/dev/null; then
    chromium-browser "$INDEX"
else
    echo "Open this file in your browser: $INDEX"
fi
LAUNCHER
chmod +x "$INSTALL_DIR/lrn-man"

# Symlink to ~/bin if it exists
if [ -d "$HOME/bin" ]; then
    ln -sf "$INSTALL_DIR/lrn-man" "$HOME/bin/lrn-man"
    echo " Launcher linked: ~/bin/lrn-man"
fi

# Create .desktop file (GNOME/KDE/etc. app menu)
DESKTOP_DIR="$HOME/.local/share/applications"
mkdir -p "$DESKTOP_DIR"

# Find icon
ICON="$INSTALL_DIR/art/LRN Man Logo.png"
[ ! -f "$ICON" ] && ICON="application-x-executable"

cat > "$DESKTOP_DIR/lrn-man.desktop" << DESKTOP
[Desktop Entry]
Version=1.0
Type=Application
Name=LRN Man: Defender of the Network
GenericName=Comic Series
Comment=LRN Man cybersecurity comic series by Mike Anderson
Exec=bash "$INSTALL_DIR/lrn-man"
Icon=$ICON
Terminal=false
Categories=Education;Comics;
Keywords=lrnman;comic;cybersecurity;network;
StartupNotify=true
DESKTOP

chmod +x "$DESKTOP_DIR/lrn-man.desktop"

# Refresh app database if available
if command -v update-desktop-database &>/dev/null; then
    update-desktop-database "$DESKTOP_DIR" 2>/dev/null || true
fi

# Create uninstaller
cat > "$INSTALL_DIR/uninstall.sh" << UNINSTALL
#!/usr/bin/env bash
echo "Uninstalling LRN Man: Defender of the Network..."
read -r -p "Are you sure? This deletes all files. [y/N]: " CONFIRM
if [[ "\$CONFIRM" =~ ^[Yy]\$ ]]; then
    rm -f "$HOME/.local/share/applications/lrn-man.desktop"
    rm -f "$HOME/bin/lrn-man"
    rm -rf "$INSTALL_DIR"
    echo "Uninstall complete."
else
    echo "Uninstall cancelled."
fi
UNINSTALL
chmod +x "$INSTALL_DIR/uninstall.sh"

echo ""
echo " ====================================================="
echo "  Installation Complete!"
echo " ====================================================="
echo ""
echo "  Location  : $INSTALL_DIR"
echo "  App Menu  : LRN Man: Defender of the Network"
echo "  Command   : lrn-man  (if ~/bin is in your PATH)"
echo "  Uninstall : $INSTALL_DIR/uninstall.sh"
echo ""
echo " Opening LRN Man now..."
echo ""

bash "$INSTALL_DIR/lrn-man"
