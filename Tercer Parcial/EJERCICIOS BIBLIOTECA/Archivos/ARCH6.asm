imprimir macro texto
mov ah,09
lea dx, texto
int 21h
endm
.model small
.stack
.data
narchivo db "ARCH.asm",00h
fid dw ?
fragmento db 10 dup(?),'$'
limpiar db 255 dup(?),'$'
msg1 db 10,13, "Error: No se pudo abrir el archivo. $"
msg2 db 10,13, "Error: No se pudo leer el archivo. $"
.code
main proc
mov ax,@data
mov ds,ax
mov es,ax
;Abrir para lectura
;fid=fopen( "texto.txt", "r" );
mov ah,3Dh ;C?digo para abrir archivo
mov al,00 ;Modo lectura
mov dx,offset narchivo ;Direcci?nn del nombre
int 21h ;Abrir, devuelve ident
jc error1 ;En caso de error, saltar
mov fid,ax ;guardar identificador
;Leer el archivo
;fread( &contenido, srtlen( contenido ), 1, fid );
LEER: mov ah,3Fh ;C?digo para leer archivo
mov bx,fid ;Identificador
mov dx,offset fragmento ;Direcci?n del bufer
mov cx,10 ;Tama?o deseado
int 21h ;Leer archivo
jc error2 ;Si hubo error, procesar
cmp ax, 0 ; si ax== 0 significa EOF
jz fin
imprimir fragmento
; grantizando que el buffer este limpio para no guardar basura
mov si, offset limpiar
mov di, offset fragmento
mov cx, 10
rep movsb
jmp leer
error1: imprimir msg1
jmp fin
error2: imprimir msg2
fin:
;Cerrar archivo
mov ah,3Eh
mov bx,fid
int 21h
salida:
mov ah,04ch
int 21h ;Salir sin indicar error
endp
end main