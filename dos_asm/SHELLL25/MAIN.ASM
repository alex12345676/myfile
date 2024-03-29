;                  === MAIN.ASM - �������� ��楤�� ===

Main_proc proc

      call Hide_cursor ;���祬 �����

      call Prepare_all

      call Save_mainscr ;��࠭�� ᮤ�ন��� ��࠭�...

      push 23     ;���� ࠬ�� ��� '�ͻ' � '�ͼ'
      push 78     ;�ਭ� ࠬ�� (�.�. �� ���� ��࠭) ��� '�' � '�'
      push 1F00h  ;梥� - ᢥ⫮-���� �� ᨭ�� 䮭�
      push offset Mess_head ;������� ������ ࠬ�� (�᫨ 0, � �� �뢮����)
      push offset Mess_down ;������� ����� ࠬ�� (�᫨ 0, � �� �뢮����)
      push 0      ;ᮮ�饭�� ����� ࠬ�� (�᫨ 0, � �� �뢮����)
      push 10b    ;��࠭ �� ����஢���, �� �뢥�� ������ �����.
      call Draw_frame ;���㥬 ࠬ�� �� ���� ��࠭

      call Get_files

      call Out_files

Next_key:
      call Pause ;����� ������!!!
      or al,al
      jz Ext_code  ;�� ���७�� ASCII-��� ������? �� - �஢��塞 ���. 

      cmp al,27    ;������ ESC?
      jne Next_key ;��� - ���� �����... 

      call Quit_prog ;���⢥न� ����७�� ���짮��⥫� ��� �� �ணࠬ��.
      jnc Next_key   ;���짮��⥫� ���⢥न� ��室? ���? ����� �� Next_key 

;��, ���⢥न� (� ����!). ����� ��室��.
      call Restore_mainscr ;����⠭���� ᮤ�ন��� ��࠭�
      call Restore_cursor  ;����⠭���� ������ �����

      ret ;��室�� �� ��楤��� MAIN.ASM, � ��⥬ �ࠧ� � DOS!

Ext_code:
      cmp ah,62h         ;������ Ctrl+F5?
      je User_screenl    ;�� - �����뢠�� ��࠭ ���짮��⥫� .
      jmp short Next_key ;��� - ���� ����� ������� 

User_screenl:
      mov ax,0501h ;�����뢠�� ���짮��⥫� 1 �������࠭���.
      int 10h
      call Pause   ;���� �� �� ���, ���� ���짮��⥫� �� ��������...

      mov ax,0500h ;����� �� �㫥��� ��⠭��������.
      int 10h
      jmp short Next_key ;���� �����... 
Main_proc endp

; === ��⮢�� �� ����室���� ��� ࠡ��� ===
Prepare_all proc
      
      call Prepare_memory
      call Set_DTA

      ret
Prepare_all endp

;--- ������� ������ ---
Prepare_memory proc
      mov bx,offset Finish
      shr bx,4
      inc bx
      mov ah,4Ah
      int 21h

      mov ah,48h
      mov bx,1000h
      int 21h

      mov Seg_files,ax

      ret
Prepare_memory endp

; --- ��⠭���� DTA ---
Set_DTA proc
;	int 3
	push ds
	mov ds, Seg_files
    mov ah,1Ah
    xor dx,dx
    int 21h
    pop ds
    ret
Set_DTA endp

; === ��室�� �� �ணࠬ��? ===
Quit_prog proc
      push 1     ;���� ࠬ��
      push offset Mess_quitl ;�ਭ� ࠬ��
      push 4F00h ;梥� - ᢥ⫮-���� �� ᨭ�� 䮭�
      push offset Mess_qup   ;������� ������ ࠬ�� (�᫨ 0, � �� �뢮����)
      push 0     ;������� ����� ࠬ�� (�᫨ 0, � �� �뢮����)
      push offset Mess_quit  ;ᮮ�饭�� ����� ࠬ��
      push 01b   ;����஢��� ��࠭, �� �� �뢮���� ������ �����
      call Draw_frame ;���㥬 ࠬ��

      call Pause
      call Restore_scr ;����⠭���� ��࠭㭭�� ���� ��࠭�.

      cmp al,'Y'       ;������ 'Y' / 'y' / Enter (13)?
      je Yes_quit      ;��! 
      cmp al,'y'
      je Yes_quit
      cmp al,13
      je Yes_quit

      clc  ;�⠢�� �����, �� ������ ����� ������� (��ᨬ 䫠� ��७��).
      ret

Yes_quit:
      stc  ;��⠭���� 䫠� ��७�� (������ 'Y', ����� ��室��)...
      ret
Quit_prog endp
