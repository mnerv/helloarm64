/**
 * helloargs.S
 *
 * Reading command line argument.
 */
.data

args_str:
    .ascii  "args: "
    args_str_len = . - args_str

msg_str:
    .ascii  "Hello, World!\n"
    msg_str_len = . - msg_str

out_str:
    .fill   16
    out_str_len = . - out_str

.text

.global _start

_start:
    // prepare argc and argv
    ldr     x0, [sp]            // argc: points to first in stack pointer
    add     x1,  sp, #8         // argv: offsets stack pointer with 8-byte

    //// push to stack
    //stp     x0, x1, [sp, #-16]!
    //stp     x2, x8, [sp, #-16]!

    //add     x0,  sp, #8
    //ldr     x0, [x0]
    //bl      strlen
    //mov     x3, x0

    ldr     x0, [x1, #8]
    bl      strlen
    mov     x3, x0

    //ldr     x3, [x1, #8]

    //mov     x8, #64                 // prepare syscall write
    //mov     x0, #1                  // arg0: fd posix stdout
    //mov     x1, x3                // arg1: char const* buffer
    //mov     x2, #1                  // arg2: buffer size
    //svc     0

    //// restore stack
    //ldp     x2, x8, [sp], #16
    //ldp     x0, x1, [sp], #16

exit:
    // exit with 0
    mov     x8, #93             // 93 is syscall exit
    mov     x0, x3              // arg0: error_code
    svc     0

strlen:
    mov     x2, #0

strlen_loop:
    ldrb    w3, [x0, x2]
    cmp     w3, #0
    add     x2, x2, #1
    b.ne    strlen_loop

strlen_ret:
    mov     x0, x2
    ret

//strlen:
//    ldr     x1, =out_str
//    add     x2, x0, #'0'
//    str     x2, [x1]
//
//    mov     x2, #'\n'
//    str     x2, [x1, #1]
//
//    mov     x8, #64                 // prepare syscall write
//    mov     x0, #1                  // arg0: fd posix stdout
//    ldr     x1, =out_str            // arg1: char const* buffer
//    mov     x2, #2                  // arg2: buffer size
//    svc     0
//
//    ret
