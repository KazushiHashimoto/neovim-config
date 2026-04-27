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

# Copy .wezterm.lua and background image
echo "Copying .wezterm.lua to $HOME..."
cp "$REPO_DIR/wezterm/.wezterm.lua" "$HOME/.wezterm.lua"
echo "Copying wezterm background image to $HOME/Pictures..."
mkdir -p "$HOME/Pictures"
cp "$REPO_DIR/wezterm/shinjuku.png" "$HOME/Pictures/shinjuku.png"

# Copy .bashrc
echo "Copying .bashrc to $HOME..."
cp "$REPO_DIR/scripts/.bashrc" "$HOME/.bashrc"

# Copy .zshrc
echo "Copying .zshrc to $HOME..."
cp "$REPO_DIR/scripts/.zshrc" "$HOME/.zshrc"

# Copy tmux.conf
echo "Copying .tmux.conf to $HOME..."
cp "$REPO_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"

echo "Done."
