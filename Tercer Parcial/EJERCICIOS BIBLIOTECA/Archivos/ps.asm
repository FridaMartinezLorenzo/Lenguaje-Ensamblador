include macro.lib

.model small

.stack 100

.data
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;               Archivo
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
narchivo db "ScoreInf.TXT",00h
fid dw ?
leido db 10 dup("$"), '$'
LIMPIAR db 10 dup("$"), '$'
msg1 db 10,13, "Error: No se pudo abrir el archivo. $"
msg2 db 10,13, "Error: No se puedo escribir el archivo. $"
msg3 db 10,13, "Error: No se pudo crear el archivo. $"
msg4 db 10,13, "Error: No se pudo leer en el archivo.$"
bandera_error db 0
procedimiento db 0 ; 0 es lectura 1 escritura
;   JUGADOR
 MSG_P1 DB "Nombre: $"
 MSG_P2 DB "Alias: $"

 NOMBRE_PLAYER DB 15,0, 15 DUP('$'),'$'
 ALIAS_PLAYER  DB 15,0, 15 DUP('$'),'$'
 SCORE DB "0100$"
 SALTO DB 13,10,"$"
 ESPACIOS DB 3 DUP(20H)
 
 
 game_score DB '00000'
 
.code
main proc
push dS
sub ax, ax
push ax
mov ax,@data
mov ds,ax
MOV ES,AX

MOV PROCEDIMIENTO,1

CALL LEER_INFO_BUFFER
CALL PROCESAMIENTO_ARCHIVO

mov ah,04ch
int 21h ;Salir sin indicar error
ret
MAIN endp

PROCESAMIENTO_ARCHIVO PROC
MOV BANDERA_ERROR,0 
;call  leer_info_buffer

call abrir_archivo
cmp bandera_error,1
je crear_archivo ;si se prendio no existe el archivo
jmp continua

crear_archivo:
    mov bandera_error,0
    call crear_abrir_arch 
    cmp bandera_error,1
    jne continua
    jmp salida
continua: ;procesamos el uso del archivo como tal 
       
        cmp procedimiento,0 ;es lectura
        je l ;lectura
        call cerrar_archivo
        call abrir_file_escribiR
        call posicionar_ap
       
        call escritura
        jmp salida
        l:
            limpiar_pantalla 07h
          
            call lectura ; lectura e impresion 
            JMP SALIDA

salida:
call cerrar_archivo
RET
PROCESAMIENTO_ARCHIVO ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ABRIR_ARCHIVO PROC
;Abre archivo
mov dx, offset narchivo
mov ah, 3dh
mov al, 00h
int 21h
jc error_abrir_a
mov fid, ax
jmp fin_abrir_arch

error_abrir_a:
    MOV BANDERA_ERROR,1
    ESCRIBE_CADENA MSG1
fin_abrir_arch:
RET
ABRIR_ARCHIVO ENDP


abrir_file_escribir proc
;Abrir para lectura
;fid=fopen( "texto.txt", "W" );
mov ah,3Dh              ;C?digo para abrir archivo
mov al,01               ;Modo ESCRITURA
mov dx,offset narchivo  ;Direcci?n del nombre
int 21h                 ;Abrir, devuelve identificador del archivo
jc error_open_w         ;En caso de error, saltar
mov fid,ax              ;Guardar identificador
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

cerrar_archivo proc
mov ah,3Eh
mov bx,fid
int 21h
RET
cerrar_archivo endp

Crear_Abrir_Arch proc
;Crear y abrir
;fid=fopen( "texto.txt", "w" );
mov ah,3Ch              ;C?digo para crear archivo.
mov cx,0                ;Archivo normal.
mov dx,offset narchivo  ;Direcci?n del nombre.
int 21h                 ;Crear y abrir, devuelve ident.
jc error_ca             ;Saltar en caso de error.
mov fid,ax              ;guardar identificador en variable.
jmp fin_ca

error_ca:
    mov bandera_error,1 
fin_ca:
ret
Crear_Abrir_Arch endp 


