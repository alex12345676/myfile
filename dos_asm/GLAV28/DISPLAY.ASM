;        ===== DISPLAY.ASM - ��楤��� ࠡ��� � ��࠭�� ======

; === ���㥬 ࠬ�� ��������� ࠧ��� � 業�� ��࠭� ===
Draw_frame proc
     mov bp,sp
     add bp,2

     push es

     push 0B800h
     pop es

;�ந������ ���᫥��� ��� ⮣�, �⮡� ࠧ������ ����� ࠬ�� � ��� ��࠭�.
     mov ax,Height_X
     shr al,1
     mov dh,11
     sub dh,al

     mov ax,Width_Y
     shr al,1
     mov dl,39
     sub dl,al
;������ DH ᮤ�ন� 業��஢���� �� (��ப�),
;� DL - ������� �⭮�⥫쭮 ࠧ��஢ ࠬ�� (���誠)...

  ;���࠭�� ����祭�� ����, � ���ண� ��稭����� �뢮� ࠬ��
     mov Num_DX,dx

     mov ax,Other
     test al,1     ;�㫥��� ��� ࠢ�� 0?
     jz No_copyscr ;�᫨ ⠪, � ����஢��� ��࠭ �� �㦭�.

     mov ax,Height_X ;���� �����㥬 � ������� 2 �������࠭���
     add ax,2
     call Copy_scr

No_copyscr:
     call Get_linear
     push di

     mov ax,Attr
     mov al,'�'
     stosw

     mov al,'�'
     mov cx,Width_Y
     rep stosw

     mov al,'�'  ;�����蠥� ���孨� ��
     stosw

     pop di      ;����⠭���� DI + 160 (᫥���騩 ��)
     add di,160
     inc dh

     mov cx,Height_X ;CX - ���-�� ����஢ (����)

Next_lined:
     push cx
     push di

     mov al,'�'
     stosw

     mov al,32
     mov cx,Width_Y
     rep stosw

     mov al,'�'
     stosw

     pop di
     add di,160
     inc dh
     pop cx
     loop Next_lined ;᫥���騩 ��...


     mov al,'�' ;��� ࠬ��...
     stosw

     mov al,'�'
     mov cx,Width_Y
     rep stosw

     mov al,'�'
     stosw


;�뢮��� ᮮ�饭�� ����� ࠬ��
     mov si,Mess_dn
     call Draw_messfr


;�뢮��� ᮮ�饭�� ������ ࠬ��
     mov dx,Num_DX
     push dx
     mov si,Mess_up
     call Draw_messfr

     pop dx
     add dx,0101h
     mov si,Mess_ins ;���� ᮮ�饭��, ���஥ �㤥� ����� ࠬ��
     or si,si        ;�᫨ ⠬ 0, � �� �뢮���...
     jz No_draw
     mov ah,[si]
     inc si
     call Print_string


No_draw:
     mov ax,Other ;����稬 �������⥫��� ���ଠ��
     test ax,10b
     jz No_upline

     mov dx,Num_dx
     add dh,2
     call Get_linear

     mov ax,Attr
     mov al,'�'
     mov cx,1
     stosw

     mov cx,Width_Y
     mov al,'�'
     rep stosw

     mov al,'�'
     stosw


No_upline:
     pop es
     ret 14
Draw_frame endp


; --- �뢮� ᮮ�饭��� ������ � ����� ࠬ�� ---
;�ᯮ����⥫쭠 ��楤��.
Draw_messfr proc
     or si,si ;SI = 0?..
     jz No_drawup ;⮣�� ��祣� �뢮���� �� ����, ��室��

     mov ah,[si]
     inc si
     call Count_strmid ;����塞 �।��� ��ப�

     call Print_string ;�뢮��� ��ப� �� ��࠭

No_drawup:
     ret
Draw_messfr endp

; === ����塞 �।��� ��ப� ===
;�室: CS:SI - ���� ��ப�
;��室: DL - �।��� ���� ��� �뢮�� ��ப�
Count_strmid proc
     push es
     push di
     push ax

     push cs
     pop es
     mov di,si
     xor al,al
     mov cx,0FFFFh ;᪮�쪮 ᨬ����� ��ॡ���� (���쬥� ���ᨬ�)...
     repne scasb ;�饬 0 � ��ப�

;SI=��砫� ��ப�
;DI=����� ��ப�+1
     sub di,si ;DI=DI-SI-1 = ����� ��ப�
     dec di

     shr di,1  ;����� ����� �� 2
     mov ax,40 ;����� ���-�� ᨬ����� � ��ப� �� 2 = 40
     sub ax,di ;AX=40-�������� ����� ��ப� = �㦭�� �������
     mov dl,al ;DL=�������, � ���ன ᫥��� �뢮���� ��ப�!

     pop ax
     pop di
     pop es
     ret
Count_strmid endp

