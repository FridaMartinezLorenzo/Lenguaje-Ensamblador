;EJEMPLOS DEL USO DE LAS FUNCIONES PARA MANEJO DE ARCHIVOS TIPO HANDLE
;Ejemplo 1: Escribir un archivo en ASM
.model small
.stack 100h
.data
nombre db "nuevo.txt",00h
texto db "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
maneja dw ?
.code
algo proc near
mov ax,@data
mov ds,ax
mov ah,3ch ;SE CREA EL ARCHIVO
mov cx,00  ;MODO NORMAL
lea dx,nombre
int 21h
jc salir
mov maneja,ax ;AX TRAE EL VALOR DEL PUNTERO QUE DEVUELVE 3C
mov cx,10
nuevo: 
push cx
mov ah,40h  ;ESCRIBIMOS
mov bx,maneja ;EL APUNTADOR
mov cx,25 ;VOY A MANDAR A ESCRIBIR 25 CHAR
lea dx,texto
int 21h
pop cx
loop nuevo
mov ah,3eh ;CIERRE DE ARCH
mov bx,maneja
int 21h
salir: mov ax,4c00h
int 21h
endp
end algo