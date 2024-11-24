#!/usr/bin/env sh
deps="
bat
build-base
coreutils
curl
exa
git
man-pages
man-db
htop
neofetch
neovim
neovim-doc
nodejs
npm
openssh
openssl
parallel
ripgrep
shadow
tmux
wget
zsh
python3-dev
python3
py3-pip
gcc
musl-dev
linux-headers
autoconf
automake
libtool
m4
ninja-build
cmake
meson
qemu-aarch64
gcompat
"
deps=$(printf "$deps" | tr '\n' ' ' | sed -e 's/^[[:space:]]*//')

apk add --no-cache $deps
