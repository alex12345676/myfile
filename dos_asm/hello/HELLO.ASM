.286
.model TINY	
		CSEG segment
		ASSUME CS:CSEG, DS:CSEG, ES:CSEG, SS:CSEG
 
				org 100h
			Begin:
			mov ah,9
	mov dx,offset Message
	int 21h
	ret
	Message db 'Hello, world!$'

	end Begin
