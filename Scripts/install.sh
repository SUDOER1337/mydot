#!/bin/bash

set -e  # Exit if any command fails

# ─── CONFIG ─────────────────────────────────────────
PACMAN_PACKAGES=(
  git
  neovim
  zsh
  fish
  waybar
  kitty
  btop
  rofi
  swww
  swaync
  hyprland
  hyprpaper
  hyprlock
  grimblast
  wl-clipboard
)

AUR_HELPERS=("paru" "yay")
AUR_PACKAGES=(
  floorp-bin
  thorium-browser
  nwg-look
  papirus-icon-theme
)

CONFIG_DIRS=(
  nvim
  kitty
  waybar
  hypr
  rofi
  swaync
)

CONFIG_SOURCE_DIR="./configs"  # Customize if your configs are in a different folder

# ─── FUNCTIONS ──────────────────────────────────────

function header() {
  echo -e "\n\033[1;35m>>> $1\033[0m"
}

function install_aur_helper() {
  local helper="$1"
  if ! command -v "$helper" &> /dev/null; then
    header "Installing $helper..."
    git clone "https://aur.archlinux.org/$helper.git"
    cd "$helper" && makepkg -si --noconfirm
    cd .. && rm -rf "$helper"
  else
    echo "$helper already installed."
  fi
}

function move_configs() {
  header "Copying config files to ~/.config..."

  mkdir -p ~/.config

  for dir in "${CONFIG_DIRS[@]}"; do
    SRC="$CONFIG_SOURCE_DIR/$dir"
    DEST="$HOME/.config/$dir"

    if [ -d "$SRC" ]; then
      echo "Installing config for $dir..."
      rm -rf "$DEST"
      cp -r "$SRC" "$DEST"
    else
      echo "Warning: $SRC does not exist, skipping."
    fi
  done
}

# ─── MAIN ───────────────────────────────────────────

header "Installing pacman packages..."
sudo pacman -Syu --needed --noconfirm "${PACMAN_PACKAGES[@]}"

for helper in "${AUR_HELPERS[@]}"; do
  install_aur_helper "$helper"
done

header "Installing AUR packages with paru..."
paru -S --needed --noconfirm "${AUR_PACKAGES[@]}"

move_configs

header "Done! System is ready 🎉"

