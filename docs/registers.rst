ARM65 Registers
===============

In ARM64, certain registers are considered callee-saved
(also known as non-volatile) and are conventionally preserved across function
calls. These are the registers that are "good not to touch" unless absolutely
necessary, as modifying them requires saving and restoring their values.
Preserving these registers ensures compatibility with the ARM64 Procedure Call
Standard (AAPCS64).

Callee-Saved (Non-Volatile) Registers
-------------------------------------

These registers must be preserved by any subroutine that uses them. If your code
modifies these registers, it is your responsibility to save their original
values (e.g., push them onto the stack) and restore them before returning
control to the caller.

+-------------+---------------------------------------------------------------------------+
| Register    | Purpose                                                                   |
+=============+===========================================================================+
| `x19`-`x28` | General-purpose registers for callee use. Must be preserved across calls. |
+-------------+---------------------------------------------------------------------------+
| `x29`       | Frame Pointer (FP). Used for maintaining stack frames.                    |
+-------------+---------------------------------------------------------------------------+
| `x30`       | Link Register (LR). Used for storing the return address of a function.    |
+-------------+---------------------------------------------------------------------------+
| `sp`        | Stack Pointer. Should always point to the top of the stack.               |
+-------------+---------------------------------------------------------------------------+

Caller-Saved (Volatile) Registers
---------------------------------

Registers not listed above are caller-saved (also known as volatile). If a
caller needs to keep their values across a function call, the caller must
explicitly save and restore them (e.g., on the stack). These registers can be
freely used by subroutines without saving them.

+--------------+------------------------------------------------------------------------------+
| Register     | Purpose                                                                      |
+==============+==============================================================================+
| `x0`-`x7`    | Function argument registers and return value (for scalar values).            |
+--------------+------------------------------------------------------------------------------+
| `x8`         | Indirect result location or temporary (e.g., syscall numbers).               |
+--------------+------------------------------------------------------------------------------+
| `x9-x15`     | Temporary registers.                                                         |
+--------------+------------------------------------------------------------------------------+
| `x16`, `x17` | Intra-procedure-call scratch registers (e.g., used by the linker).           |
+------------- +------------------------------------------------------------------------------+
| `x18`        | Platform register (reserved for thread-local storage or other platform use). |
+------------- +------------------------------------------------------------------------------+

