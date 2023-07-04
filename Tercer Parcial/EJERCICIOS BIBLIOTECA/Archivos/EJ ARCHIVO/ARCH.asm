INCLUDE MACRO.LIB
.MODEL small
.STACK 100

.DATA
 narchivo db "PRUEBA.txt",00h
 fid dw ?

 
 CADENA DB 30,0, 30 DUP('$'),'$'
 SALTO DB 13,10,"$"
 
.CODE
PRINCI PROC FAR
INICIO_DC

;Crear y abrir
;fid=fopen( "texto.txt", "w" );
mov ah,3Ch ;C?digo para crear archivo.
mov cx,0 ;Archivo normal.
mov dx,offset narchivo ;Direcci?n del nombre.
int 21h ;Crear y abrir, devuelve ident.
jc error ;Saltar en caso de error.
mov fid,ax ;guardar identificador en variable.

OTRA:
LIMPIAR_PANTALLA 07H
LEERCADENA CADENA
;ESCRIBE_CADENA CADENA+2
CMP CADENA+2,0DH
JE CERRAR_PROGRAMA
;Escribir en el archivo

;fwrite( &contenido, srtlen( contenido ), 1, fid );
mov ah,40h ;C?digo para escribir en archivo.
mov bx,fid ;Identificador.
LEA SI,CADENA+1
MOV CH,0
mov CL,[SI] ;Tama?o de datos.
mov dx,offset CADENA+2 ;Direcci?n b?fer.
int 21h ;Escribir.
JC ERROR

mov ah,40h ;C?digo para escribir en archivo.
mov bx,fid ;Identificador.
mov CX,2 ;Tama?o de datos.
mov dx,offset SALTO ;Direcci?n b?fer.
int 21h ;Escribir.
jc error ;Saltar en caso de error.
CALL LIMPIAR_CADENA
JMP OTRA

;A?ADIR EL GUARDADO DE UN ENTER
CERRAR_PROGRAMA:
;Cerrar archivo
;fclose( fid );
mov ah,3Eh ;C?digo para cerrar archivo
mov bx,fid ;Identificador.
int 21h ;Cerrar archivo
jc error ;Saltar en caso de error
JMP SALIDA

error:
mov dx,ax ;Desplegar c?digo de error, procesar el valor
mov ah, 02
int 21h ;Y salir indicando que hubo error
salida:
EXIT_PROGRAMA
RET
PRINCI ENDP



LIMPIAR_CADENA PROC
MOV CX,30
LEA SI,CADENA+1
MOV [SI],0
INC SI
MOV AL,'$'
LIMPIA:
    MOV [SI],AL
    INC SI
    LOOP LIMPIA

RET
LIMPIAR_CADENA ENDP
END PRINCI