;  === DATA.ASM - ����� �����窨 ===

;               ==== ���������� ====

Num_attr db ? ;��६����� ��� ��ਡ�⮢

Num_DX dw ?

Video_page db 0 ;⥪��� �������࠭��

Pos_cursor dw ? ;������� ������ �����

Handle dw ? ;����� 䠩��

; --- ����� ��� ��楤��� Draw_frame ---
Height_X equ [bp+12] ;���� ࠬ��
Width_Y  equ [bp+10] ;�ਭ� ࠬ��
Attr     equ [bp+8]  ;��ਡ��� ࠬ��
Mess_up  equ [bp+6]  ;ᮮ�饭�� ������ ࠬ��
Mess_dn  equ [bp+4]  ;ᮮ�饭�� ����� ࠬ��
Mess_ins equ [bp+2]  ;ᮮ�饭�� ����� ࠬ��
Other    equ [bp]    ;���� ���䨣���� ����
