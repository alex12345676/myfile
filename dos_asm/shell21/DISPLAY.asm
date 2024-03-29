;        ===== DISPLAY.ASM - ��楤��� ࠡ��� � ��࠭�� ======

; === ���㥬 ࠬ�� ��������� ࠧ��� � 業�� ��࠭� ===
Draw_frame proc
     mov bp,sp ;BP = SP
     add bp,2  ;�����稬 BP �� 2, �.�. ���� ��� ���� - ������ �� ��楤���

     push es ;���࠭�� ES

     push 0B800h ;ES ������ 㪠�뢠�� �� ᥣ���� 0-�� �������࠭���
     pop es      ;�� �ࠡ�⠥� ⮫쪮 �� 286+ ������!!!

;________________________________________
;
; �ந������ ���᫥��� ��� ⮣�, �⮡�
; ࠧ������ ����� ࠬ�� � ��� ��࠭�.
;________________________________________

     mov ax,Height_X ;AX = ���� ��襩 ࠬ��
     shr al,1        ;����� ����� �� 2 ��⥬ ᬥ饭�� ��⮢ ��ࠢ� �� 1
     mov dh,11       ;��।���
     sub dh,al       ;DH (��ப�) ������!!!!!

     mov ax,Width_Y  ;AX = �ਭ� ��襩 ࠬ��
     shr al,1        ;����� �� �� 2
     mov dl,39       ;��।���
     sub dl,al       ;DL (�������) ������!!!!!
;������ DH ᮤ�ন� 業��஢���� �� (��ப�),
;� DL - ������� �⭮�⥫쭮 ࠧ��஢ ࠬ�� (���誠)...
;_________________________________________

  ;���࠭�� ����祭�� ����, � ���ண� ��稭����� �뢮� ࠬ��
  ;�㦭� ��� ⮣�, �⮡� �뢮���� ᮮ�饭�� � ࠬ��.
     mov Num_DX,dx

     mov ax,Other ;����稬 �������⥫��� ���ଠ��
     test al,1    ;�㫥��� ��� ࠢ�� 0?
     jz No_copyscr ;�᫨ ⠪, � ����஢��� ��࠭ �� �㦭�.

     mov ax,Height_X ;���� �����㥬 � ������� 2 �������࠭���
     add ax,2        ;+2, �.�. ���뢠�� '�ͻ' � '�ͼ'
     call Copy_scr

No_copyscr:
     call Get_linear ;����砥� ������� ���� � ��������� �� DX,
     push di         ;����� � ��࠭��...

     mov ax,Attr ;� AH - ��ਡ��� 梥� ࠬ��
     mov al,'�'  ;���孨� ���� 㣮�...
     stosw       ;����ᨬ ��� ���� (��ਡ�� � AH / ᨬ��� � AL)

     mov al,'�'  ;�����...
     mov cx,Width_Y ;� CX - �ਭ� ࠬ��
     rep stosw   ;���堫�...

     mov al,'�'  ;�����蠥� ���孨� ��
     stosw

     pop di      ;����⠭���� DI + 160 (᫥���騩 ��)
     add di,160
     inc dh      ;DH "���� � ����" � ⥪�騬 �冷�
                 ;�㦭� ��� ⮣�, �⮡� �뢥�� ����� ࠬ�� ᮮ�饭��

;⥯��� � ��� �ਬ�୮ ⠪�� ����� �� ��࠭�:
;���������������������������ͻ
;_
;��� _, ⠬ � ��� DI � DH


     mov cx,Height_X ;CX - ���-�� ����஢ (����)

Next_lined:
     push cx ;��࠭�� ���稪
     push di ;��࠭�� DI

     mov al,'�' ;�뢥�� ��� ᨬ���
     stosw

     mov al,32      ;32 - �஡�� (��� 20h ��� ' ')
     mov cx,Width_Y ;CX = �ਭ�
     rep stosw      ;����᫠��...

     mov al,'�' ;�����蠥� ��...
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
     ;��� ��祬 ��� �㦭� �뫮 ����ﭭ� 㢥��稢��� DH �� 1
     ;(�⮡� DH "諮 � ����" � DI)!

;⥯��� � ��� �ਬ�୮ ⠪�� ����� �� ��࠭�:
;���������������������������ͻ
;�                           �
;�                           �
;�                           �
;����� ����饭�� ����� �����ͼ


;�뢮��� ᮮ�饭�� ������ ࠬ��
     mov dx,Num_DX
     push dx
;��� ��� � ���� ���孥�� �鸞 �����������!
     mov si,Mess_up   ;SI = ���� ��ப� ��� �뢮��
     call Draw_messfr ;�뢮��� ᮮ�饭�� ������ ࠬ��

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
     call Print_string ;�뢮��� ��ப�...

;⥯��� � ��� �ਬ�୮ ⠪�� ����� �� ��࠭�:
;����� ����饭�� ������ ����ͻ
;�����饭�� �����           �
;�                           �
;�                           �
;����� ����饭�� ����� �����ͼ


No_draw:
     mov ax,Other ;����稬 �������⥫��� ���ଠ��
     test ax,10b  ;���� ��� ࠢ�� ���?
     jz No_upline ;�᫨ ⠪, � �� ���� No_upline

     mov dx,Num_dx ;����稬 ��砫쭮� ���祭�� ࠬ�� (���孨� ���� 㣮� - �)
     add dh,2      ;�ਡ���� 2 ��� ⮣�, �⮡� �뢥�� ����� (�. ����)
     call Get_linear

     mov ax,Attr
     mov al,'�'
     mov cx,1
     stosw

     mov cx,Width_Y ;� CX - �ਭ� ࠬ��
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
     pop es ;����⠭���� ES

     ret 14 ;��室��, ���⨢ �⥪ �� ��६����� � 14 ���� (7 ᫮�)
            ;��ᬮ���, � MAIN.ASM ��� �� ��뢠�� ������ ��楤���.