Escritura proc
;fwrite( &contenido, srtlen( contenido ), 1, fid );
mov ah,40h                    ;C?digo para escribir en archivo.
mov bx,fid                    ;Identificador.
LEA SI,NOMBRE_PLAYER+1        
MOV CH,0                      
mov CL,[SI]                   ;Tama?o de datos.
mov dx,offset NOMBRE_PLAYER+2 ;Direcci?n b?fer.
int 21h                       ;Escribir.
JC ERROR_ESCRITURA

CALL ESCRIBE_ESPACIOS

;fwrite( &contenido, srtlen( contenido ), 1, fid );
mov ah,40h                    ;C?digo para escribir en archivo.
mov bx,fid                    ;Identificador.
LEA SI,ALIAS_PLAYER+1        
MOV CH,0                      
mov CL,[SI]                   ;Tama?o de datos.
mov dx,offset ALIAS_PLAYER+2 ;Direcci?n b?fer.
int 21h                       ;Escribir.
JC ERROR_ESCRITURA

CALL ESCRIBE_ESPACIOS

mov ah,40h 
mov bx,fid 
mov CX,4 
mov dx,offset GAME_SCORE 
int 21h             ;Escribir.
jc error_escritura ;Saltar en caso de error.

mov ah,40h ;C?digo para escribir en archivo.
mov bx,fid ;Identificador.
mov CX,2 ;Tama?o de datos.
mov dx,offset SALTO ;Direcci?n b?fer.
int 21h ;Escribir.
jc error_escritura ;Saltar en caso de error.
CALL LIMPIAR_CADENA
JMP FIN_ESCRITURA
error_escritura:
    ESCRIBE_CADENA MSG2

FIN_ESCRITURA:
ret
Escritura endp
;____________________________________________
ESCRIBE_ESPACIOS PROC
;fwrite( &contenido, srtlen( contenido ), 1, fid );
mov ah,40h                    ;C?digo para escribir en archivo.
mov bx,fid                    ;Identificador.     
MOV CX,3                      ;Tama?o de datos.
mov dx,offset ESPACIOS        ;Direcci?n b?fer.
int 21h                       ;Escribir.
JC ERROR_ESCRITURA_ESPACIOS
JMP FIN_EE
error_escritura_ESPACIOS:
    ESCRIBE_CADENA MSG2
FIN_EE:
RET
ESCRIBE_ESPACIOS ENDP
;___________________________________________
LEER_INFO_BUFFER PROC
    ESCRIBE_CADENA MSG_P1
    LEERCADENA NOMBRE_PLAYER
    SALTAR
    ESCRIBE_CADENA MSG_P2
    LEERCADENA ALIAS_PLAYER
    LEE
RET 
LEER_INFO_BUFFER ENDP
;___________________________________________
LIMPIAR_CADENA PROC
MOV CX,15
LEA SI,NOMBRE_PLAYER+1
MOV AL,0
MOV [SI],AL
INC SI
MOV AL,'$'
LIMPIA1:
    MOV [SI],AL
    INC SI
    LOOP LIMPIA1

MOV CX,15
LEA SI,ALIAS_PLAYER+1
MOV AL,0
MOV [SI],AL
INC SI
MOV AL,'$'
LIMPIA:
    MOV [SI],AL
    INC SI
    LOOP LIMPIA

RET
LIMPIAR_CADENA ENDP
;______________________________
;____________________________________________
LECTURA PROC
PUSH CX
;leer archivo
LEER: 
    MOV AH,3FH
    MOV BX,FID
    MOV DX,OFFSET LEIDO
    MOV CX,10
    INT 21H
    JC ERROR2
    CMP AX,0
    JZ FIN
    JMP IMPRIMIR_FRAGMENTO
    REGRESA:
    ;LIMPIAR EL BUFFER
    PUSH CX
    MOV SI,OFFSET LIMPIAR
    MOV DI,OFFSET LEIDO
    MOV CX,10
    REP MOVSB
    POP CX
    JMP LEER
    
    ERROR2:
    ESCRIBE_CADENA Msg4
    MOV BANDERA_ERROR,1
    JMP FIN   

    IMPRIMIR_FRAGMENTO:;imprimir
        ESCRIBE_CADENA LEIDO
        JMP REGRESA

FIN:
POP CX

  RET
LECTURA ENDP


end main