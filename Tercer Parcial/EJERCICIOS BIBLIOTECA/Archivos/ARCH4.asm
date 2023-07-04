.model small
.stack 64

.data
filename db "TEXTO.txt",0h
leido db 220 dup("$"), '$'
handle dw 0

.code
main proc
push dS
sub ax, ax
push ax
mov ax,@data
mov ds,ax
;MOV ES,AX

;Abre archivo
mov dx, offset filename
mov ah, 3dh
mov al, 00h
int 21h
jc salir
mov handle, ax


;leer archivo
mov bx,handle
mov cx,220
lea dx,leido
mov ah,3fh
int 21h


;Cierrra archivo
mov bx, handle
mov ah, 3eh
int 21h


;imprimir
mov dx,offset leido
mov  ah,9
int 21h

salir:
MOV AH, 04CH
INT 21H
MAIN ENDP

END MAIN