; === �뢮� �⮪� �� ��࠭ ===
;�室: DS:SI - ���� ��ப� ��� �뢮��
;      DX - ���न���� ��� �뢮��
;      AH - ��ਡ��� ��ப�
;��室: ��祣�
Print_string proc
     call Get_linear

Next_symstr:
     lodsb          ;����砥� ��।��� ᨬ��� ��ப�
     or al,al       ;�� 0 (����� ��ப�?)
     jz Stop_outstr
     stosw
     jmp short Next_Symstr ;������騩 ᨬ���

Stop_outstr:
     ret
Print_string endp

; === �뢮� ᨬ���� �� ��࠭ ===
;�室: AL - ᨬ��� ��� �뢮��
;      AH - ��ਡ��� ᨬ����
;      DX - ���न���� ��� �뢮��
;��室: ��祣�
Print_sym proc
     call Get_linear ;����砥� ������� ���� ��ப�
     stosw           ;����ᨬ � ��������� ��ਡ�� (AH) � ᨬ��� (AL)
     ret
Print_sym endp

; === �८�ࠧ������ DH:DL � ������� ���ᨢ ===
Get_linear proc
    push ax    ;��࠭�� �� �ᯮ��㥬� ॣ�����
    push bx
    push dx

    shl dl,1   ;㬭����� DL �� 2.

    mov al,dh  ;� AL - ��,
    mov bl,160 ;����� �㦭� 㬭����� �� 160
    mul bl     ;㬭�����: AL(��)*160; १���� --- � AX

    mov di,ax  ;१���� 㬭������ - � DI
    xor dh,dh  ;���㫨�㥬 DH
    add di,dx  ;⥯��� � DI ������� ���� � ���������.

    pop dx
    pop bx
    pop ax
    ret
Get_linear endp

; === �஢��塞 �����०�� ������ � ⥪���� �������࠭��� ===
Check_video proc
     mov ah,0Fh
     int 10h
     cmp al,3  ;����⮢� ०��?
     je Ok_video

     mov ax,3
     int 10h

Ok_video:
     or bh,bh  ;�㫥��� ��࠭��?
     jz Ok_page

     mov ax,0500h
     int 10h

Ok_page:
     ret
Check_video endp

; === ���࠭�� ��࠭ ===
Save_mainscr proc
    pusha
    push es
    push ds

    push 0B800h ;� �㫥��� ��࠭���
    pop ds
    xor si,si

    push 0B900h ;� ����� ��࠭���...
    pop es
    xor di,di

    mov cx,2000 ;4000 ����
    rep movsw

    pop ds      ;����⠭���� ॣ�����.
    pop es
    popa
    ret
Save_mainscr endp

; === ����⠭���� ��࠭ ===
Restore_mainscr proc
    pusha
    push es
    push ds

    push 0B900h ;� ��ࢮ� �������࠭���
    pop ds
    xor si,si

    push 0B800h ;� �㫥���...
    pop es
    xor di,di

    mov cx,2000
    rep movsw

    pop ds
    pop es
    popa
    ret
Restore_mainscr endp

; === �����㥬 ���� ��࠭� ===
;�室: DH - ��, � ���ண� ����室��� ����� ����஢����
;      AL - ������⢮ �冷� ��� ����஢����
;��室: ��祣�
Copy_scr proc
    pusha
    push es
    push ds

    xor dl,dl
    call Get_linear

    mov bl,160  ;����稬 ������⢮ ����, ����� �㦭� ����஢���
    mul bl
    mov cx,ax   ;�� - � CX (�㤥� �ᯮ�짮���� CX ��� ���稪)

    mov si,di   ;DS:SI - ��㤠 �����㥬
    xor di,di   ;ES:SI - �㤠 �����㥬
    mov Num_copySI,si ;���࠭�� ����祭�� ���祭�� ��� ����⠭�������
    mov Num_copyDI,di
    mov Num_copyCX,cx
    push 0B800h
    pop ds
    push 0BA00h
    pop es
    rep movsb

    pop ds
    pop es
    popa
    ret

Num_copySI dw ?
Num_copyDI dw ?
Num_copyCX dw ?
Copy_scr endp

; === ����⠭�������� ���� ��࠭� ===
;�室: ��祣� (�� 㦥 ��࠭��� � ��६����� )
;��室: ��祣�
Restore_scr proc
    pusha
    push es
    push ds

    mov di,Num_copySI ;����稬 ��࠭���� ��楤�ன Copy_scr ���祭��
    mov si,Num_copyDI
    mov cx,Num_copyCX
    push 0BA00h
    pop ds
    push 0B800h
    pop es
    rep movsb  ;�����㥬 � 2-�� ��࠭��� � 0-��...

    pop ds
    pop es
    popa
    ret
Restore_scr endp

