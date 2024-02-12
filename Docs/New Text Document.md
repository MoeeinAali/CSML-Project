# Matrix Multiplication in Assembly

This assembly code performs matrix multiplication for three given matrices (`mat1`, `mat2`, and `mat3`). The matrices are of size `n x n`, and the result is stored in the `mat3` matrix.

## Input

- The size of the matrices (`n`) is taken as input from the user.
- Input values for matrices `mat1` and `mat2` are read using the `read_float` function.

## Matrix Multiplication

The code multiplies matrices `mat1` and `mat2` and stores the result in `mat3` using nested loops.

## Output

The result matrix (`mat3`) is then printed to the console using the `write_float` function.

## Usage

1. Input the size of the matrices `n`.
2. Input the values for matrices `mat1` and `mat2`.
3. The code calculates the product of matrices and prints the result in matrix `mat3`.

## External Functions

- `read_float`: Reads a floating-point number.
- `read_uint`: Reads an unsigned integer.
- `write_float`: Writes a floating-point number.
- `write_uint`: Writes an unsigned integer.
- `write_char`: Writes a character.

## Data Sections

- `mat1`, `mat2`, `mat3`: Arrays to store the input and output matrices.
- `vec`: An array of doubles.
- `n`: A qword variable to store the size of the matrices.

## Note

- The matrices are assumed to be of size `n x n`.
- The code is designed for educational purposes and may need modification for specific use cases.

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
```

# Parallel Matrix Multiplication in SIMD Assembly

This assembly code performs parallel matrix multiplication for three given matrices (`mat1`, `mat2`, and `mat3`). The matrices are of size `n x n`, and the result is stored in the `mat3` matrix. The code leverages SIMD (Single Instruction, Multiple Data) instructions for efficient parallel processing.

## Input

- The size of the matrices (`n`) is taken as input from the user.
- Input values for matrices `mat1` and `mat2` are read using the `read_float` function.

## Matrix Multiplication

The code multiplies matrices `mat1` and `mat2` and stores the result in `mat3` using parallel processing with SIMD instructions.

## Output

The result matrix (`mat3`) is then printed to the console using the `write_float` function.

## Usage

1. Input the size of the matrices `n`.
2. Input the values for matrices `mat1` and `mat2`.
3. The code calculates the product of matrices and prints the result in matrix `mat3`.

## External Functions

- `read_float`: Reads a floating-point number.
- `read_uint`: Reads an unsigned integer.
- `write_float`: Writes a floating-point number.
- `write_uint`: Writes an unsigned integer.
- `write_char`: Writes a character.

## Data Sections

- `mat1`, `mat2`, `mat3`: Arrays to store the input and output matrices.
- `vec`: An array of doubles.
- `n`: A qword variable to store the size of the matrices.
