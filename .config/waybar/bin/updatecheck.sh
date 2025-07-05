#!/usr/bin/env bash

set -e

# Tool check
check() {
  command -v "$1" &>/dev/null
}

notify() {
  check notify-send && notify-send -a "UpdateCheck Waybar" "$@" || echo "$@"
}

stringToLen() {
  local str="$1"
  local len="$2"
  if [ ${#str} -gt "$len" ]; then
    echo "${str:0:$((len - 2))}.."
  else
    printf "%-${len}s" "$str"
  fi
}

# Action: --check
if [[ "$1" == "--check" ]]; then
  notify "Checking for updates..."
  "$0"
  exit 0
fi

# Action: --update
if [[ "$1" == "--update" ]]; then
  notify "Running system updates..."
  kitty -e bash -c 'paru -Syu && flatpak update; read -n 1 -s -r -p "Press any key to close..."'
  # Wait until updates are actually cleared
  while :; do
    arch_updates=$(checkupdates --nocolor 2>/dev/null | wc -l)
    flatpak_updates=0
    if check flatpak; then
      flatpak_updates=$(flatpak remote-ls --updates --columns=application 2>/dev/null | wc -l)
    fi
    if [[ $arch_updates -eq 0 && $flatpak_updates -eq 0 ]]; then
      break
    fi
    sleep 2
  done
  # Now show 0 updates
  sleep 1
  echo "Refreshing update count..."
  "$0"
  exit 0
fi


# Default: show info
check aur || {
  notify "aurutils is missing"
  echo '{"text":"ERR","tooltip":"aurutils or pacman-contrib missing"}'
  exit 1
}

check checkupdates || {
  notify "pacman-contrib is missing"
  echo '{"text":"ERR","tooltip":"pacman-contrib or aurutils missing"}'
  exit 1
}

IFS=$'\n'$'\r'

# Kill previous checkupdates instance if any
killall -q checkupdates || true

# Get updates
cup() {
  checkupdates --nocolor
  pacman -Qm | aur vercmp
}
mapfile -t updates < <(cup)

# Flatpak updates
flatpak_updates=()
if check flatpak; then
  mapfile -t flatpak_updates < <(flatpak remote-ls --updates --columns=application 2>/dev/null)
fi

# Combined count
update_count=$(( ${#updates[@]} + ${#flatpak_updates[@]} ))

tooltip="<b>$update_count updates</b>\n"

# Arch updates
if [ "${#updates[@]}" -gt 0 ]; then
  tooltip+="\n<b>Arch/AUR Updates</b>\n"
  tooltip+="<b>$(stringToLen "PkgName" 20) $(stringToLen "PrevVer" 20) $(stringToLen "NextVer" 20)</b>\n"
  for i in "${updates[@]}"; do
    pkg="$(stringToLen "$(echo "$i" | awk '{print $1}')" 20)"
    prev="$(stringToLen "$(echo "$i" | awk '{print $2}')" 20)"
    next="$(stringToLen "$(echo "$i" | awk '{print $4}')" 20)"
    tooltip+="<b>$pkg</b> $prev $next\n"
  done
fi

# Flatpak updates
if [ "${#flatpak_updates[@]}" -gt 0 ]; then
  tooltip+="\n<b>Flatpak Updates</b>\n"
  for app in "${flatpak_updates[@]}"; do
    tooltip+="• $app\n"
  done
fi

tooltip="${tooltip::-2}" # trim trailing newline

# Output for Waybar (no icon, just count)
echo "{\"text\":\"$update_count\",\"tooltip\":\"$tooltip\"}"
