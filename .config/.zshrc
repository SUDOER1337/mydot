# Enable Powerlevel10k instant prompt for speed
# Put this at the very top of your .zshrc
if [[ ! -f ~/.p10k.zsh ]]; then
  echo "⚠️ Please install powerlevel10k and generate ~/.p10k.zsh first."
else
  source ~/.p10k.zsh
fi

# Load powerlevel10k theme
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

# Run fastfetch once when starting the shell
if [[ -t 1 ]]; then
  fastfetch
fi

# Other common zsh settings (optional but recommended)
autoload -Uz compinit && compinit
autoload -Uz promptinit && promptinit

# You can add your aliases and exports here
# alias ll='ls -alF'

# Use zsh’s recommended settings for better experience
setopt AUTO_CD           # Change to a directory by typing its name
setopt HIST_IGNORE_DUPS  # Ignore duplicate commands in history
