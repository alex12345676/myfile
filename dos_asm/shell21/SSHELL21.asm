;              Sshell21.ASM - �ணࠬ�� � ����� � 21

; (�) ����᪨� �ࠢ� �� 䠩��-�ਫ������ �ਭ������� ����� �����
; "��ᥬ����? �� ����! �稬�� �ணࠬ��஢��� ��� MS-DOS"
; ����: ����譨��� ���� ����ᠭ�஢�� (e-mail: Assembler@Kalashnikoff.ru)
;	 http://www.Kalashnikoff.ru

; --- ��ᥬ���஢���� (����祭�� *.com 䠩��) ---
;�� �ᯮ�짮����� MASM 6.11 - 6.13:
;ML.EXE sshell21.asm /AT

;�� �ᯮ�짮����� TASM:
;TASM.EXE sshell21.asm
;TLINK.EXE sshell21.obj /t/x


.286
CSEG segment
assume cs:CSEG, ds:CSEG, es:CSEG, ss:CSEG
org 100h

Start:
        jmp Begin

; ======= ��楤��� =========
; ��������
include main.asm

; ����� � ��ᯫ���
include display.asm

; ����� � 䠩����
include files.asm

; ����� � ��������ன
include keyboard.asm

; ����饭��
include messages.asm

; ��६����
include data.asm

; ��砫� �ணࠬ��
Begin:
        call Check_video ;�஢�ਬ �����०�� � ⥪���� ��࠭���

        mov ah,9 ; �㭪�� �뢮�� � ���᮫�
        mov dx,offset Mess_about ; ᬥ饭�� ds:dx �� ⥪�� ����稢������� $
        int 21h ;�뢥��� ᮮ�饭�� � �ਢ���⢨��

        call Main_proc ;��뢥� �������� ��楤���

; � �� ������� ⮫�� � ⮬ ��砥, �᫨ ���짮��⥫� �訫 ��� � DOS
        int 20h ; �����襭�� ᮬ �ਫ������

Finish equ $ ; ��⪠ ���� 䠩�� ��� �뤥����� �����

CSEG ends ; ����� ᥣ����
end Start ; ����� �ਫ������
