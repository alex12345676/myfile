; ==== KEYBOARD.ASM - ��楤��� ࠡ��� � ��������ன ====

;  === ���� ������ ������ ===
Pause proc
      xor ah,ah
      int 16h
      ret
Pause endp

; === ������ Insert ASCII 52h ===
Insert proc
      push es
      mov es,Seg_files    ;���� 䠩���
      mov fs,Seg_offset   ;���� ᬥ饭��

      mov di,Current_file
      mov di,fs:[di]
      xor byte ptr es:[di],2  ;�������㥬 ���� (�⬥祭� / ���⬥祭�)

      call Down_pressed ;�����㥬 ����⨥ ������ "��५�� ����".

      mov Out_fstat,0   ;�뢮���� ��� ��⪨ ��ப
      call Out_files

No_insert:
      pop es
      ret
Insert endp


; === ������ PgDown ASCII 51h ===
PgDown proc
;����஢��� �㤥� ����⨥ ������ "��५�� ����" �⮫쪮 ࠧ, ᪮�쪮 �뢮���
;䠩��� �� ��࠭.
      xor cx,cx
      mov cl,Number_files

Next_PgDn:
      push cx
      call Down_pressed ;�����㥬 ����⨥ "������ ����"
      pop cx
      dec cx
      or cx,cx
      jnz Next_PgDn

      ret
PgDown endp

; === ������ PgUp ASCII 49h ===
PgUp proc
      xor cx,cx
      mov cl,Number_files

Next_PgUp:
      push cx
      call Up_pressed
      pop cx
      loop Next_PgUp

      ret
PgUp endp

; === ������ Home ASCII 49h ===
K_Home proc
;�뢮���� �㤥� �� �� ���, ���� ��楤�� Up_pressed �� ��୥� �⠭�������
;䫠� ��७�� (Carry Flag)
Next_khome:
      call Up_pressed
      jnc Next_khome

      ret
K_Home endp

; === ������ End ASCII 49h ===
K_end proc
Next_kend:
      call Down_pressed
      jnc Next_kend

      ret
K_End endp


; === ������ ���� ===
;���짮��⥫� ����� ������� ����! ��ॢ���� ����� �� ᫥���騩 䠩�...
Down_pressed proc
      push es
      mov es,Seg_files    ;���� 䠩���
      mov fs,Seg_offset   ;���� ᬥ饭��

      mov di,Current_file
      add di,2
      mov di,fs:[di]
      cmp di,0FFFFh       ;�� ��᫥���� 䠩�?
      je No_down

;���. ����� ��⠭�������� ���� "⥪�騩 䠩�" ��� ᫥���饣� 䠩��
      or byte ptr es:[di],1 ;���. ����� ��⠭�������� ���� "⥪�騩 䠩�"

      mov Out_fstat,0
      mov di,Current_file
      mov di,fs:[di]    ;����騩 䠩� - ���뢠�� ���� ⥪�饣� 䠩��
      and byte ptr es:[di],11111110b

      add Current_file,2

;����塞, �㦭� �� �ப��稢��� 䠩��?
      mov ax,Current_file
      mov bx,Start_file
      sub ax,bx
      shr al,1
      cmp al,Number_files
      jb No_moved

;�㦭�! �.�. ���짮��⥫� ��襫 �� ᠬ��� ������� 䠩�� ����� ��࠭�.
      add Start_file,2
      mov Out_fstat,1 ;��⠭���� ���� ⮣�, �� �㦭� ����� ��ப�.

No_moved:
      call Out_files ;�뢮��� 䠩�� �� ��࠭
      clc
      pop es
      ret

No_down:
      pop es
      stc
      ret
Down_pressed endp

; === ������ ����� ===
;���짮��⥫� ����� ������� �����! ��ॢ���� ����� �� �।��騩 䠩�...
Up_pressed proc
      push es
      mov es,Seg_files    ;���� 䠩���
      mov fs,Seg_offset   ;���� ᬥ饭��

      mov Out_fstat,0
      mov di,Current_file
      mov di,fs:[di]
      or di,di       ;�� ᠬ� ���孨� 䠩�?
      jz No_up

;���. ����� ���뢠�� ���� "⥪�騩 䠩�" ��� ⥪�饣� 䠩��
      and byte ptr es:[di],11111110b

      sub Current_file,2
      mov di,Current_file
      mov di,fs:[di]

;��⠭�������� ���� "⥪�騩 䠩�" ��� �।��饣� 䠩��
      or byte ptr es:[di],1

;�஢�ઠ �� �ப���� ��࠭�
      mov ax,Current_file
      add ax,2
      cmp ax,Start_file
      jne No_moveu

;�㤥� �ப��稢���, �.�. ���짮��⥫� ���ࠫ�� ����஬ �� ���孥� ���
;��࠭�.
      mov Out_fstat,1
      sub Start_file,2

No_moveu:
      call Out_files ;�뢮��� 䠩�� �� ��࠭
      clc
      pop es
      ret

No_up:
      pop es
      stc
      ret
Up_pressed endp

; === ������ Enter ===
Enter_pressed proc
;���짮��⥫� ����� ������� Enter! ���塞 ⥪�騩 ��⠫��...
;!!! ����� ��������, �� �� ���� �� �஢��塞, ����� �� ���짮��⥫� Enter
;�� ��⠫��� ��� 䠩�� !!!
      push es
      push ds

      mov di,Current_dir
      mov cx,0FFFFh
      xor al,al
      repne scasb
      dec di

      mov si,Current_file
      mov fs,Seg_offset
      mov si,fs:[si]
      mov ds,Seg_files
      add si,5

;���室�� � ��⠫�� ���孥�� �஢��?
      cmp word ptr ds:[si],'..'
      jne Next_cdir

;�᫨ ⠪, � �饬 � ��ப� � ⥪�騬 ��⠫���� ���� ����� ᨬ��� "\"
;�ਬ��: �����⨬, ⥪�騩 ��⠫�� ⠪��:
;C:\ASSM\FILES\'ASCII 0'
;�㤥� �᪠�� ᨬ��� '\' ��᫥ M
      std
      dec di
      dec di
      mov al,'\'
      mov cx,0FFFFh
      repne scasb
      cld

;������塞 ��� ��᫥ ��ࢮ�� ������ ���������� ᨬ���� � ⥪�饬 ���.
      add di,2
      xor al,al
      stosb
;����稫�:
;C:\ASSM\'ASCII 0'
      jmp short Got_dp

;�᫨ ���室�� � �����⠫��, � ������塞 � ⥪�饬� ��� ��� ��⠫���,
;�� ���஬ ���짮��⥫� ����� "Enter".
;���ਬ��:
;C:\ASSM\FILES\'ASCII 0'
;��᫥ ���������� �㤥� ⠪:
;C:\ASSM\FILES\MYFILES\'ASCII 0'
Next_cdir:
      lodsb
      or al,al
      jz Got_dir
      stosb
      jmp short Next_cdir

Got_dir:
      mov ax,005Ch  ;'\'
      stosw

Got_dp:
      pop es
      pop ds

;���樠�����㥬 ��६����...
      mov Current_file,0
      mov Start_file,0
      mov Out_fstat,1

;�����뢠�� ���.
      call Draw_main_frame ;���㥬 �������� ࠬ��
      call Change_dir
      call Get_files  ;��⠥� ��⠫�� � ������
      call Out_files ;�뢮��� 䠩�� �� ��࠭

      ret
Enter_pressed endp
