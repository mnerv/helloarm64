.text

.global _start

_start:
    mov     x8, #93       // syscall exit
    mov     x0, #0        // arg0: exit with 0
    svc     0             // supervisor call
