.data

// data segment
msg:
    .ascii  "Hello, ARM64!\n"
    msg_len = . - msg

.text

// application entry point
.globl _start
_start:
    // syscall write
    mov     x0, #1
    ldr     x1, =msg
    ldr     x2, =msg_len
    mov     w8, #64
    svc     #0

    // syscall exit
    mov     x0, #0
    mov     w8, #93
    svc     #0
