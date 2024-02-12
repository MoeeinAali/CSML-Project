global      asm_main
extern      printf
extern      read_float ; xmm0
extern      read_uint ; rax
extern      write_float; xmm0
extern      write_uint; 
extern      write_char ; rdi

section .text
asm_main:
    xor rax,rax             ; rax = 0 
    sub rsp, 8              ; میخواهیم مضرب شانزده باشد
    
    call read_uint          ; تابع ورودی گرفتن زبان سی را فراخوانی میکنیم
                            ; این ورودی داخل رجیستر rax ذخیره میشود.
    mov qword[n], rax       ; محتویات رجیستر را داخل متغیر n میریزیم.
    
    call read_uint          ; همانند قسمت بالا، این بار n را ورودی میگیریم.
    mov qword[m], rax

    xor rsi , rsi           ; شمارنده ی حلقه را 0 میکنیم.
    mov rcx,qword[n]        ; شمارنده خارجی ترین حلقه را تعیین کرده و مقدار n را در آن میریزیم.

    ; ورودی گرفتن ماتریس اول
    for_i:
        mov rdx,qword[n]    ; شمارنده حلقه دوم را مقداردهی میکنیم.
        for_j:
                            ; چون تابع سی با این رجیستر ها کار دارد و مقدارشان تغییر میکند.
            push rsi        ; تعداد زوج بار پوش و پاپ میکنیم داخل استک، تا ورودی گرفتن دچار مشکل نشود.
            push rcx
            push rdx
            push rdx

            call read_float ; ورودی فلوت را داخل رجیستر xmm0 ذخیره میکند.
            
            pop rdx
            pop rdx
            pop rcx
            pop rsi

            movss [mat1+rsi*4], xmm0       ; مقدار ورودی را داخل مکان دلخواه ماتریس خود ذخیره میکنیم.
                                           ; چون فلوت 4 بایت جا میگیرد، ضربدر 4 میکنیم
            inc rsi                        ;  شمارنده حلقه اول
            dec rdx                        ; شمارنده حلقه دوم
            jnz for_j
        dec rsi                            ; فیکس کردن مقدار 512
        and si , 0xFE00                    ;  ???
        add rsi, 0x0200                    ;  ???
        loop for_i


    xor rsi,rsi                            ; شمارنده را صفر میکند
    mov rcx,qword[m]                       ; مقدار m را به شمارنده حلقه میریزد
    for_i2:
        mov rdx,qword[m]                   ; مقدار m را به شمارنده حلقه میریز.
        for_j2:
            push rsi                       ; تعداد زوج تا پوش و پاپ
            push rcx
            push rdx
            push rdx
            call read_float                ; تابع ورودی گرفتن فلوت در سی
            pop rdx
            pop rdx
            pop rcx
            pop rsi
            movss [mat2+rsi*4], xmm0       ; ذخیره سازی در ماتریس شماره 2 
                                           ; چون فلوت 4 بایت جا میگیرد، ضربدر 4 میکنیم
            inc rsi
            dec rdx
            jnz for_j2
        dec rsi ; fix 512
        and si , 0xFE00
        add rsi, 0x0200
        loop for_i2
    
    mov rdx,qword[n]
    sub rdx,qword[m]
                                            ; مقدار n-m را در یک رجیستر ذخیره میکنیم چون زیاد نیاز میشه
    inc rdx                                 ; مقدار این رجیستر را 0 میکنیم
                                            ; چون ایکسور کردن اینستراکشن پردازنده استف، سرعتش بیشتر است.
    xor rcx , rcx                           ; مقدار رجیستر rcx را صفر میکنیم.
    conv1:                                  ; i=rcx
        xor r10,r10
        conv2:                              ; j=r10 
            xor r11,r11
            conv3:                          ; k=r11
                xor r12,r12
                conv4:                      ; l=r12
                    mov r13 , r11           ; r13 = k
                    add r13 , rcx           ; r13 = i + k
                    shl r13 , 9             ; ضربدر 512
                    ; به جای ضرب کردن در توان های 2 ، از شیفت دادن استفاده میکنیم چون سریعتر است.
                    mov r14 , r10           ; r14 = j
                    add r14 , r12           ; r14 = j + l
                    add r13 , r14  
                                            ; xmm0 = mat1[i+k][j+l] 
                    movss xmm0 , [mat1 + r13*4]           
                    mov r13, r11            ; r13 = k
                    shl r13 , 9
                    ; به جای ضرب کردن در توان های 2 ، از شیفت دادن استفاده میکنیم چون سریعتر است.
                    add r13 , r12
                                            ; xmm1 = mat2[k][l]
                    movss xmm1 , [mat2 + r13*4] 
                    mulss xmm0,xmm1 ; xmm0 = mat1[i+k][j+l] * mat2[k][l]
                    mov r13 , rcx           ; r13 = i 
                    ; به جای ضرب کردن در توان های 2 ، از شیفت دادن استفاده میکنیم چون سریعتر است.
                    shl r13 , 9 
                    add r13 , r10
                    movss xmm1 , [mat3 + r13*4]
                    addss xmm1 , xmm0
                    movss [mat3 + r13*4], xmm1
                    ; حلقه 
                    inc r12
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

    ; صفر کردن رجیستر ها
    xor rsi, rsi
    mov r15 ,rdx
    mov rcx, r15
    ; خروجی دادن ماتریس 3
    for_iii:
         mov rdx,r15
         for_jjj:
         ; تعداد زوج تا پوش و پاپ
             push rsi
             push rcx
             push rdx
             push rdx
             ; ریختن مقدار در رجیستر xmm0
             movss xmm0, [mat3+rsi*4]
             ; استفاده از تابع اماده سی برای خروجی دادن
             call write_float
             ; قرار دادن فضای خالی بین اعداد
             mov rdi, ' '
             ; استفاده از تابع اماده سی برای خروجی دادن
             call write_char
             pop rdx
             pop rdx
             pop rcx
             pop rsi
             inc rsi
             dec rdx
             jnz for_jjj
        ; تعداد زوج تا پوش و پاپ
         push rsi
         push rcx
         push rdx
         push rdx
        ; عدد ده همان رفتن به خط بعد است
         mov rdi, 10
        ; استفاده از تابع اماده سی برای خروجی دادن
         call write_char
         pop rdx
         pop rdx
         pop rcx
         pop rsi
         ; حلقه
         dec rsi ; fix 512
         and si , 0xFE00
         add rsi, 0x0200
         loop for_iii
    add rsp, 8
    ret

; ماتریس ها
section .data align=64
mat1:
    dd 0x40000 DUP (0.0)
mat2:
    dd 0x40000 DUP (0.0)
mat3:
    dd 0x40000 DUP (0.0)

                                        ; dd: define double word
                                        ; dq: define qword
vec:
    dd 1.0 , 2.0 , 3.0 , 4.0
n:  dq 0
m:  dq 0
section .rodata
helloMessage: db "hello world", 10 , 0