; === ���祬 �����, ��࠭�� �।���⥫쭮 ��� ⥪���� ������ ===
Hide_cursor proc
    mov ah,3          ;����砥� ⥪���� ������ �����
    mov bh,Video_page
    int 10h
    mov Pos_cursor,dx

    mov ah,2  ;��⠭���� ����� �� ����� ��࠭��� ��� �� �㫥���
    mov bh,1
    int 10h

    mov bh,Video_page ;���祬 ����� �� 0-�� �������࠭��
    mov dx,1900h
    int 10h

    ret
Hide_cursor endp

; === ����⠭���� ����� ===
Restore_cursor proc
    mov ah,2
    mov bh,Video_page ;�������࠭��
    mov dx,Pos_cursor ;��࠭����� ������
    int 10h           ;��⠭���� (����樮���㥬) �����
    ret
Restore_cursor endp

; === �뢮� �������� �ᥫ �� ��࠭ (ᮯ�����) ===
;�室: Number_dec - 64-� ��⭮� �᫮ ��� �뢮��
;      DX - ���� ��� �뢮��
;      AH - ��ਡ��� ��� �뢮��
;��室: ��祣�
Out_dec proc
    pusha
    push es
    push 0B800h
    pop es

    xor cx,cx   ;CX - ���稪 ��� �祪 (�. ���� )

    finit       ;���樠������ ᮯ�����

;�஢���� ����室���� ����ன�� ᮯ����� ��� ���㣫���� �ᥫ...
    fstcw Dat
    or Dat,0C00h
    fldcw Dat

    fldz

    fild Divider

    fild Number_dec

    fst st(7)       ;ST(7)=ST(0)

Next_sym:
    fprem            ;����� � ����砥� ���⮪ �� ������� � ST(0)

    fistp Dat        ;Dat=ST(0)

;�뢮��� ���⮪ �� �������, ����� ����㦥� � Dat.
    mov al,byte ptr Dat
    add al,'0'
    call Print_sym
    dec dx          ;�뢥��. DX=DX-1 - ᫥���騩 ᨬ���

;�����⮢���� � �뢮�� ᫥���饣� ᨬ����...
    fld st(6)       ;ST(0)=ST(6)

    fdiv st,st(1)   ;������ ����� ST(0) �� ST(1)

    frndint         ;���㣫�� ����祭��� �᫮

    fst st(7)       ;ST(7)=ST(0).

;������ �஢�ਬ, ࠢ�� �� ������� ���.
    push ax
    fcom st(2)      ;ST(0)=ST(2)?
    fstsw ax        ;AX=���ﭨ� ᮯ�����
    and ax,100010100000000b ;���㫨�㥬 ���㦭� ��� ����
    cmp ax,100000000000000b ;ST(0)=ST(2)?
    pop ax
    je Finish_dec           ;�᫨ ࠢ��, � �� ��室 

;��窮� �㤥� �⤥���� �� ���� ��� 㤮��⢠. �ਬ��: 1.568
    inc cx
    cmp cx,3        ;�� ���� �뢥����?
    jne Next_sym    ;���� ���. �������� ��� 

    mov al,'.'      ;�뢮��� ࠧ����⥫� ࠧ�冷� (���)
    call Print_sym
    dec dx
    xor cx,cx       ;���㫨� ���稪
    jmp short Next_sym ;�������� ��� 

Finish_dec:
    pop es
    popa
    ret

 Number_dec dq ?  ;64-� ࠧ�來�� ��६����� ��� �뢮������ �᫠
 Divider dw 10    ;����⥫� �ᥣ�� 10
 Dat dw ?         ;�६����� ��६����� ��� �࠭���� ���⪠ �� ������� �� 10

;������ ��楤�� �뢮��� �ᥣ� ���� ���� �᫮ �� ��࠭. �।�⠢���,
;᪮�쪮 ࠡ��� �த��뢠�� ������ �� ��⠭�� ���� �����ᥪ㭤, �뢮��
;�� ��࠭ ��᪮�쪮 䠩���?
;� ���� �஬� �뢮�� �ᥫ �� �� �஢��塞 ⥪�騩 ०�� ������ � ⥪����
;�������࠭���, �����㥬 ���짮��⥫�᪨� ��࠭, �⠥� � ��࠭塞
;⥪���� ������ �����, ��㥬 ࠬ��, �ந����� ����室��� �����,
;�⠥� ��⠫�� � ������ � �뢮��� ���� 䠩�� �� ��࠭ �� ������ ᨬ����...
;����� ⠪�� � ����, �� ��� ������� ���� �� ᮢᥬ ��⨬����.
Out_dec endp

; === �뤥�塞 ��ப� ��।������ 梥⮬ ===
;�� �室�: DX - ���न����
;          CX - ����� ��ப�
;          AH - ��ਡ��
Color_line proc
      pusha
      push es
      push 0B800h
      pop es
      call Get_linear
      inc di         ;����뢠�� �� �� ᨬ���, � �� ��ਡ��

Next_symbc:
      mov es:[di],ah ;����ᨬ ��ਡ��...
      inc di         ;������騩...
      inc di
      loop Next_symbc

      pop es
      popa
      ret
Color_line endp
