.section .rodata
power_of_10:
    .quad 1                    // 10^0
    .quad 10                   // 10^1
    .quad 100                  // 10^2
    .quad 1000                 // 10^3
    .quad 10000                // 10^4
    .quad 100000               // 10^5
    .quad 1000000              // 10^6
    .quad 10000000             // 10^7
    .quad 100000000            // 10^8
    .quad 1000000000           // 10^9
    .quad 10000000000          // 10^10
    .quad 100000000000         // 10^11
    .quad 1000000000000        // 10^12
    .quad 10000000000000       // 10^13
    .quad 100000000000000      // 10^14
    .quad 1000000000000000     // 10^15
    .quad 10000000000000000    // 10^16
    .quad 100000000000000000   // 10^17
    .quad 1000000000000000000  // 10^18
    .quad 10000000000000000000 // 10^19

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
    // Convert u32 integer to ascii format
    // params:
    //     x0 - value
    //     x1 - buffer_ptr
    //     x2 - buffer_len
    // returns:
    //     x0 - 0: error, x > 0: success, where x is the written length

    mov     x3, #0           // length of final string
    adr     x4, power_of_10

u32_to_str_check_exp_loop:
    ldr     x5, [x4, x3]
    cmp     x5, x0
    b.hi    u32_to_str_exp_done
    add     x3, x3, #8
    b       u32_to_str_check_exp_loop

u32_to_str_exp_done:
    mov     x9, #8
    udiv    x3, x3, x9

    // check for out of buffer bound
    cmp     x3, x2
    b.gt    u32_to_str_exit_err

    mov     x6, #10   // const value 10

    mov     x9,  x3
    mov     x11, x1
    sub     x11, x3, #1
    add     x11, x1, x11

u32_to_str_insert_loop:
    cmp     x9, #0
    b.eq    u32_to_str_exit
    sub     x9, x9, #1

    udiv    x5, x0, x6      // y = x / 10
    msub    x7, x6, x5, x0  // z = x - (y * 10)
    add     x10, x7, #'0'
    strb    w10, [x11], #-1
    mov     x0, x5
    cbnz    x0, u32_to_str_insert_loop

u32_to_str_exit:
    mov     x0, x3
    ret

u32_to_str_exit_err:
    mov     x0, #0
    ret

.global str_to_u32
str_to_u32:
    // Convert string to u32 integer. No error checking digit check.
    // params:
    //     x0 - str_ptr
    //     x1 - str_len
    // returns:
    //     x0 - converted value
    mov x9, #0
    mov w10, #0
    mov x11, #0
    mov x12, #10

str_to_u32_loop:
    ldrb w10, [x0, x11]
    sub  x10, x10, #'0'
    mul  x9, x9, x12
    add  x9, x9, x10
    add  x11, x11, #1

    cmp x11, x1
    b.ne str_to_u32_loop

str_to_u32_exit:
    mov x0, x9
    ret

.global is_digit
is_digit:
    // Check if digit
    // params:
    //     x0 - ascii character
    // returns:
    //     x0 - 1: true, 0: false
    cmp x0, #'0'
    b.lt is_digit_false

    cmp x0, #'9'
    b.gt is_digit_false

    mov x0, #1
    ret

is_digit_false:
    mov x0, #0
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
