
;           TEST.ASM - �������⥫쭠� �ணࠬ�� � ����� � 29

; (�) ����᪨� �ࠢ� �� 䠩��-�ਫ������ �ਭ������� ����� �����
; "��ᥬ����? �� ����! �稬�� �ணࠬ��஢��� ��� MS-DOS"
; ����: ����譨��� ���� ����ᠭ�஢�� (e-mail: Assembler@Kalashnikoff.ru)
;	 http://www.Kalashnikoff.ru

;   === ��砫� �ணࠬ��: ===
cseg segment
assume cs:cseg, ds:cseg, ss:cseg, es:cseg
org 100h

Begin:
       mov ah,9
       mov dx,offset Mess_start
       int 21h

       mov ah,2       ;�㭪�� �뢮�� ������ ᨬ���� �� ��࠭

       mov si,80h     ;���� ��������� ��ப�
       lodsb
       or al,al
       lodsb
       jnz Next_char

       mov ah,9
       mov dx,offset Error_String
       int 21h
       ret

Next_char:
       lodsb          ;����砥� ���� ᨬ���
       cmp al,0Dh     ;�� 0Dh?
       jz End_param   ;�� - ⮣�� ���� ��ࠬ��� �����稫�� 

Next_param:
       mov dl,al      ;���, �� ���. ����� �뢮��� ����祭�� ᨬ���...
       int 21h        ;...�� ��࠭ � ⥪���� ������ �����
       jmp short Next_char ; ����㯠�� � ᫥���饬� ᨬ����... 

End_param:
       int 20h

Mess_start db '����饭�� �� Test.com: ��������� ��ப�: $'
Error_String db '�� �������!',0Ah,0Dh,0Ah,0Ah,'$'

cseg ends
end Begin
