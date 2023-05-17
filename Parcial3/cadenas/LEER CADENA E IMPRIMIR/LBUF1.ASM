;  LEE UNA CADENA SERV 0A INT 21, USO BUFER
; ESCRIBE CARACTAER A CARACTER CONTENIDO

.MODEL small
.STACK  100

;DEFINICION DE AREAS DE TRABAJO1
.DATA
MSG1 DB "CADENA :$"
MSG2 DB "CADENA LEIDA: $"
MSG3 DB 10, 13, " $" 
MSG4 db "IMPRESION COMO CADENA: $"


Cadena LABEL byte
MAX Db 20
ACT Db ?
CONTE Db 20 DUP ("$"), "$"


.CODE
PRINCI PROC FAR
   ;PROTOCOLO
   push ds
   sub ax,ax
   push ax
   MOV AX,@DATA
   MOV DS,AX
  ;INICIA PROGRAMA

    LEA DX, MSG1
    CALL MENSAJE

    CALL LEERCADENA

    LEA DX, MSG3
    CALL MENSAJE
    LEA DX, MSG2
    CALL MENSAJE

    MOV CX,00
    LEA SI, CADENA+1
    MOV CL, [SI]
    LEA DI, CADENA+2
OTRO:   MOV DL, [DI]
    INC DI
    CALL escribe_car
    LOOP OTRO

    CALL LEE
    
    LEA DX,MSG4
    CALL ESCRIBE_CADENA
    LEA DX,CADENA+2
    CALL ESCRIBE_CADENA
    
    CALL LEE

    ret

PRINCI ENDP

escribe_cadena PROC
    PUSH AX
    MOV AH,09
    INT 21H
    POP AX
    RET
escribe_cadena ENDP

escribe_car PROC
 PUSH AX
 MOV AH,02  ; Caracter a desplegar almacenado en dl
 INT 21h
 POP AX
 RET 
escribe_car ENDP


leercadena PROC
PUSH DX
PUSH AX
LEA DX,CADENA
MOV AH,0AH
INT 21H
POP AX
POP DX
RET
leercadena ENDP

MENSAJE PROC
PUSH AX
MOV AH,09H
INT 21H
POP AX
RET
MENSAJE ENDP

LEE PROC
PUSH AX
MOV AH,01
INT 21H
POP AX
RET
LEE ENDP

END PRINCI