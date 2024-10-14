.data

msg:
    .ascii  "Hello, ARM64!\n"
    msg_len = . - msg

.text

.global _start

_start:
    mov     x8, #64       // syscall write
    mov     x0, #1        // stdout fd
    ldr     x1, =msg      // arg0: load immediate address of msg
    ldr     x2, =msg_len  // arg1: load immediate value of msg_len
    svc     0             // supervisor call

    mov     x8, #93       // syscall exit
    mov     x0, #0        // arg0: exit with 0
    svc     0             // supervisor call
