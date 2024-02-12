# CSML-Project
Project of Dr. Jahangir's CE40126: Computer Structure and Machine Language (Sharif University of Technology - Fall 2023)


## Parallel Matrix Multiplication Algorithm
The matrix multiplication is performed using three nested loops. The first two loops iterate over the rows and columns of the input matrices, while the third loop calculates the product and updates the result matrix. SIMD instructions are employed to enhance parallel processing efficiency.

## Note
- The matrices are assumed to be of size `n x n`.
- The code is designed for educational purposes and leverages SIMD for optimized parallel computation.

### Example
```assembly
section .text

asm_main:
    xor rax,rax
    sub rsp, 8
    call read_uint
    mov qword[n], rax

    ; ... (rest of the code)

    add     rsp, 8
    ret

