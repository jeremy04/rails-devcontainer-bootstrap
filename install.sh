# install.sh
#!/usr/bin/env bash
set -euo pipefail

append="$HOME/.bashrc"
marker="# --- dotfiles-codespace-marker ---"
if ! grep -q "$marker" "$append"; then
cat >> "$append" <<'EOF'
# --- dotfiles-codespace-marker ---
# Your bashrc goodness goes here

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

# -----------------------------------------------------------------------------
# Ensure dummy AWS profile exists (for LocalStack / offline dev)
# Runs as the Codespace user
# -----------------------------------------------------------------------------
AWS_DIR="$HOME/.aws"
if [[ ! -f "$AWS_DIR/credentials" ]]; then
  mkdir -p "$AWS_DIR"

  cat > "$AWS_DIR/credentials" <<'EOF'
[default]
aws_access_key_id = dummy
aws_secret_access_key = dummy
EOF

  cat > "$AWS_DIR/config" <<'EOF'
[default]
region = us-east-1
output = json
EOF

  echo "✔️  Created dummy AWS profile in $AWS_DIR"
fi
