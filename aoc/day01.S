/**
 * day01.S
 * Advent of Code 2024 - 01
 */
.data

fmt_str:
    .fill   256
    fmt_str_len = . - fmt_str

msg_str:
    .asciz  "Hello, World!\n"
    msg_str_len = . - msg_str

arg_str:
    .ascii  "arg "
    arg_str_len = . - arg_str

colon_str:
    .ascii  ":"
    colon_str_len = . - colon_str

space_str:
    .ascii  " "
    space_str_len = . - space_str

ln_str:
    .ascii  "\n"
    ln_str_len = . - ln_str

opened_str:
    .ascii  "opened file: "
    opened_str_len = . - opened_str

err_open_str:
    .ascii  "error openning file: "
    err_open_str_len = . - err_open_str

filename_str:
    .asciz  "./dat/24/ex/01.txt"
    filename_str_len = . - filename_str

mem_buf_fd         = 0 * 8
mem_buf_text_size  = 1 * 8
mem_buf_tmp_ptr    = 2 * 8
mem_buf_tmp_offset = 3 * 8
mem_buf_tmp_a      = 4 * 8
mem_buf_tmp_b      = 5 * 8

mem_buf:
    .fill 1024, 1, 0
    mem_buf_len = . - mem_buf

read_buf:
    .fill 2048, 1, 0
    read_buf_len = . - read_buf

str_buf:
    .fill 2048, 1, 0
    str_buf_len = . - str_buf

str_num:
    .ascii  "1"
    str_num_len = . - str_num

vec_a:
    .fill 128, 1, 0

vec_b:
    .fill 128, 1, 0

.text

.global _start

_start:
    ldr     x0, [sp]             // argc: points to first in stack pointer
    add     x1, sp, #8           // argv: offsets stack pointer with 8-byte

    mov     x8, #56              // syscall: openat
    mov     x0, -100             // arg0: AT_FDCWD
    ldr     x1, =filename_str    // arg1: filename pointer
    mov     x2, #0x00            // arg2: O_RDONLY
    mov     x3, #0400            // arg3: Read permission
    svc     0

    cmp     x0, #0
    b.le    err_open

    adr     x1, mem_buf
    str     x0, [x1, mem_buf_fd]

    // print opened file
    ldr     x0, =opened_str
    ldr     x1, =opened_str_len
    bl      nprint

    ldr     x0, =filename_str
    ldr     x1, =filename_str_len
    bl      nprint

    ldr     x0, =ln_str
    ldr     x1, =ln_str_len
    bl      nprint

    // seek to the end of file to get file size in bytes
    adr     x1, mem_buf
    ldr     x0, [x1]            // arg0: fd
    mov     x1, #0              // arg1: 0 start from zero
    mov     x2, #2              // arg2: SEEK_END
    bl      seek

    // store file size in mem buffer
    adr     x1, mem_buf
    str     x0, [x1, mem_buf_text_size]

    // seek to beginning of the file again
    ldr     x0, [x1]            // arg0: fd
    mov     x1, #0              // arg1: 0 offset bytes
    mov     x2, #0              // arg2: SEEK_SET
    bl      seek

    adr     x9, mem_buf
    ldr     x10, [x9, #0]
    ldr     x11, [x9, #8]
    ldr     x12, =read_buf_len

    cmp     x12, x11
    csel    x13, x12, x11, lt

    mov     x8, #63             // syscall: read
    mov     x0, x10             // arg0: fd
    ldr     x1, =read_buf       // arg1: buffer_ptr
    mov     x2, x13             // arg2: count
    svc     0

tokenize_digit:
    adr     x0, mem_buf
    adr     x9, read_buf
    str     x9, [x0, mem_buf_tmp_ptr]

    mov     x10, #0

tokenize_digit_loop:
    ldrb    w11, [x9, x10]
    cmp     x11, #' '
    b.eq    tokenize_eat_space
    cmp     x11, #'\n'
    b.eq    tokenize_eat_newline

tokenize_eat_digit_loop:
    ldrb    w11, [x9, x10]
    mov     x0, x11
    bl      is_digit
    cmp     x0, #1
    b.ne    tokenize_digit_loop
    add     x10, x10, #1
    b       tokenize_eat_digit_loop

tokenize_eat_space:
    adr     x1, mem_buf
    str     x10, [x1, mem_buf_tmp_offset]
    ldr     x11, [x1, mem_buf_tmp_ptr]

    mov     x0, x11
    mov     x1, x10
    bl      str_to_u32

    adr     x1, mem_buf
    str     x0, [x1, mem_buf_tmp_a]

    adr     x9, read_buf
    ldr     x10, [x1, mem_buf_tmp_offset]

tokenize_eat_space_loop:
    ldrb    w11, [x9, x10]
    add     x10, x10, #1
    cmp     x11, #' '
    b.eq    tokenize_eat_space_loop

    adr     x0, mem_buf
    add     x1, x9, x10
    str     x1, [x0, mem_buf_tmp_ptr]
    mov     x10, #0
    str     x10, [x0, mem_buf_tmp_offset]
    ldr     x9, [x0, mem_buf_tmp_ptr]

    b       tokenize_digit_loop

tokenize_eat_newline:
    # adr     x1, mem_buf
    # str     x10, [x1, mem_buf_tmp_offset]
    # ldr     x11, [x1, mem_buf_tmp_ptr]
    #
    # mov     x0, x11
    # mov     x1, x10
    # bl      str_to_u32
    #
    # adr     x1, mem_buf
    # str     x0, [x1, mem_buf_tmp_b]

    # adr     x9, read_buf
    # ldr     x10, [x1, mem_buf_tmp_offset]
    #
    # add     x10, x10, #1
    # adr     x0, mem_buf
    # add     x1, x9, x10
    # str     x1, [x0, mem_buf_tmp_ptr]

    # b       tokenize_digit_loop

    // close file
    mov     x8, #57
    ldr     x0, [x1]            // arg0: fd
    svc     0

    adr     x1, mem_buf
    ldr     x0, [x1, mem_buf_tmp_b]

    # mov     x0, #0              // exit success
    bl      exit

err_open:
    ldr     x0, =err_open_str
    ldr     x1, =err_open_str_len
    bl      nprint

    ldr     x0, =filename_str
    ldr     x1, =filename_str_len
    bl      nprint

    ldr     x0, =ln_str
    ldr     x1, =ln_str_len
    bl      nprint

    mov     x0, #1              // exit error

exit:
    mov     x8, #93             // 93 is syscall exit
    svc     0
