;        ===== DISPLAY.ASM - ��楤��� ࠡ��� � ��࠭�� ======

; === ���㥬 ࠬ�� ��������� ࠧ��� � 業�� ��࠭� ===
Draw_frame proc
     mov bp,sp
     add bp,2

     push es

     push 0B800h
     pop es

;________________________________________
;
; �ந������ ���᫥��� ��� ⮣�, �⮡�
; ࠧ������ ����� ࠬ�� � ��� ��࠭�.
;________________________________________

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
;_________________________________________

  ;���࠭�� ����祭�� ����, � ���ண� ��稭����� �뢮� ࠬ��
  ;�㦭� ��� ⮣�, �⮡� �뢮���� ᮮ�饭�� � ࠬ��.
     mov Num_DX,dx

     mov ax,Other  ;����稬 �������⥫��� ���ଠ��
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


;⥯��� � ��� �ਬ�୮ ⠪�� ����� �� ��࠭�:
;���������������������������ͻ
;_
;��� _, ⠬ � ��� DI � DH


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
     add di,160 ;��ॢ���� DI �� ᫥���騩 ��
     inc dh     ;��।������ DH �� 1
     pop cx     ;����⠭���� ���稪
     loop Next_lined ;᫥���騩 ��...

;⥯��� � ��� �ਬ�୮ ⠪�� ����� �� ��࠭�:
;���������������������������ͻ
;�                           �
;�                           �
;�                           �
;_ - ��� DI � DH


     mov al,'�' ;��� ࠬ��...
     stosw

     mov al,'�'
     mov cx,Width_Y
     rep stosw

     mov al,'�'
     stosw

;⥯��� � ��� �ਬ�୮ ⠪�� ����� �� ��࠭�:
;���������������������������ͻ
;�                           �
;�                           �
;�                           �
;���������������������������ͼ


;�뢮��� ᮮ�饭�� ����� ࠬ��
     mov si,Mess_dn   ;SI = ���� ��ப� ��� �뢮��
     call Draw_messfr ;�뢮��� ᮮ�饭�� ����� ࠬ��

;⥯��� � ��� �ਬ�୮ ⠪�� ����� �� ��࠭�:
;���������������������������ͻ
;�                           �
;�                           �
;�                           �
;����� ����饭�� ����� �����ͼ


;�뢮��� ᮮ�饭�� ������ ࠬ��
     mov dx,Num_DX
     push dx
     mov si,Mess_up
     call Draw_messfr

;⥯��� � ��� �ਬ�୮ ⠪�� ����� �� ��࠭�:
;����� ����饭�� ������ ����ͻ
;�                           �
;�                           �
;�                           �
;����� ����饭�� ����� �����ͼ


     pop dx
     add dx,0101h
     mov si,Mess_ins ;���� ᮮ�饭��, ���஥ �㤥� ����� ࠬ��
     or si,si        ;�᫨ ⠬ 0, � �� �뢮���...
     jz No_draw
     mov ah,[si]
     inc si
     call Print_string

;⥯��� � ��� �ਬ�୮ ⠪�� ����� �� ��࠭�:
;����� ����饭�� ������ ����ͻ
;�����饭�� �����           �
;�                           �
;�                           �
;����� ����饭�� ����� �����ͼ


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

