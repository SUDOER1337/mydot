#!/bin/bash

# ─── Configurable Paths ───────────────────────────────────────────────
BACKUP_DIR="/mnt/Storages/mydot"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
DEST="$BACKUP_DIR/backup_$TIMESTAMP"

# ─── List of Dotfiles to Back Up ──────────────────────────────────────
CONFIGS=(
  "hypr"
  "swaync"
  "btop"
  "kitty"
  "waybar"
  "rofi"
)

# ─── Start Backup ─────────────────────────────────────────────────────
echo "🗂️  Backing up config files to: $DEST"
mkdir -p "$DEST"

for config in "${CONFIGS[@]}"; do
  SRC="$HOME/.config/$config"
  DEST_PATH="$DEST/$config"

  if [ -d "$SRC" ]; then
    echo "📦 Backing up $config..."
    cp -r "$SRC" "$DEST_PATH"
  else
    echo "⚠️  Skipping $config (not found)"
  fi
done

echo "✅ Backup completed at $DEST"

