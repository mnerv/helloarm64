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

## Resources

  - [arm64.syscall.sh](https://arm64.syscall.sh/)
  - ['Hello World' in ARM64 Assembly by Peter Nelson](https://peterdn.com/post/2020/08/22/hello-world-in-arm64-assembly/)
  - [ARM Assembly By Example](https://armasm.com/docs/getting-to-hello-world/basics/) - arm32
  - [Running Arm Binaries on x86 with QEMU-User](https://azeria-labs.com/arm-on-x86-qemu-user/)

## Notes

**Posix File Descriptors (Standard)**

| File Descriptor  | Symbolic Name | Description     |
| ---------------- | ------------- | --------------- |
|                0 |       `stdin` | Standard Input  |
|                1 |      `stdout` | Standard Output |
|                2 |      `stderr` | Standard Error  |