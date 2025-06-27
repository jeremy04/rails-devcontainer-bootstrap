# install.sh
#!/usr/bin/env bash
set -euo pipefail

append="$HOME/.bashrc"
marker="# --- dotfiles-codespace-marker ---"
if ! grep -q "$marker" "$append"; then
cat >> "$append" <<'EOF'
# --- dotfiles-codespace-marker ---
# Your bashrc goodness goes here

export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init - bash)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

parse_git_branch() {
  git rev-parse --abbrev-ref HEAD 2>/dev/null | sed 's/.*/ (\0)/'
}
export PS1="\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[32m\]\$(parse_git_branch)\[\033[00m\] \$ "

HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=2000
# --- dotfiles-codespace-marker ---
EOF
  echo "▶ Appended shell customizations to ~/.bashrc"
fi