Draw_frame endp


; --- �뢮� ᮮ�饭��� ������ � ����� ࠬ�� ---
;�ᯮ����⥫쭠 ��楤��.
Draw_messfr proc
     or si,si ;SI = 0?..
     jz No_drawup ;⮣�� ��祣� �뢮���� �� ����, ��室��

     mov ah,[si]  ;���� ᨬ��� ��ப� - ��ਡ�� (�. DATA.ASM)
     inc si       ;������騩 ���� - ��砫� ��ப�
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
     ;0 ������! DI 㪠�뢠�� �� ᫥���騩 ᨬ��� �� �������� 0

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
     call Get_linear ;����砥� ������� ���� ��ப�

Next_symstr:
     lodsb          ;����砥� ��।��� ᨬ��� ��ப�
     or al,al       ;�� 0 (����� ��ப�?)
     jz Stop_outstr ;�� - ��室��...
     stosw          ;���� ����ᨬ � ��������� ��ਡ�� (AH) � ᨬ��� (AL)
     jmp short Next_Symstr ;������騩 ᨬ���

Stop_outstr:
     ret
Print_string endp

; === �८�ࠧ������ DH:DL � ������� ���ᨢ ===
Get_linear proc
    push ax    ;��࠭�� �� �ᯮ��㥬� ॣ�����
    push bx
    push dx

    shl dl,1   ;��⥬�⨪�: 㬭����� DL �� 2 (DL=DL*2)...

    mov al,dh  ;� AL - ��,
    mov bl,160 ;����� �㦭� 㬭����� �� 160
    mul bl     ;㬭�����: AL(��)*160; १���� --- � AX

    mov di,ax ;१���� 㬭������ - � DI
    xor dh,dh ;���㫨�㥬 DH
    add di,dx ;⥯��� � DI ������� ���� � ���������.

    pop dx    ;����⠭�������� ॣ�����...
    pop bx
    pop ax
    ret

Get_linear endp

; === �஢��塞 �����०�� ������ � ⥪���� �������࠭��� ===
Check_video proc
     mov ah,0Fh ; �㭪�� �஢�ન ०��� ������
     int 10h 
     cmp al,3  ;����⮢� ०��?
     je Ok_video

     mov ax,3 ; ��⠭���� ⥪�⮢��� ०���
     int 10h

Ok_video:
     or bh,bh  ;�㫥��� ��࠭��?
     jz Ok_page

     mov ax,0500h ; ��⠭���� ��࠭��� 0, �㭪�� 5
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
    xor si,si   ;�㫥���� ᨬ����

    push 0B900h ;� ����� ��࠭���...
    pop es
    xor di,di   ;�㫥��� ᨬ���...

    mov cx,2000 ;4000 ����
    rep movsw   ;������ �����.

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

    pop ds ;�祭� ���� � �����!!!
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

    xor dl,dl       ;���㫨� DL �� ��直� ��砩. ������ DH = ��, DL = 0
    call Get_linear ;����稬 ������� ����

    mov bl,160  ;����稬 ������⢮ ����, ����� �㦭� ����஢���
    mul bl
    mov cx,ax   ;�� - � CX (�㤥� �ᯮ�짮���� CX ��� ���稪)

    mov si,di   ;DS:SI - ��㤠 �����㥬
    xor di,di   ;ES:SI - �㤠 �����㥬
    mov Num_copySI,si ;���࠭�� ����祭�� ���祭�� ��� ����⠭�������
    mov Num_copyDI,di
    mov Num_copyCX,cx
    push 0B800h ;����ந� ᥣ����� ॣ�����
    pop ds
    push 0BA00h
    pop es
    rep movsb  ;�����㥬...

    pop ds     ;����⠭���� ॣ����� � �멤��...
    pop es
    popa
    ret        ;������ ���� ����� � ᠬ�� ��砫� 2-�� �������࠭���.

Num_copySI dw ?
Num_copyDI dw ?
Num_copyCX dw ?
Copy_scr endp

; === ����⠭�������� ���� ��࠭� ===
;�室: ��祣� (�� 㦥 ��࠭��� � ��६����� )
;��室: ��祣�
Restore_scr proc
    pusha      ;���࠭�� ॣ�����
    push es
    push ds

    mov di,Num_copySI ;����稬 ��࠭���� ��楤�ன Copy_scr ���祭��
    mov si,Num_copyDI
    mov cx,Num_copyCX
    push 0BA00h       ;����ந� ᥣ����� ॣ�����
    pop ds
    push 0B800h
    pop es
    rep movsb  ;�����㥬 � 2-�� ��࠭��� � 0-��...

    pop ds     ;����⠭���� ॣ�����
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
    mov bh,1  ;�㦭� ��� ⮣�, �᫨ ���짮��⥫� �����
    int 10h   ;��ᬮ����, �� ⠬ DOS ����ါ� (Ctrl+F5)

    mov bh,Video_page ;���祬 ����� �� 0-�� �������࠭��
    mov dx,1900h      ;(��⠭���� ��� �� 25 ��ப� (19h))
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
