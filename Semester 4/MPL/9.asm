;TITLE: Overlap Block transfer with/without string instructions

section .data
    menumsg db 10,10,'***Overlap block transfer***',10
        db 10,'1.Block transfer without string'
        db 10,'2.Block transfer with string'
        db 10,'3.exit'
        db 10,'--> '
    menumsg_len equ $-menumsg
    wrmsg db 10,10,'Wrong choice entered',10,10
    wrmsg_len equ $-wrmsg
    bfrmsg db 10,'Block contents before transfer ->'
    bfrmsg_len equ $-bfrmsg
    afrmsg db 10,'Block contents after transfer  ->'
    afrmsg_len equ $-afrmsg
    srcmsg db 10,'Source block contents      : '
    srcmsg_len equ $-srcmsg
    dstmsg db 10,'Destination block contents : '
    dstmsg_len equ $-dstmsg
    sblock db 11h,12h,13h,14h,15h
    dblock times 3 db 0
    cnt equ 05
    spacechar db 20h
    lfmsg db 10,10

section .bss
    optionbuff resb 02
    dispbuff resb 02

%macro dispmsg 2
    mov eax,04
    mov ebx,01
    mov ecx,%1
    mov edx,%2
    int 80h
%endmacro

%macro accept 2
    mov eax,03
    mov ebx,00
    mov ecx,%1
    mov edx,%2
    int 80h
%endmacro

section .text
global _start
_start:
    dispmsg bfrmsg,bfrmsg_len
    call show
    menu:
        dispmsg menumsg,menumsg_len
        accept optionbuff,02
        cmp byte [optionbuff],'1'
        jne case2
        call wos                ;wos=With Out String
        jmp after

    case2:
        cmp byte [optionbuff],'2'
        jne case3
        call ws                 ;ws=with string
        jmp after

    case3:
        cmp byte [optionbuff],'3'
        je exit
        dispmsg wrmsg,wrmsg_len
        jmp menu

    after:
        dispmsg afrmsg,afrmsg_len
        call show
        dispmsg lfmsg,2

    exit:
        mov eax,01
        mov ebx,00
        int 80h

    dispblk:
        mov rcx,cnt

    rdisp:
        push rcx
        mov bl,[rsi]
        call disp8
        inc rsi
        dispmsg spacechar,1
        pop rcx
        loop rdisp
        ret

    wos:
        mov rsi,sblock + 04h
        mov rdi,dblock + 02h
        mov ecx,cnt
        x:
            mov al,[rsi]
            mov [rdi],al
            dec rsi
            dec rdi
            loop x
            ret

    ws:
        mov rsi,sblock + 04h
        mov rdi,dblock + 02h
        mov ecx,cnt
        std                     ;set direction flag
        rep movsb
        ret

    show:
        dispmsg srcmsg,srcmsg_len
        mov rsi,sblock
        call dispblk
        dispmsg dstmsg,dstmsg_len
        mov rsi,dblock-02h
        call dispblk
        ret

    disp8:
        mov ecx,02
        mov rdi,dispbuff
        dub1:
            rol bl,4
            mov al,bl
            and al,0fh
            cmp al,09h
            jbe x1
            add al,07
        x1:
            add al,30h
            mov [rdi],al
            inc rdi
            loop dub1
            dispmsg dispbuff,3
        ret


%if 0
---------------------- OUTPUT ----------------------

 ╭─proxzima@proxzima in ~/MPL took 70ms [ 62%]
 ╰─☣ asm temp.asm

Block contents before transfer ->
Source block contents      : 11 12 13 14 15 
Destination block contents : 14 15 00 00 00 

***Overlap block transfer***

1.Block transfer without string
2.Block transfer with string
3.exit
--> 1

Block contents after transfer  ->
Source block contents      : 11 12 13 11 12 
Destination block contents : 11 12 13 14 15 


 ╭─proxzima@proxzima in ~/MPL took 3s [ 62%]
 ╰─☣ asm temp.asm

Block contents before transfer ->
Source block contents      : 11 12 13 14 15 
Destination block contents : 14 15 00 00 00 

***Overlap block transfer***

1.Block transfer without string
2.Block transfer with string
3.exit
--> 2

Block contents after transfer  ->
Source block contents      : 11 12 13 11 12
Destination block contents : 11 12 13 14 15

%endif
