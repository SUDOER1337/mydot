#!/bin/bash

# ─── Config ───────────────────────────────────────────────────────────────
BACKUP_DIR="/mnt/Storages/mydot"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
DEST="$BACKUP_DIR/backup_$TIMESTAMP"

CONFIG_DIRS=(
  "hypr" "swaync" "btop" "kitty" "waybar"
  "rofi" "fish" "fastfetch" "nvim"
)

DOTFILES=(
  ".zshrc" ".p10k.zsh"
)

# Colors
GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
RESET="\e[0m"

# ─── Start Backup ─────────────────────────────────────────────────────────
echo -e "${GREEN}  Backing up config files to:${RESET} $DEST"
mkdir -p "$DEST"

# ── Backup .config subdirs ────────────────────────────────────────────────
for config in "${CONFIG_DIRS[@]}"; do
  SRC="$HOME/.config/$config"
  DEST_PATH="$DEST/.config/$config"
  if [ -d "$SRC" ]; then
    echo -e "${GREEN} Backing up .config/$config...${RESET}"
    mkdir -p "$(dirname "$DEST_PATH")"
    cp -a "$SRC" "$DEST_PATH"
  else
    echo -e "${YELLOW}  Skipping $config (not found)${RESET}"
  fi
done

# ── Backup regular dotfiles ───────────────────────────────────────────────
for file in "${DOTFILES[@]}"; do
  SRC="$HOME/$file"
  DEST_PATH="$DEST/$file"
  if [ -f "$SRC" ]; then
    echo -e "${GREEN} Backing up $file...${RESET}"
    cp "$SRC" "$DEST_PATH"
  else
    echo -e "${YELLOW}  Skipping $file (not found)${RESET}"
  fi
done

# ── Save package lists ────────────────────────────────────────────────────
echo -e "${GREEN}  Saving package lists...${RESET}"
for cmd in "${PACKAGE_LISTS[@]}"; do
  eval "$cmd" 2>/dev/null
done

# ── Optional: Save symlink info (future restore script) ───────────────────
find "$HOME/.config" -type l > "$DEST/symlinks.log"

echo -e "${GREEN} Backup completed at:${RESET} $DEST"

