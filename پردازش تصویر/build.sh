#!/bin/bash

filename="$1"
source_file="src/$filename.S"
output_file="$filename"

nasm -felf64 "$source_file" -o "${output_file}.o"
gcc -no-pie -fno-pie "src/main.c" "${output_file}.o" -o "exec"
./exec
