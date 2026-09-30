#!/bin/sh
#
# This script should be run via curl:
#   sh -c "$(curl -fsSL https://raw.githubusercontent.com/computer-wilco/microzsh/master/tools/install.sh)"
# or via wget:
#   sh -c "$(wget -qO- https://raw.githubusercontent.com/computer-wilco/microzsh/master/tools/install.sh)"
#
# As an alternative, you can first download the install script and run it afterwards:
#   wget https://raw.githubusercontent.com/computer-wilco/microzsh/master/tools/install.sh
#   sh install.sh
#
# You can tweak the install behavior by setting variables when running the script. For
# example, to change the path to the MicroZsh repository:
#   ZSH=~/.zsh sh install.sh
#
# Respects the following environment variables:
#   ZSH     - path to the MicroZsh repository folder (default: $HOME/.microzsh)
#

set -e

TARGET_DIR="${ZSH:-$HOME/.microzsh}"
REPO_URL="https://github.com/computer-wilco/microzsh.git"

print_msg() {
  printf "\033[0;32m>> %s\033[0m\n" "$1"
}

# clone or update repository source tree layout
if [ -d "$TARGET_DIR" ]; then
  print_msg "MicroZsh is already installed at $TARGET_DIR. Updating repository..."
  exit 0
else
  print_msg "Cloning MicroZsh repository..."
  git clone "$REPO_URL" "$TARGET_DIR"
fi

# deploy the runtime configuration template file safely
ZSHRC_FILE="$HOME/.zshrc"
TEMPLATE_FILE="$TARGET_DIR/templates/zshrc.zsh-template"

if [ -f "$ZSHRC_FILE" ]; then
  print_msg "Found existing $ZSHRC_FILE profile config. Backing it up to $ZSHRC_FILE.bak..."
  cp "$ZSHRC_FILE" "$ZSHRC_FILE.bak"
fi

if [ -f "$TEMPLATE_FILE" ]; then
  print_msg "Deploying configuration template to $ZSHRC_FILE..."
  cp "$TEMPLATE_FILE" "$ZSHRC_FILE"
else
  print_msg "Error: Configuration template could not be found inside the repository directory tree."
  exit 1
fi

print_msg "Installation complete! Restart your shell terminal to initialize MicroZsh."
