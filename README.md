# helloarm64

Learning ARM64 assembly on Linux.

## Requirements

Cross-compiler

  - gcc-aarch64-linux-gnu

## Build

Assemble

```sh
aarch64-linux-gnu-as -o helloworld.o helloworld.S
```

Link

```sh
aarch64-linux-gnu-ld -s -o helloworld helloworld.o
```

Example running with QEMU-User on `x86_64`

```sh
qemu-aarch64 ./armex/helloworld
```

## Docker Container

**Linux**:

```sh
docker build --build-arg USER_ID=$(id -u) --build-arg GROUP_ID=$(id -g) -t helloarm64 .
```

**Windows**:

```sh
docker build -t helloarm64 .
```

Run container:

```sh
docker run -it --rm -v "$(pwd):/app" helloarm64
```

## Resources

  - [arm64.syscall.sh](https://arm64.syscall.sh/)
  - ['Hello World' in ARM64 Assembly by Peter Nelson](https://peterdn.com/post/2020/08/22/hello-world-in-arm64-assembly/)
  - [ARM Assembly By Example](https://armasm.com/docs/getting-to-hello-world/basics/) - arm32
  - [Running Arm Binaries on x86 with QEMU-User](https://azeria-labs.com/arm-on-x86-qemu-user/)
  - [A64 Instruction Set Architecture](https://developer.arm.com/Architectures/A64%20Instruction%20Set%20Architecture)

Unrelated:

  - [rst Cheatsheet](https://bashtage.github.io/sphinx-material/rst-cheatsheet/rst-cheatsheet.html)

## Documentations

List all man pages.

```sh
apropos .
```

```sh
man -k .
```

List in section number.

```sh
man -k . -s {section_number}
```

