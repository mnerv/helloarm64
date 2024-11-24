#!/usr/bin/env sh
# Install arm64 toolchain

wget -nv "https://developer.arm.com/-/media/Files/downloads/gnu/13.3.rel1/binrel/arm-gnu-toolchain-13.3.rel1-x86_64-aarch64-none-linux-gnu.tar.xz"
tar -xf ./arm-gnu-toolchain-13.3.rel1-x86_64-aarch64-none-linux-gnu.tar.xz

cd arm-gnu-toolchain-13.3.rel1-x86_64-aarch64-none-linux-gnu

cp -r ./bin/* /usr/bin/
cp -r ./include/* /usr/include/
cp -r ./lib/* /usr/lib/
cp -r ./lib64/* /lib64/
cp -r ./libexec/* /usr/libexec/
cp -r ./share/* /usr/share/

