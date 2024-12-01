/**
 * Input stream
 */

# .global fstrm

.global seek
seek:
    // seek file using lseek syscall
    // params:
    //     x0 - file descriptor
    //     x1 - offset in bytes
    //     x2 - seek to where
    // returns:
    //     x0 - seek offset in bytes
    mov x8, #62  // syscall: lseek
    svc 0
    ret
