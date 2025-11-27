#!/bin/bash

set -e

echo "=== Updating system… ==="
sudo apt update
sudo apt upgrade -y

echo "=== Installing required dependencies for SwayFX… ==="

sudo apt install -y \
meson \
ninja-build \
cmake \
pkg-config \
build-essential \
git \
wayland-protocols \
libwayland-dev \
libxkbcommon-dev \
libinput-dev \
libudev-dev \
libpixman-1-dev \
libseat-dev \
libpam0g-dev \
libevdev-dev \
libdrm-dev \
libegl1-mesa-dev \
libgles2-mesa-dev \
libvulkan-dev \
libgbm-dev \
libxcb1-dev \
libxcb-ewmh-dev \
libxcb-composite0-dev \
libxcb-present-dev \
libxcb-render0-dev \
libxcb-xfixes0-dev \
libxcb-drm0-dev \
libxcb-icccm4-dev \
libxcb-util0-dev \
hwdata

echo "=== Dependencies installed successfully! ==="
