#!/bin/bash

sudo apt update
sudo apt-add-repository ppa:ricotz/docky -y
sudo apt install -y vim plank lxappearance neofetch git

#download pling icon, plank, gtk theme & cursor
mkdir ~/.themes
mkdir ~/.icons

cd ~/Downloads
wget "https://github.com/forsyth47/xfce-liveboot-rice/raw/refs/heads/main/assets/Cursor-macOS.tar.xz"
wget "https://github.com/forsyth47/xfce-liveboot-rice/raw/refs/heads/main/assets/GTKTheme-WhiteSur-Dark.tar.xz"
wget "https://github.com/forsyth47/xfce-liveboot-rice/raw/refs/heads/main/assets/Icons-WhiteSur-green.tar.xz"
wget "https://github.com/forsyth47/xfce-liveboot-rice/raw/refs/heads/main/assets/Plank-mcOS-BS-iMacM1-THEME-PACK.zip"

#cp pling to folders
mkdir Cursor-macOS && tar -xJvf Cursor-macOS.tar.xz -C Cursor-macOS
mkdir GTKTheme-WhiteSur-Dark && tar -xJvf "GTKTheme-WhiteSur-Dark.tar.xz" -C GTKTheme-WhiteSur-Dark
mkdir Icons-WhiteSur-green && tar -xJvf "Icons-WhiteSur-green.tar.xz" -C Icons-WhiteSur-green
unzip "Plank-mcOS-BS-iMacM1-THEME-PACK.zip" -d "Plank-mcOS-BS-iMacM1-THEME-PACK"

cp -r ./Cursor-macOS/* ~/.icons #cursor
cp -r ./GTKTheme-WhiteSur-Dark/* ~/.themes #gtk
cp -r ./Icons-WhiteSur-green/* ~/.icons #icon
mkdir -p ~/.local/share/plank/themes
cp ./Plank-mcOS-BS-iMacM1-THEME-PACK/* ~/.local/share/plank/themes #plank

# Define paths and themes
THEME_NAME="WhiteSur-Dark"
ICON_THEME="WhiteSur-green"
CURSOR_THEME="macOS"
CURSOR_SIZE=24
BUTTON_LAYOUT="CMH|"
PLANK_THEME="mcOS-BS-iMacM1-Black"

# Apply GTK Theme
echo "Setting GTK Theme..."
xfconf-query -c xsettings -p /Net/ThemeName -s "$THEME_NAME"

# Apply Icon Theme
echo "Setting Icon Theme..."
xfconf-query -c xsettings -p /Net/IconThemeName -s "$ICON_THEME"

# Apply Cursor Theme and Size
echo "Setting Cursor Theme and Size..."
xfconf-query -c xsettings -p /Gtk/CursorThemeName -s "$CURSOR_THEME"
xfconf-query -c xsettings -p /Gtk/CursorThemeSize -s "$CURSOR_SIZE"

# Apply XFWM4 Theme
echo "Setting XFWM4 Theme..."
xfconf-query -c xfwm4 -p /general/theme -s "$THEME_NAME"

# Change Button Layout
echo "Changing Button Layout to macOS style..."
xfconf-query -c xfwm4 -p /general/button_layout -s "$BUTTON_LAYOUT"

# Set Plank Theme
echo "Setting Plank theme to $PLANK_THEME..."
mkdir -p ~/.config/plank/dock1/
echo "[PlankDockPreferences]" > ~/.config/plank/dock1/settings
echo "Theme=$PLANK_THEME" >> ~/.config/plank/dock1/settings

killall plank
plank &

# Download and set the wallpaper
WALLPAPER_URL="https://w.wallhaven.cc/full/vq/wallhaven-vq76dp.jpg"
WALLPAPER_PATH="$HOME/Pictures/Wallpapers/wallhaven-vq76dp.jpg"

echo "Downloading wallpaper..."
wget -O "$WALLPAPER_PATH" "$WALLPAPER_URL"

echo "Setting wallpaper..."
for workspace in $(xfconf-query -c xfce4-desktop -p /backdrop -l | grep "screen0/monitor0/workspace"); do
    xfconf-query -c xfce4-desktop -p "$workspace/last-image" -s "$WALLPAPER_PATH"
    xfconf-query -c xfce4-desktop -p "$workspace/image-path" -s "$WALLPAPER_PATH"
    xfconf-query -c xfce4-desktop -p "$workspace/image-style" -s 5  # 5 = Zoomed (adjust as needed)
done

echo "Configuration applied successfully!"
sleep 3  # Wait 3 seconds before logging out
xfce4-session-logout --logout
