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

# Copy .bashrc
echo "Copying .bashrc to $HOME..."
cp "$REPO_DIR/scripts/.bashrc" "$HOME/.bashrc"

# Copy tmux.conf
echo "Copying .tmux.conf to $HOME..."
cp "$REPO_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"

echo "Done."
