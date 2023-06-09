; Suma de dos n?meros de un solo digito BCD
.model small
.stack 64
.data

.code
PRINCI PROC FAR
 ;PROTOCOLO
 push ds
 sub ax,ax
 push ax
 MOV AX,@DATA
 MOV DS,AX
 
;pedir primer n?mero
mov ah,01h
int 21h
mov bl,al

;pedir segundo n?mero
mov ah,01h
int 21h
mov ah,00 ; limpiar parte alta de ah

add al,bl
;Ajuste ascii para la suma
aaa
or ax,3030h

mov bx,ax
;impresion parte alta
mov ah,02h
mov dl,bh
int 21h
;impresion parte baja
mov ah,02
mov dl,bl
int 21h

salir:
 mov ah,04ch
 int 21h
PRINCI ENDP
END PRINCI