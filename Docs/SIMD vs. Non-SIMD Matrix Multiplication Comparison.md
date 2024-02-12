# SIMD vs. Non-SIMD Matrix Multiplication Comparison

In this section, we compare the performance of the SIMD (Single Instruction, Multiple Data) version of the matrix multiplication code with the non-SIMD version. The performance evaluation involves execution time and efficiency improvements achieved by using SIMD instructions.

## SIMD Matrix Multiplication
The SIMD version of the matrix multiplication code takes advantage of parallel processing through SIMD instructions. These instructions perform multiple operations simultaneously, leading to improved performance in matrix operations.

### Example
![SIMD Matrix Multiplication](https://github.com/MoeeinAali/CSML-Project/blob/main/%D8%B6%D8%B1%D8%A8%20%D9%85%D8%A7%D8%AA%D8%B1%DB%8C%D8%B3/%D9%85%D9%82%D8%A7%DB%8C%D8%B3%D9%87%20%DA%A9%D8%AF%20%D9%87%D8%A7%20.jpg)

## Non-SIMD Matrix Multiplication
The non-SIMD version of the matrix multiplication code uses conventional instructions without parallel processing. This serves as a baseline for performance comparison.


## Performance Comparison
The SIMD version is expected to demonstrate faster execution times and improved efficiency compared to the non-SIMD version. The graphical representation of the execution time or speedup will be included in the images.

### Notes
- The images are for illustrative purposes and may vary based on specific hardware and compiler optimizations.
- SIMD instructions are designed to enhance parallelism and efficiency, especially in tasks involving large datasets.

**Performance Metrics:**
- **Execution Time:** The time taken by each version to complete matrix multiplication.
- **Speedup:** The ratio of the execution time of the non-SIMD version to the SIMD version.

### Compilation and Execution
Use an appropriate assembler and linker to compile the code, ensuring that the external functions are linked correctly.

```bash
nasm -f elf64 your_file_simd.asm -o your_file_simd.o
gcc -no-pie your_file_simd.o -o your_executable_simd
./your_executable_simd

nasm -f elf64 your_file_non_simd.asm -o your_file_non_simd.o
gcc -no-pie your_file_non_simd.o -o your_executable_non_simd
./your_executable_non_simd
