; ==== FILES.ASM - ��楤��� ࠡ��� � 䠩���� ====

; === ��⠥� 䠩�� � ⥪�饬 ��⠫��� ===
; === ��⠥� 䠩�� � ⥪�饬 ��⠫��� ===
Get_files proc
	;int 3
      push es
      mov es,Seg_files

      call Get_first  ;����砥� ���� 䠩�
      jc No_morefiles ;�᫨ ��� 䠩��� ����� - �� ��室

      cmp word ptr es:[1eh],002Eh ;���� 䠩� - '.'?
      je Next_file    ;�᫨ ⠪, � �饬 ᫥���騩 䠩�...

      call Move_file  ;�᫨ ���, � ��७�ᨬ 䠩� � ������.

Next_file:
      call Get_other  ;����砥� ᫥���騩 䠩�...
      jc No_morefiles ;����� �����稫��� - �� ��室.

      call Move_file  ;�᫨ ���, � ��७�ᨬ 䠩� � ������.
      jmp short Next_file ;�饬 ᫥���騩 䠩�...

No_morefiles:
      pop es
      ret

All_files db '*.*',0
DTA equ 80h ;�� �㦥� <--- �� ��� ����� �� �㦥�!
Seg_files dw ? ;�������� ���� ���� 䠩���
Current_offset dw 500
Get_files endp

; === ���� ��ࢮ�� 䠩�� � ⥪�饬 ��⠫��� ===
Get_first proc
;����� ����� ���⠢��� �������� int 3 � � ����� �⫠��� ���������
;�⫠�稪� �믮����� �ணࠬ�� �� ���� (Run). ����� �� int 3 �⫠�稪
;��易⥫쭮 ��⠭������, �� �������� ��� �஠������஢��� ࠡ���
;�ਢ������� ���� ��ப. ���஡��!

;     int 3        ;<=== ��� �窠 ��⠭��� ��� �⫠�稪� (BreakPoint)

    ;  mov ax,714Eh ;�㭪�� ���᪠ ��ࢮ�� 䠩�� -- ������ �㭪�� �� ࠡ�⠥� � ��ᡮ��
     ; xor di,di ;DI ������ 㪠�뢠�� �� ����, �㤠 ���� �����뢠����
     ; xor si,si ;����� � ��������� 䠩�� (⨯� DTA). SI ���� ��⠥��� ⠩���!
     mov ah, 4eh ; ���� �㭪�� ���᪠ 䠩�� ��ࢮ�� १���� � dta
      mov cx,0FFh ;�饬 �� �������� 䠩��. �� ��-� �த� ��ਡ�⮢ 䠩��
      mov dx,offset All_files ;��᪠ ���᪠
      int 21h
     ; mov Handle,ax ;���࠭�� ����� ����� ���᪠ 䠩��� ��� 714Fh -- �� ࠡ�⠥� � ��ᡮ��
      ret
Get_first endp

; === ���� ᫥����� 䠩��� ===
Get_other proc
   ;   mov bx,Handle ;����뢠�� ����� �����. �� �� ࠡ�⠥� � dosbox
   ;   mov ax,714Fh  ;�㭪�� ���᪠ ᫥����� 䠩���
    ;  xor si,si
   ;   xor di,di     ;DI ������ 㪠�뢠�� �� ����, �㤠 ���� �����뢠����
      mov ah, 4fh  ; ���� �㭪�� ���᪠ ᫥���饣� 䠩��, १���� � DTA
      int 21h       ;����� � ��������� 䠩�� (⨯� DTA).
      ret
Get_other endp

; --- ��७�� ����� ���������� 䠩�� � ᥣ���� 䠩��� ��襩 �ணࠬ�� ---
Move_file proc
;���������� ����� ⠪�� ��⠭����� ��� ��⠭���, ��� �������� ��� 
      push ds
      mov di,Current_offset ;����饥 ᢮������ ᬥ饭��
      mov ds,Seg_files
      mov si,001Eh     ;SI=��� ���������� 䠩��

