#!/bin/bash
##ADD: Add following command:
#
#     bash "$(dirname "${BASH_SOURCE[0]}")/post-create-agents.sh"
#
# at the end of .devcontainer/.post-create.sh

CURRENT_USER=$(whoami)

# install Claude Code CLI
echo "" && echo "Installing Claude Code CLI..."
# - fix ownership of volume-mounted dir (docker-compose.yml creates it as root if not pre-existing in image)
sudo chown "$CURRENT_USER:$CURRENT_USER" "$HOME/.claude"
# - persist ~/.claude.json inside the mounted ~/.claude volume
mkdir -p "$HOME/.claude"
if [ ! -L "$HOME/.claude.json" ]; then
  # if not symlink, then set up persistence
  if [ -f "$HOME/.claude.json" ]; then
    # if existing file (created by installation or VS Code extension)
    # them move it under .claude folder
    mv "$HOME/.claude.json" "$HOME/.claude/.claude.json"
  else
    # if file does not exist then create a placeholder with valid empty JSON
    echo '{}' > "$HOME/.claude/.claude.json"
  fi
  ln -s "$HOME/.claude/.claude.json" "$HOME/.claude.json"
fi
# - install
curl -fsSL https://claude.ai/install.sh | bash
echo "Claude Code CLI (claude): $(claude --version || true) installed"

# install Antigravity CLI
echo "" && echo "Installing Antigravity CLI..."
# - fix ownership of volume-mounted dir (docker-compose.yml creates it as root if not pre-existing in image)
sudo chown "$CURRENT_USER:$CURRENT_USER" "$HOME/.gemini"
# - install
curl -fsSL https://antigravity.google/cli/install.sh | bash
echo "Antigravity CLI (agy): $(agy --version || true) installed"

# install Codex CLI
echo "" && echo "Installing Codex CLI..."
# - fix ownership of volume-mounted dir (docker-compose.yml creates it as root if not pre-existing in image)
sudo chown "$CURRENT_USER:$CURRENT_USER" "$HOME/.codex"
# - install
curl -fsSL https://chatgpt.com/codex/install.sh | CODEX_NON_INTERACTIVE=1 bash
echo "Codex CLI (codex): $(codex --version || true) installed"

# install Auggie CLI (Augment Code)
# NOTE: Node is pre-installed via nvm in the Dockerfile, so npm is available without sudo
echo "" && echo "Installing Auggie CLI..."
# - fix ownership of volume-mounted dir (docker-compose.yml creates it as root if not pre-existing in image)
sudo chown "$CURRENT_USER:$CURRENT_USER" "$HOME/.augment"
# - install
npm install -g @augmentcode/auggie
echo "Auggie CLI (auggie): $(auggie --version || true) installed"