;⥯��� � ��� �ਬ�୮ ⠪�� ����� �� ��࠭�:
;����� ����饭�� ������ ����ͻ
;�����饭�� �����           �
;���������� ����� ����������Ķ
;�                           �
;�                           �
;����� ����饭�� ����� �����ͼ


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
     push es ;���࠭�� ॣ�����...
     push di
     push ax

     push cs ;ES=CS
     pop es
     mov di,si ;DI=SI
     xor al,al ;AL=0
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

     pop ax    ;����⠭���� ॣ�����
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

    shl dl,1   ;㬭����� DL �� 2 (DL=DL*2)...

    mov al,dh  ;� AL - ��,
    mov bl,160 ;����� �㦭� 㬭����� �� 160
    mul bl     ;㬭�����: AL(��)*160; १���� --- � AX

    mov di,ax  ;१���� 㬭������ - � DI
    xor dh,dh  ;���㫨�㥬 DH
    add di,dx  ;⥯��� � DI ������� ���� � ���������.

    pop dx     ;����⠭�������� ॣ�����...
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
    pusha       ;���࠭�� ॣ�����...
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
    pusha   ;��� ���筮 ��࠭�� ॣ�����
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
    mov Pos_cursor,dx ;⥯��� ��� � DX (����� � ���!)

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
    pusha       ;���࠭�� �� ॣ�����
    push es
    push 0B800h ;ES ��⠭���� �� ᥣ���� ��ᯫ�� (��� �뢮�� �ᥫ)
    pop es

    xor cx,cx   ;CX - ���稪 ��� �祪 (�. ���� )

    finit       ;���樠������ ᮯ�����
;����ﭨ� ॣ���஢ ᮯ����� ��᫥ �믮������ �ਢ������� ��� �������
;(Empty - ����, Zero - ���, Valid - �����஥ �᫮):

;Empty ST(0)
;Empty ST(1)
;Empty ST(2)
;Empty ST(3)
;Empty ST(4)
;Empty ST(5)
;Empty ST(6)
;Empty ST(7)

;�஢���� ����室���� ����ன�� ᮯ����� ��� ���㣫���� �ᥫ...
    fstcw Dat    ;����稬 ॣ���� �ࠢ����� �����஬ � ��⠭���� RC
    or Dat,0C00h ;= or Dat,0000110000000000b
    fldcw Dat    ;����㧨� ��������� ॣ���� � ᮯ�����

    fldz         ;����㧨� ��� (��� �஢�ન) (LoaD Zero)
; Zero ST(0) 0
;Empty ST(1)
;Empty ST(2)
;Empty ST(3)
;Empty ST(4)
;Empty ST(5)
;Empty ST(6)
;Empty ST(7)

    fild Divider ;����㧨� ����⥫� (�.�. �᫮ 10)
;Valid ST(0) 10
; Zero ST(1) 0
;Empty ST(2)
;Empty ST(3)
;Empty ST(4)
;Empty ST(5)
;Empty ST(6)
;Empty ST(7)

    fild Number_dec ;����㧨� ������� (�뢮����� �᫮)
;Valid ST(0) 256   - �����⨬, ࠧ��� 䠩�� = 256 ����
;Valid ST(1) 10
; Zero ST(2) 0
;Empty ST(3)
;Empty ST(4)
;Empty ST(5)
;Empty ST(6)
;Empty ST(7)

    fst st(7)       ;�㡫��㥬 ������� ( ST(7)=ST(0) )
;Valid ST(0) 256
;Valid ST(1) 10
; Zero ST(2) 0
;Empty ST(3)
;Empty ST(4)
;Empty ST(5)
;Empty ST(6)
;Valid ST(7) 256

Next_sym:
    fprem            ;����� � ����砥� ���⮪ �� ������� � ST(0)
;Valid ST(0) 6       - ���� ࠧ 256/10=25 � 6 � ���⪥ (����� �� � ST(0))
;Valid ST(1) 10
; Zero ST(2) 0
;Empty ST(3)
;Empty ST(4)
;Empty ST(5)
;Empty ST(6)
;Valid ST(7) 256

    fistp Dat        ;���⮪ - � ��६����� Dat ( Dat=ST(0) )
;Valid ST(0) 10       - Dat=6. �⥪ "��������" �����, �.�. fistP, �.�.
; Zero ST(1) 0          ����㧨�� � ��६����� �᫮ �� ST(0) �
;Empty ST(2)            ��⠫�������� ��� �� ॣ���� ᮯ�����
;Empty ST(3)
;Empty ST(4)
;Empty ST(5)
;Valid ST(6) 256     ;���頥� ⠪�� ��������, �� 256 "�����㫮��" �����
;Empty ST(7)


