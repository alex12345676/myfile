; ==== FILES.ASM - ��楤��� ࠡ��� � 䠩���� ====

; === ��⠥� 䠩�� � ⥪�饬 ��⠫��� ===

Get_files proc
      ;int 3
      push cs       ;���樠�����㥬 ES
      pop es
     ; push ds
	;mov ds, Seg_files
      mov fs,Seg_offset  ;FS - ᥣ���� ᬥ饭�� 䠩���
      xor di,di
      mov Current_offset,di
      mov fs:[di],di     ;����砥� ᬥ饭�� 䠩�� � ����� ������ ᬥ饭��
      mov bp,2           ;������騩 䠩� �㤥� ��������� �� ����� 2

      call Get_first  ;����砥� ���� 䠩�
      jc No_morefiles ;�᫨ ��� 䠩��� ����� - �� ��室
	cmp word ptr es:[Temp_files+1ah], 0 ; �᫨ ������ ࠢ�� 0 � �� ��୥��� ��४��� � �ய�᪠�� ��
	jne Next2 ; ����� ������ 䠩� � �஢���塞 �� ���
	call Get_other ; �饬 ᫥���騩 䠩�
	jc No_morefiles ; ��� ����� 䠩��� ��� �訡�� �⥭��
Next2:	
      cmp word ptr es:[Temp_files+1eh],002Eh ;���� 䠩� - '.'?
      je Next_file_   ;�᫨ ⠪, � �饬 ᫥���騩 䠩�...

      call Move_file  ;�᫨ ���, � ��७�ᨬ 䠩� � ������.

Next_file_:
      call Get_other  ;����砥� ᫥���騩 䠩�...
      jc No_morefiles ;����� �����稫��� - �� ��室.

      call Move_file  ;�᫨ ���, � ��७�ᨬ 䠩� � ������.
      jmp short Next_file_ ;�饬 ᫥���騩 䠩�...

No_morefiles:
      mov word ptr fs:[bp-2],0FFFFh ;�ਧ��� ���� ᯨ᪠ 䠩���
      mov es,Seg_files     ;���� 䠩� �ࠧ� ����祭��.
      mov byte ptr es:[0],1

      push cs
      pop es
    ;  pop ds

      mov Current_file,0  ;����騩 䠩� - 0 (�.�. ����)
      ret

All_files db '*.*',0
Get_files endp

; --- ��७�� ����� ���������� 䠩�� � ᥣ���� 䠩��� ��襩 �ணࠬ�� ---
Move_file proc
      push es
      mov es,Seg_files
      mov si,offset Temp_files+1eh  ;��� ���������� 䠩��
      mov di,Current_offset

      xor al,al          ;����ᨬ ����� 䠩��
      stosb
;����ᨬ ࠧ��� 䠩��
      mov eax,dword ptr [Temp_files+1ah]
      stosd
      ;mov eax,[si+20h]
      ;stosd

     ; mov si,1eh  ;SI - 㪠�뢠�� �� ᬥ饭�� ���������� 䠩�� (DS:SI)
;����ᨬ ��� ���������� 䠩�� � ���� ��襩 �ணࠬ��
Next_byte:
      lodsb
      stosb
      or al,al
      jnz Next_byte

Quit_move:
;����ᨬ ᬥ饭�� 䠩�� � ���� ������ ᬥ饭��
      mov Current_offset,di
      mov fs:[bp],di   ;FS:[BP] - 㪠�뢠�� �� ᫥���騩 䠩�
      inc bp
      inc bp
      pop es
      ret
Move_file endp

; === �뢮� ������ ���������� 䠩�� �� ��࠭ ===
Out_files proc
      mov bl,Number_files  ;BL 㪠�뢠�� �� ������⢮ �뢮����� 䠩���
      push ds
      push es
      push 0B800h
      pop es

      mov di,Start_file ;SI = ��砫��� ������ �� �뢮�� �� ��࠭
      mov ah,1Bh
      mov dx,0302h      ;��砫� ��� �뢮�� 䠩���

      mov fs,Seg_offset ;FS - ���� ������ ᬥ饭��
      mov ds,Seg_files  ;DS - ���� ������ 䠩���

Next_fileout:
      mov si,fs:[di] ;DS:SI - ᬥ饭�� ᫥���饣� 䠩��
      cmp si,0FFFFh  ;��᫥���� 䠩�?
      je Exit_files

      push si
      push di

      cmp cs:Out_fstat,0  ;������ �� ��ப� ��। �뢮��� 䠩��
      jz No_clear

