#!/bin/bash
set -euo pipefail

echo "== update =="
sudo apt update
sudo apt upgrade -y

echo "== Install build deps =="
sudo apt install -y --no-install-recommends \
  build-essential git wget curl ca-certificates \
  meson ninja-build cmake pkg-config git \
  pkgconf \
  python3 python3-pip python3-setuptools \
  libwayland-dev wayland-protocols \
  libxkbcommon-dev libinput-dev libudev-dev \
  libpixman-1-dev libseat-dev libpam0g-dev libevdev-dev \
  libdrm-dev libgbm-dev libegl1-mesa-dev libgles2-mesa-dev \
  libvulkan-dev mesa-vulkan-drivers \
  libpango1.0-dev libcairo2-dev libjson-c-dev \
  libxcb1-dev libxcb-ewmh-dev libxcb-composite0-dev \
  libxcb-present-dev libxcb-render0-dev libxcb-xfixes0-dev \
  libxcb-drm0-dev libxcb-icccm4-dev libxcb-util0-dev \
  hwdata

# optional helpful packages
sudo apt install -y gettext jq

echo "== Create build dir =="
mkdir -p ~/build
cd ~/build

echo "== Clone SwayFX repo =="
if [ -d swayfx ]; then
  echo "swayfx dir exists; pulling latest"
  cd swayfx
  git pull --rebase
else
  git clone https://github.com/WillPower3309/swayfx.git
  cd swayfx
fi

echo "== Configure meson build =="
meson setup build --buildtype=release -Dprefix=/usr/local || meson setup --reconfigure build

echo "== Build (this may take a while) =="
ninja -C build

echo "== Install =="
sudo ninja -C build install

echo "== Make SUID on sway (if necessary for seat privileges) =="
if [ -f /usr/local/bin/sway ]; then
  sudo chmod a+s /usr/local/bin/sway || true
fi

echo "== Done =="
echo "Run 'sway' to start. Copy a config from /etc/sway/ or create ~/.config/sway/config"
