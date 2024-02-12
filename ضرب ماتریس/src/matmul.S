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

; محاسبه و ذخیره سازی در ماتریس سوم
    mov rcx, qword[n]               ; rcx = i
    for1:
                                    ; r10 = k
        mov r10, qword[n]
        for2:
                                    ; r11 = j
            mov r11, qword[n]
            for3:
                mov r12 , rcx 
                dec r12
                shl r12 , 9
                add r12 , r10 
                dec r12 
                movss xmm0 ,[mat1+4*r12]            ; xmm0 = mat1[i][k]
                mov r12 , r10                       ; r12 = k
                dec r12                             ; r12 = k - 1 
                shl r12 , 9                         ; ضرب در 512
                add r12 , r11                       ; r12 = j
                dec r12                             ; r12 = j -1 
                mulss xmm0 , [mat2+4*r12]           ; xmm0 = mat1[i][k] * mat2[k][j]
                mov r12 , rcx                       ; r12 = i
                dec r12                             ; r12 = i - 1
                shl r12 , 9                         ; r12 *= 512
                add r12 , r11                       ; r12 = 512(i-1) + j 
                dec r12                             ; r12 = 512(i-1) + j - 1 
                addss xmm0 , [mat3+4*r12]           ; xmm0 = mat1[i][k] * mat2[k][j] + mat3[i][j]
                movss [mat3+4*r12] , xmm0           ; ذخیره سازی در ماتریس سوم
                dec r11
                jnz for3
            dec r10
            jnz for2
        loop for1

    xor rsi, rsi                                     ; rsi = 0 
    mov rcx,qword[n]                                 ; rcx = n
    for_iii:
         mov rdx,qword[n]
         for_jjj:
             push rsi                                ; پوش و پاپ برای جلوگیری از خراب شدن مقدار رجیستر ها
             push rcx
             push rdx
             push rdx
             movss xmm0, [mat3+rsi*4]                ; خروجی دادن با استفاده از توابع سی
             call write_float
             mov rdi, ' '
             call write_char
             pop rdx
             pop rdx
             pop rcx
             pop rsi    
             inc rsi                                  ; rsi += 1
             dec rdx                                  ; rdx -= 1 
             jnz for_jjj                              
         push rsi
         push rcx
         push rdx
         push rdx
         mov rdi, 10                                   ; رفتن به خط بعد 
         call write_char
         pop rdx
         pop rdx
         pop rcx
         pop rsi
         dec rsi                                        ; fix 512
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