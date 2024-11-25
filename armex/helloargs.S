/**
 * helloargs.S
 *
 * Reading command line argument.
 */
.data

args_str:
    .asciz  "args: "
    args_str_len = . - args_str

msg_str:
    .asciz  "Hello, World!\n"
    msg_str_len = . - msg_str

ln_str:
    .ascii  "\n"
    ln_str_len = . - ln_str

out_str:
    .fill   16
    out_str_len = . - out_str

.text

.global _start

_start:
    ldr     x0, [sp]             // argc: points to first in stack pointer
    add     x1, sp, #8          // argv: offsets stack pointer with 8-byte

    stp     x0, x1, [sp, #-16]
    bl      print_args
    ldp     x0, x1, [sp, #16]

exit:
    // exit with 0
    mov     x8, #93             // 93 is syscall exit
    mov     x0, #0              // arg0: error_code
    svc     0

print_args:
    mov     x9, x0
    mov     x10, x1
    mov     x11, #0
    mov     x12, #0

print_args_loop:
    stp     x9, x10, [sp, #-16]!
    stp     x11, x12, [sp, #-16]!
    stp     fp, lr, [sp, #-16]!
    mov     fp, sp
    ldr     x0, =args_str
    bl      print
    ldp     fp, lr, [sp], #16
    ldp     x11, x12, [sp], #16
    ldp     x9, x10, [sp], #16

    stp     x9, x10, [sp, #-16]!
    stp     x11, x12, [sp, #-16]!
    stp     fp, lr, [sp, #-16]!

    ldr     x0, [x10, x12]
    bl      println

    ldp     fp, lr, [sp], #16
    ldp     x11, x12, [sp], #16
    ldp     x9, x10, [sp], #16

    add    x11, x11, #1
    add    x12, x12, #8
    cmp    x11, x9
    b.ne   print_args_loop
    ret

print:
    mov     x9, x0
    stp     fp, lr, [sp, #-16]!   // Save old FP (x29) and LR (x30)
    mov     fp, sp
    bl      strlen
    mov     x2, x0
    ldp     x29, x30, [sp], #16   // Restore old FP and LR

    mov     x8, #64
    mov     x0, #1
    mov     x1, x9
    svc     0
    ret

println:
    mov     x9, x0
    stp     fp, lr, [sp, #-16]!  // Save old FP (x29) and LR (x30)
    mov     fp, sp
    bl      strlen
    mov     x2, x0
    ldp     fp, lr, [sp], #16    // Restore old FP and LR

    mov     x8, #64
    mov     x0, #1
    mov     x1, x9
    svc     0

    mov     x8, #64          // syscall write
    mov     x0, #1           // stdout fd
    ldr     x1, =ln_str      // arg0: load immediate address of ln_str
    ldr     x2, =ln_str_len  // arg1: load immediate value of ln_str_len
    svc     0                // supervisor call

    ret

strlen:
    // Subroutine: strlen
    // Purpose: Calculate the length of a null-terminated string.
    // Inputs:
    //   x0 - Address of the null-terminated string.
    // Outputs:
    //   x0 - Length of the string (number of characters before the null terminator).
    // Clobbers:
    //   x2 - Used as a counter to traverse the string.
    //   w3 - Temporarily holds the current character for comparison.
    mov     x2, #0

strlen_loop:
    ldrb    w3, [x0, x2]         // Load byte at [x0 + x2]
    cmp     w3, #0               // Check for null terminator
    b.eq    strlen_ret           // If null, exit loop
    add     x2, x2, #1           // Increment counter
    b       strlen_loop          // Repeat

strlen_ret:
    mov     x0, x2
    ret
