global      asm_main
extern      printf
extern      read_float ; xmm0
extern      read_uint ; rax
extern      write_float; xmm0
extern      write_uint; 
extern      write_char ; rdi

section .text
asm_main:
    xor rax,rax
    sub     rsp, 8
    
    call read_uint 
    mov qword[n], rax
    
    call read_uint
    mov qword[m], rax

    ; mov rdi , 10
    xor rsi , rsi 
    mov rcx,qword[n]
    for_i:
        mov rdx,qword[n]
        for_j:
            push rsi
            push rcx
            push rdx
            push rdx
            call read_float
            pop rdx
            pop rdx
            pop rcx
            pop rsi
            movss [mat1+rsi*4], xmm0
            inc rsi
            dec rdx
            jnz for_j
        dec rsi ; fix 512
        and si , 0xFE00
        add rsi, 0x0200
        loop for_i


    xor rsi,rsi
    mov rcx,qword[m]
    for_i2:
        mov rdx,qword[m]
        for_j2:
            push rsi
            push rcx
            push rdx
            push rdx
            call read_float
            pop rdx
            pop rdx
            pop rcx
            pop rsi
            movss [mat2+rsi*4], xmm0
            inc rsi
            dec rdx
            jnz for_j2
        dec rsi ; fix 512
        and si , 0xFE00
        add rsi, 0x0200
        loop for_i2
    

; تا این بهش همانند کد قبلی بود و کامنت ها در کد قبلی موجود است.



; محاسبه کانولوشن
    mov rdx,qword[n]
    sub rdx,qword[m]
    inc rdx
    xor rcx , rcx
    conv1:
        xor r10,r10
        conv2:
            xor r11,r11
            conv3:
                xor r12,r12
                conv4:
                                                        ; i=rcx / j=r10 / k=r11 / l = r12
                    mov r13 , r11 ; r13 = k
                    add r13 , rcx ; r13 = i + k
                    shl r13 , 9
                    mov r14 , r10                       ; r14 = j
                    add r14 , r12                       ; r14 = j + l
                    add r13 , r14    
                                                        ; به طور همزمان و موازی 4 تا عدد را در رجیستر میریزیم.
                    movups xmm0 , [mat1 + r13*4]        ; xmm0 = mat1[i+k][j+l]           
                    mov r13, r11                        ; r13 = k
                    shl r13 , 9
                    add r13 , r12
                                                        ; به طور همزمان و موازی 4 تا عدد را در رجیستر میریزیم.
                    movups xmm1 , [mat2 + r13*4]        ; xmm1 = mat2[k][l]

                                                        ; xmm0 = mat1[i+k][j+l] * mat2[k][l]
                    vdpps xmm0, xmm0 , xmm1, 0xF1       ;  ضرب نقطه ای 2 بردار به صورت موازی
                    mov r13 , rcx                       ; r13 = i 
                    shl r13 , 9                         ; ضربدر 512
                    add r13 , r10                       ; جمع زدن غیر موازی
                    movups xmm1 , [mat3 + r13*4]        ; ریختن مقدار در رجیستر
                    addps xmm1 , xmm0                   ; جمع زدن 2 بردار به صورت موازی
                    movups [mat3 + r13*4], xmm1         ; به طور همزمان و موازی 4 تا عدد را در رجیستر میریزیم.
                    add r12 , 4
                    cmp r12,qword[m]
                    jl  conv4
                inc r11
                cmp r11,qword[m]
                jl conv3
            inc r10
            cmp r10,rdx
            jl conv2
        inc rcx
        cmp rcx, rdx
        jl conv1


    ; این بخش مربوط به خروجی دادن است
    ; کامنت های آن مشابه کد قبلی است و موجود است .
    xor rsi, rsi
    mov r15 ,rdx
    mov rcx, r15
    for_iii:
         mov rdx,r15
         for_jjj:
             push rsi
             push rcx
             push rdx
             push rdx
             movss xmm0, [mat3+rsi*4]
             call write_float
             mov rdi, ' '
             call write_char
             pop rdx
             pop rdx
             pop rcx
             pop rsi
             inc rsi
             dec rdx
             jnz for_jjj
         push rsi
         push rcx
         push rdx
         push rdx
         mov rdi, 10
         call write_char
         pop rdx
         pop rdx
         pop rcx
         pop rsi
         dec rsi ; fix 512
         and si , 0xFE00
         add rsi, 0x0200
         loop for_iii
    add     rsp, 8
    ret

section .data align=64
                        ;  در این بخش هر 3 ماتریس را تعریف کرده و 0 میکنیم همه را 
mat1:
    dd 0x40000 DUP (0.0)
mat2:
    dd 0x40000 DUP (0.0)
mat3:
    dd 0x40000 DUP (0.0)


vec:
    ; Double --> dd
    dd 1.0 , 2.0 , 3.0 , 4.0
    ; qword
n:  dq 0
m:  dq 0
section .rodata
helloMessage: db "hello world", 10 , 0
