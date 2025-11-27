#!/bin/bash
set -euo pipefail

echo "=== Step 1: Update system ==="
sudo apt update
sudo apt upgrade -y
sudo apt install -y curl git sudo

echo "=== Step 2: Install Nix ==="
sh <(curl -L https://nixos.org/nix/install) --daemon

echo "=== Step 3: Source Nix profile ==="
. /etc/profile.d/nix.sh

echo "=== Step 4: Enable experimental features (nix-command + flakes) ==="
# This enables nix-command and flakes for current session
export NIX_CONFIG="experimental-features = nix-command flakes"

# Optional: also enable permanently
if ! grep -q "experimental-features" /etc/nix/nix.conf 2>/dev/null; then
  echo "experimental-features = nix-command flakes" | sudo tee -a /etc/nix/nix.conf
fi

echo "=== Step 5: Add user to nixbld group ==="
sudo usermod -aG nixbld $USER

echo "=== Step 6: Clone SwayFX repo with submodules ==="
mkdir -p ~/build
cd ~/build

if [ -d swayfx ]; then
  echo "swayfx directory exists. Pulling latest and updating submodules..."
  cd swayfx
  git pull --rebase
  git submodule update --init --recursive
else
  git clone --recursive https://github.com/WillPower3309/swayfx.git
  cd swayfx
fi

echo "=== Step 7: Enter Nix development shell ==="
echo "This may take a few minutes as Nix builds the environment..."
nix develop

echo "=== Step 8: Build SwayFX ==="
nix build

echo "=== Step 9: Run SwayFX ==="
echo "You can now run:"
echo "  ./result/bin/sway"
echo ""
echo "Note: On TTY, ensure your user is in the video/input/render groups if you get seat/DRM errors:"
echo "  sudo usermod -aG video,input,render \$USER"