Next_fbyte:
      lodsb          ;����砥� ���� ᨬ��� ����� 䠩��
      stosb          ;���࠭�� ᨬ��� � �����
      or al,al       ;�� ��� (����� �����)?
      jnz Next_fbyte ;������騩 ᨬ���...

;����ᨬ ࠧ��� 䠩��
      mov si,1ah     ;�� �⮬� ᬥ饭�� �㤥� ࠧ��� 䠩�� (4 ᫮��)
      lodsd
      stosd
  ;    lodsd
   ;   stosd

      pop ds
      mov Current_offset,di ;���࠭�� ⥪�饥 ᬥ饭��
      xor al,al
      stosb          ;����襬 �� ���� ���...
      ret

;�⠪, � ����, �� ����� 㪠�뢠�� DI ��। �맮���
;714Eh � 714Fh, ���������:
;* �� ᬥ饭�� 2Ch - ��� ���������� 䠩��
;* �� ᬥ饭�� 1Ch - ࠧ��� 䠩�� (4 ᫮�� = 8 ����)
;* � ⠪�� ������ ��㣮�. ���ᬮ�ਬ �����...
Move_file endp

; === �뢮� �������� 䠩��� �� ��࠭ ===
Out_files proc
      mov bl,Number_files  ;BL 㪠�뢠�� �� ������⢮ �뢮����� 䠩���
      push ds
      push es
      push 0B800h
      pop es

      mov si,Start_file ;SI = ��砫��� ������ �� �뢮�� �� ��࠭
      mov ah,1Bh        ;��ਡ���
      mov dx,0302h      ;��砫� ��� �뢮�� 䠩���
      mov ds,Seg_files  ;DS=ᥣ���� ��������� 䠩��� � �����

Next_fileout:
      call Print_string ;�뢮��� ��।��� 䠩�

      call Print_fsize

      add si,4
      cmp byte ptr [si],0 ;������騩 ����=0? �����, �� �� ��᫥��� 䠩�...
      jz Exit_files       ;����� ��室��.

      add dx,0100h ;���� 㢥��稢��� DH �� 1 ��� �뢮�� ᫥���饣� �����...
      dec bl       ;�����蠥� ������⢮ �뢮����� 䠩��� �� 1
      jnz short Next_fileout ;��� 0? ����� ����� �뢮���� �� �㦭�...

Exit_files:
      pop es
      pop ds
      ret

Number_files db 21 ;������⢮ �뢮����� 䠩��� �� ��࠭.
Start_file dw 500  ;���� (ᬥ饭��) ���⮢��� 䠩�� ��� �뢮�� �� ��࠭
                   ;���� 500 ���� �⢮����� ��� �㭪権 714Eh � 714Fh, �㤠
                   ;��� ���� ������� ���ଠ�� � ��������� 䠩��.
                   ;��-� �த� DTA, ⮫쪮 "��ᮢ६�����"...
Out_files endp

; === �뢮��� ࠧ��� 䠩�� ===
Print_fsize proc
      pusha
      push ds

      mov eax,ds:[si]   ;����稬 ����� ���� ࠧ��� 䠩��
     ; mov ebx,ds:[si+4] ;����稬 ����� ����
	xor ebx, ebx
      push cs
      pop ds

;����� ��������, �� ��६����� Number_dec - 64-� ࠧ�來��, � ॣ����
;EAX - 32-�. ��� ⮣�, �⮡� ����㧨�� ��६����� ��������� �����������
;��� ࠧ� ������ EAX (��� EBX � �.�.)!
      mov si,offset Number_dec ;����ᥬ ࠧ��� 䠩�� � ��६����� Number_dec
      mov dword ptr [si],eax   ;��楤�� Out_dec �㤥� �뢮���� �᫮,
      mov dword ptr [si+4],ebx ;���஥ ��室���� ������ � �⮩ ��६�����.

      mov dl,50        ;DL 㪠�뢠�� �� �������
      mov ah,1Bh       ;AH ᮤ�ন� ��ਡ��� ��� �뢮������ �᫠
      call Out_dec     ;�뢮��� �᫮

      pop ds
      popa
      ret
Print_fsize endp