;�뢮��� ���⮪ �� �������, ����� ����㦥� � Dat.
    mov al,byte ptr Dat
    add al,'0'      ;�뢮��� "��ଠ����" ���� (���⮪ �� ������� �� 10)
    call Print_sym
    dec dx          ;�뢥��. DX=DX-1 - ᫥���騩 ᨬ���

;�����⮢���� � �뢮�� ᫥���饣� ᨬ����...
    fld st(6)       ;ST(0)=ST(6)
;Valid ST(0) 256     - �⥪ "��⮫�����" ����
;Valid ST(1) 10
; Zero ST(2) 0
;Empty ST(3)
;Empty ST(4)
;Empty ST(5)
;Empty ST(6)
;Valid ST(7) 256

    fdiv st,st(1)   ;������ ����� ST(0) �� ST(1)
;Valid ST(0) 25.6    - ࠧ������ 256 �� 10. ������� - � ST(0)
;Valid ST(1) 10
; Zero ST(2) 0
;Empty ST(3)
;Empty ST(4)
;Empty ST(5)
;Empty ST(6)
;Valid ST(7) 256

    frndint         ;���㣫�� ����祭��� �᫮
;Valid ST(0) 25      - !!!����� �������� �� ���㣫����!!!
;Valid ST(1) 10
; Zero ST(2) 0
;Empty ST(3)
;Empty ST(4)
;Empty ST(5)
;Empty ST(6)
;Valid ST(7) 256

    fst st(7)       ;ST(7)=ST(0). �।��饥 �᫮ � ST(7) ���ࠥ���.
;Valid ST(0) 25
;Valid ST(1) 10
; Zero ST(2) 0
;Empty ST(3)
;Empty ST(4)
;Empty ST(5)
;Empty ST(6)
;Valid ST(7) 25

;������ �஢�ਬ, ࠢ�� �� ������� ���.
;�஢��� �㤥� �����⢫��� ��⥬ �ࠢ����� ST(0) � ST(2). ��� �⮣� ��,
;ᮡ�⢥���, � ����ᨫ� � ᠬ�� ��砫� ���.
    push ax
    fcom st(2)      ;ST(0)=ST(2)?
    fstsw ax        ;AX=���ﭨ� ᮯ�����
    and ax,100010100000000b ;���㫨�㥬 ���㦭� ��� ����
    cmp ax,100000000000000b ;ST(0)=ST(2)?
    pop ax
    je Finish_dec           ;�᫨ ࠢ��, � �� ��室 
;�᫨ �� ࠢ��, � � ST(0) �㤥� ����� 256 �᫮ 25, ��⥬ 2, ��⥬ 0...
;����� ���஡�� ᬮ��� �ਫ������ 䠩� !Coproc!.asm � TurboDebugger'e

;��窮� �㤥� �⤥���� �� ���� ��� 㤮��⢠. �ਬ��: 1.568
;��� �⮣� �� � ������� ���稪 (CX), ����� � �㤥� ����� ������⢮
;�뢥������ ���. �᫨ �� 㦥 �뢥��, � ������� �� ࠢ�� 0, � �⠢�� ���.
    inc cx          ;�����稬 ���稪 �祪
    cmp cx,3        ;�� ���� �뢥����?
    jne Next_sym    ;���� ���. �������� ��� 

    mov al,'.'      ;�뢮��� ࠧ����⥫� ࠧ�冷� (���)
    call Print_sym
    dec dx          ;DX �� ���� �����.
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
;������ ���, �� ���� �� PC/XT �뢮� �㤥� �����⢫�� ���������. �.�.
;�� ���� ᮢᥬ �� ����⭮... ������� ᪮���� ࠡ��� ������?
;�������, �� ⠪...
Out_dec endp