;���⨬ ��ப� ��। �뢮��� 䠩��
      mov al,32
      mov cx,77
      call Get_linear
      mov cx,77
      rep stosw

No_clear:
      add si,5
      call Print_string     ;�뢮��� ��।��� 䠩�...
      pop di

;�뢮��� ࠧ��� 䠩��
      pop si
      call Print_fsize

;� ������ ��ਡ�⠬� �뢮���� (�⬥祭��, ⥪�騩...).
      mov bh,[si]
      call Get_status

      add dx,0100h ;���� 㢥��稢��� DH �� 1 ��� �뢮�� ᫥���饣� �����...
      inc di
      inc di
      dec bl       ;�����蠥� ������⢮ �뢮����� 䠩��� �� 1
      jnz short Next_fileout ;��� 0? ����� ����� �뢮���� �� �㦭�...

Exit_files:
      pop es
      pop ds
      ret

Number_files db 21 ;������⢮ �뢮����� 䠩��� �� ��࠭.
Start_file dw 0
Out_fstat db 0
Out_files endp

; === �஢��塞 ����� 䠩�� ===
Get_status proc
      pusha
      mov ah,1Bh   ;����� 䠩�...

      or bh,bh     ;���� �����-����� ��⪨?
      jz Quit_sts  ;��� - �� ��室 

      mov ah,30h
      cmp bh,1     ;�� ⥪�騩 䠩�?
      jz Quit_sts  ;�� - �� ��室 

      mov ah,1Eh
      cmp bh,2     ;�� �⬥祭�� 䠩�?
      jz Quit_sts  ;�� - �� ��室 

      mov ah,3Eh   ;����砥���, �� ⥪�騩 + �⬥祭��...

Quit_sts:
      mov dl,1     ;����ᮢ뢠�� ���...
      mov cx,78
      call Color_line
      popa
      ret
Get_status endp

; === �뢮��� ࠧ��� 䠩�� ===
Print_fsize proc
      pusha
      push ds

      mov eax,ds:[si+1] ;����稬 ����� ���� ࠧ��� 䠩��
    ;  mov ebx,ds:[si+5] ;����稬 ����� ����
	xor ebx, ebx
      push cs
      pop ds

      mov si,offset Number_dec ;����ᥬ ࠧ��� 䠩�� � ��६����� Number_dec
      mov dword ptr [si],eax   ;��楤�� Out_dec �㤥� �뢮���� �᫮,
     ; mov dword ptr [si+4],eax ;���஥ ��室���� ������ � �⮩ ��६�����.

      mov dl,50        ;DL 㪠�뢠�� �� �������
      mov ah,1Bh       ;AH ᮤ�ন� ��ਡ��� ��� �뢮������ �᫠
      call Out_dec     ;�뢮��� �᫮

      pop ds
      popa
      ret
Print_fsize endp

; === ���� ��ࢮ�� 䠩�� � ⥪�饬 ��⠫��� ===
Get_first proc
      ;mov ax,714Eh ;�㭪�� ���᪠ ��ࢮ�� 䠩��
	  mov ah,4eh
    ;  mov di,offset Temp_files ;DI ������ 㪠�뢠�� �� ����, �㤠 ����
    ;  xor si,si ;�����뢠���� ����� � ��������� 䠩�� (⨯� DTA).
      mov cx,0FFh ;�饬 �� �������� 䠩��. �� ��-� �த� ��ਡ�⮢ 䠩��
      mov dx,offset All_files ;��᪠ ���᪠
      int 21h
     ; mov Handle,ax ;���࠭�� ����� ����� ���᪠ 䠩��� ��� 714Fh
      ret
Get_first endp

; === ���� ᫥����� 䠩��� ===
Get_other proc
     ; mov bx,Handle ;����뢠�� ����� �����.
      ;mov ax,714Fh  ;�㭪�� ���᪠ ᫥����� 䠩���
	  mov ah,4fh
     ; xor si,si
   ;   mov di,offset Temp_files ;DI ������ 㪠�뢠�� �� ����, �㤠 ����
      int 21h       ;�����뢠���� ����� � ��������� 䠩�� (⨯� DTA).
      ret
Get_other endp
