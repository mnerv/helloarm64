.global strlen
strlen:
    // Calculate the length of a null-terminated string
    // params:
    //     x0 - pointer to the null-terminated string
    // returns:
    //     x0 - length of the string (number of characters before the null
    //          terminator)
    // clobbers:
    //     x2 - used as a counter
    //     w3 - used to load and compare string bytes
    mov     x2, #0

strlen_loop:
    ldrb    w3, [x0, x2]
    cmp     w3, #0
    b.eq    strlen_ret
    add     x2, x2, #1
    b       strlen_loop

strlen_ret:
    mov     x0, x2
    ret

.global u32_to_str
u32_to_str:
    // Convert u32 number to ascii format
    // params:
    //     x0 - value
    //     x1 - buffer
    //     x2 - buffer_len
    // returns:
    //     x0 - 0: success, 1: error
    ret

.global print
print:
    // Print a null-terminated string to stdout
    // params:
    //     x0 - pointer to the null-terminated string
    // returns:
    //     none
    // clobbers:
    //     x9, x10, x2, x8
    stp     x9, x10, [sp, #-16]!

    mov     x9, x0
    stp     fp, lr, [sp, #-16]!  // Save old FP (x29) and LR (x30)
    mov     fp, sp
    bl      strlen
    mov     x2, x0               // string length for syscall write
    ldp     fp, lr, [sp], #16    // Restore old FP and LR

    mov     x8, #64              // syscall to write
    mov     x0, #1               // fd for stdout
    mov     x1, x9               // pointer to data
    svc     0

    ldp    x9, x10, [sp], #16
    ret

.global nprint
nprint:
    // Print a string of a specified length to stdout
    // params:
    //     x0 - pointer to the string
    //     x1 - length of the string
    // returns:
    //     none
    // clobbers:
    //     x8
    mov     x8, #64              // syscall to write
    mov     x2, x1               // pointer to data
    mov     x1, x0               // pointer to data
    mov     x0, #1               // fd for stdout
    svc     0
    ret
