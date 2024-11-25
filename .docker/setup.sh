#!/usr/bin/env sh

BASEDIR="$(readlink -f $(dirname $0))"

# Setup nvim
mkdir -p ~/.config
cp -r .docker/nvim ~/.config/nvim

# Install plugins in headless mode and quit
nvim --headless "+Lazy! sync" +qa

# git configuration
git config --global --add safe.directory /app
git config --global core.autocrlf false

# Install zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" > /dev/null

# Change default shell to zsh
echo "" | chsh -s $(which zsh)

# zsh config
echo "export SHELL=$(which zsh)" >> ~/.zshrc
echo "export EDITOR=nvim" >> ~/.zshrc
echo "alias ls=exa" >> ~/.zshrc
echo "alias cat='bat -pp'" >> ~/.zshrc
echo "export PAGER='nvim +Man!'" >> ~/.zshrc
echo 'export PATH=/opt/arm-gnu-toolchain-13.3.rel1-x86_64-aarch64-none-linux-gnu/bin:$PATH' >> ~/.zshrc
