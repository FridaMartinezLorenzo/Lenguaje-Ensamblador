imprimir macro texto
mov ah,09
lea dx, texto
int 21h
endm
.model small

.stack 100

.data
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;               Archivo
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
narchivo db "EXISTE.TXT",00h
fid dw ?
contenido db 10,"NUEVA LINEA QUE SE CONCATENA EN AL ARCHIVO @...$"
msg1 db 10,13, "Error: No se pudo abrir el archivo. $"
msg2 db 10,13, "Error: No se puedo escribir el archivo. $"
bandera_error db 0
;   JUGADOR
 CADENA DB 40,0, 40 DUP('20H'),'$'
 SALTO DB 13,10,"$"
 
.code
main proc
mov ax,@data
mov ds,ax
MOV CX,10
REGRESA:
PUSH CX
call abrir_file_escribir ; abre archivo
call posicionar_ap ;POSICIONA EL PUNTERO AL FINAL DEL ARCHIVO
;Escribir en el archivo
;fwrite( &contenido, srtlen( contenido ), 1, fid );
mov ah,40h ;C?digo para escribir en archivo.
mov bx,fid ;Identificador.
mov cx,47 ;Tama?o de datos.
mov dx,offset contenido ;Direcci?n buffer.
int 21h ;Escribir.
jc error2 ;Saltar en caso de error.
JMP FIN

error1: imprimir msg1
        ret
jmp fin
error2: 
    imprimir msg2
    ret
fin:
CALL cerrar_file
POP CX
LOOP REGRESA

salida:
mov ah,04ch
int 21h ;Salir sin indicar error
ret
MAIN endp


abrir_file_escribir proc
;Abrir para lectura
;fid=fopen( "texto.txt", "W" );
mov ah,3Dh ;C?digo para abrir archivo
mov al,01 ;Modo ESCRITURA
mov dx,offset narchivo ;Direcci?n del nombre
int 21h ;Abrir, devuelve identificador del archivo
jc error_open_w ;En caso de error, saltar
mov fid,ax ;guardar identificador
jmp fin_open_w
    error_open_w:
        mov bandera_error,1
fin_open_w:
RET
abrir_file_escribir endp

posicionar_ap proc ;posiciona al final del archivo a fin de no reescribir
mov bx,FID
mov cx,0
mov ah,42h
mov al,02h
int 21h
RET
posicionar_ap endp

cerrar_file proc
;Cerrar archivo
mov ah,3Eh
mov bx,fid
int 21h
RET
cerrar_file endp

Crear_Abrir_Arch proc
;Crear y abrir
;fid=fopen( "texto.txt", "w" );
mov ah,3Ch ;C?digo para crear archivo.
mov cx,0 ;Archivo normal.
mov dx,offset narchivo ;Direcci?n del nombre.
int 21h ;Crear y abrir, devuelve ident.
jc error_ca ;Saltar en caso de error.
mov fid,ax ;guardar identificador en variable.
jmp fin_ca

error_ca:
    mov bandera_error,1 
fin_ca:
ret
Crear_Abrir 
end main