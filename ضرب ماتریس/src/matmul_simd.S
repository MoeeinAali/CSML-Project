global      asm_main
extern      printf
extern      read_float ; xmm0
extern      read_uint ; rax
extern      write_float; xmm0
extern      write_uint; 
extern      write_char ; rdi

section .text

asm_main:
    xor rax,rax                 ; صفر کردن رجیستر
    sub rsp, 8                  ; برای مضرب 16 بودن cnt
    call read_uint              ; 
    mov qword[n], rax

; ورودی گرفتن ماتریس اول

    xor rsi,rsi                 ; صفر کردن رجیستر با سرعت بالا
    mov rcx,qword[n]            ; ریختن مقدار n در رجیستر
    for_i:                      ; سطر ماتریس ورودی اول
        mov rdx,qword[n]
        for_j:                  ; ستون ماتریس ورودی اول 

            push rsi            ; پوش و پاپ برای خراب نشدن رجیسترها
            push rcx
            push rdx
            push rdx
            call read_float     ; استفاده از تابع سی برای ورودی گرفتن 
            pop rdx
            pop rdx
            pop rcx
            pop rsi
                                        ; مقدار ورودی داخل xmm0 میرود.
            movss [mat1+rsi*4], xmm0    ; ریختن مقدار وروی داخل آرایه ی تعریف شده 
            inc rsi                     ; rsi += 1
            dec rdx                     ; rdi -= 1
            jnz for_j                   ; j = rdx
        dec rsi                         ;  کاهش تا رسیدن به 512 بار
        and si , 0xFE00
        add rsi, 0x0200                 ; 0x0200 --> 512
        loop for_i
 
; ورودی گرفتن ماتریس دوم
    xor rsi,rsi                         ; صفر کردن رجیستر
    mov rcx,qword[n]
    for_i2:                             ; حلقه اول
        mov rdx,qword[n]
        for_j2:                         ; حلقه دوم
            push rsi                    ; پوش و پاپ برای خراب نشدن مقدار رجیسترها
            push rcx
            push rdx
            push rdx
            call read_float             ; تابع سی برای خواندن ورودی
            pop rdx
            pop rdx
            pop rcx
            pop rsi
            movss [mat2+rsi*4], xmm0    ; ذخیره کردن مقدار موجود در رجیستر داخل آرایه ی تعریف شده
            inc rsi                     ; rsi += 1 
            dec rdx                     ; rdx -= 1 
            jnz for_j2                  ; loop 
        dec rsi ; fix 512
        and si , 0xFE00
        add rsi, 0x0200                 ; 0x0200 --> 512
        loop for_i2

    mov rcx, qword[n]
    xor rcx , rcx
    for1:
        xor r10 , r10
        for2:
            xor r11, r11
            for3:
            ; i = rcx / j = r11 ; k = r10 
                mov r12 , rcx 
                shl r12 , 9
                add r12 , r10 
                movups: xmm0 ,[mat1+4*r12]              ; xmm0 = {mat1[i][k],mat1[i][k],...} 4 ta
                mov r12 , r10
                shl r12 , 9 
                add r12 , r11
                movups xmm1 ,[mat2+4*r12]               ; xmm1 = {mat2[k][j],mat2[k][j+1],...} 4 ta
                mulps xmm0, xmm1 ; xmm0 = xmm1 . xmm0
                mov r12 , rcx
                shl r12 , 9 
                add r12 , r11
                movups xmm1 , [mat3+4*r12]
                addps xmm1 , xmm0
                movups [mat3+4*r12] , xmm1
                add r11 , 4
                cmp r11,qword[n]
                jl for3
            inc r10
            cmp r10,qword[n]
            jl for2
        inc rcx
        cmp rcx , qword[n]
        jl for1


    xor rsi, rsi
    mov rcx,qword[n]
    for_iii:
         mov rdx,qword[n]
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
         dec rsi                    ; fix 512
         and si , 0xFE00
         add rsi, 0x0200
         loop for_iii
    add     rsp, 8
    ret

; تعریف کردن 3 ماتریس داده شده
section .data align=64
mat1:
    dd 0x40000 DUP (0.0)      ; double
mat2:
    dd 0x40000 DUP (0.0)      ; double
mat3:
    dd 0x40000 DUP (0.0)      ; double


vec:
    dd 1.0 , 2.0 , 3.0 , 4.0 ; double
n:  dq 0                     ; qword

section .rodata
helloMessage: db "hello world", 10 , 0