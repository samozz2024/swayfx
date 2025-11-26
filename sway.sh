#!/bin/bash
set -e

echo "Updating system..."
sudo apt update && sudo apt upgrade -y

echo "Installing base build tools..."
sudo apt install -y \
    git curl wget unzip \
    build-essential meson ninja-build cmake \
    pkg-config gettext \
    libwayland-dev wayland-protocols \
    libxkbcommon-dev libpixman-1-dev \
    libxcb1-dev libxcb-composite0-dev libxcb-xfixes0-dev \
    libxcb-xinput-dev libxcb-shape0-dev libxcb-render0-dev \
    libdrm-dev libgbm-dev libinput-dev \
    libsystemd-dev libudev-dev libseat-dev \
    libevdev-dev libpam0g-dev \
    libpango1.0-dev libcairo2-dev \
    libgles2-mesa-dev libegl1-mesa-dev libvulkan-dev

echo "Installing runtime utilities..."
sudo apt install -y \
    waybar \
    swaybg \
    mako-notifier \
    grim slurp \
    wf-recorder \
    network-manager network-manager-gnome \
    xdg-desktop-portal xdg-desktop-portal-wlr \
    seatd \
    alacritty \
    pcmanfm

echo "Enabling seatd..."
sudo systemctl enable seatd
sudo systemctl start seatd

# --- Install wlroots (patched version required by SwayFX) ---
echo "Cloning wlroots..."
cd $HOME
git clone https://github.com/swaywm/wlroots.git --branch 0.17 --depth 1
cd wlroots
meson setup build/
ninja -C build
sudo ninja -C build install
sudo ldconfig

# --- Install SwayFX ---
echo "Cloning SwayFX..."
cd $HOME
git clone https://github.com/WillPower3309/swayfx.git --depth 1
cd swayfx
meson setup build/
ninja -C build
sudo ninja -C build install
sudo ldconfig

echo "Creating config dirs..."
mkdir -p ~/.config/swayfx
mkdir -p ~/.config/waybar
mkdir -p ~/.config/mako
mkdir -p ~/.config/alacritty

echo "DONE! Start SwayFX with: swayfx"
