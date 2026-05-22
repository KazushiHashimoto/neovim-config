#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

# Detect architecture
ARCH="$(uname -m)"
case "$ARCH" in
    x86_64)  NVIM_ARCH="x86_64" ;;
    aarch64) NVIM_ARCH="aarch64" ;;
    *) echo "Unsupported architecture: $ARCH" >&2; exit 1 ;;
esac

# Install Neovim v0.12
NVIM_TARBALL="nvim-linux-${NVIM_ARCH}.tar.gz"
echo "Installing Neovim v0.12 for ${NVIM_ARCH}..."
curl -LO "https://github.com/neovim/neovim/releases/download/v0.12.0/${NVIM_TARBALL}"
tar xzf "$NVIM_TARBALL"
sudo install -d /opt/nvim
sudo cp -rf "nvim-linux-${NVIM_ARCH}"/* /opt/nvim/
sudo ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim
rm -rf "nvim-linux-${NVIM_ARCH}" "$NVIM_TARBALL"
echo "Neovim $(nvim --version | head -1) installed."

# Install WezTerm
if ! command -v wezterm >/dev/null 2>&1; then
    echo "Installing WezTerm..."
    curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
    echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
    sudo apt-get update
    sudo apt-get install -y wezterm
else
    echo "WezTerm already installed: $(wezterm --version)"
fi

# Install the wezterm terminfo entry (needed because .wezterm.lua sets
# config.term = "wezterm"; without it, apps inside wezterm get wrong
# colors/keys). Installs to ~/.terminfo, no sudo required.
if ! infocmp wezterm >/dev/null 2>&1; then
    echo "Installing wezterm terminfo..."
    TERMINFO_TMP="$(mktemp)"
    curl -fsSL -o "$TERMINFO_TMP" \
        https://raw.githubusercontent.com/wezterm/wezterm/main/termwiz/data/wezterm.terminfo
    tic -x -o "$HOME/.terminfo" "$TERMINFO_TMP"
    rm -f "$TERMINFO_TMP"
    echo "wezterm terminfo installed."
else
    echo "wezterm terminfo already present."
fi

# Symlink .wezterm.lua and copy background image
echo "Symlinking .wezterm.lua to $HOME..."
ln -sfn "$REPO_DIR/wezterm/.wezterm.lua" "$HOME/.wezterm.lua"
echo "Symlinking wezterm background image to $HOME/Pictures..."
mkdir -p "$HOME/Pictures"
ln -sfn "$REPO_DIR/wezterm/shinjuku.png" "$HOME/Pictures/shinjuku.png"

# Symlink .bashrc
echo "Symlinking .bashrc to $HOME..."
ln -sfn "$REPO_DIR/scripts/.bashrc" "$HOME/.bashrc"

# Symlink .zshrc
echo "Symlinking .zshrc to $HOME..."
ln -sfn "$REPO_DIR/scripts/.zshrc" "$HOME/.zshrc"

# Symlink .tmux.conf
echo "Symlinking .tmux.conf to $HOME..."
ln -sfn "$REPO_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"

# Symlink starship.toml
echo "Symlinking starship.toml to $HOME/.config..."
mkdir -p "$HOME/.config"
ln -sfn "$REPO_DIR/scripts/starship.toml" "$HOME/.config/starship.toml"

echo "Done."
