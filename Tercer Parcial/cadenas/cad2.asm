;Copia una subcadena de la cadena1 a la 2 usando MOVSB con direcci?n 
;de derecha a izq

STACKSG SEGMENT PARA STACK 'STACK'
DB 100H DUP(0)
STACKSG ENDS

DATASG SEGMENT PARA 'DATA'
CAD1 DB 'PROGRAMA QUE IMPRIME UN MENSAJE$'
CAD2 DB '                               $'
DATASG ENDS

CODESG SEGMENT PARA 'CODE'
PRINCI PROC FAR
    ASSUME SS:STACKSG, DS:DATASG, CS:CODESG
    PUSH DS
    SUB AX,AX
    PUSH AX
    MOV AX,SEG DATASG
    MOV DS,AX
    MOV ES,AX ; LINEA QUE SE A?ADE AL PROTOCOLO

STD ;DIRECCI?N DE DERECHA A IZQUIERDA
MOV CX,10
LEA DI,CAD2+12
LEA SI,CAD1+12
REP MOVSB ; la b nos dice que se mueve por bytes
LEA DX,CAD2
CALL MENSAJE
CALL LEE
CALL FIN
PRINCI ENDP

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

FIN PROC
MOV AH,4CH
INT 21H
RET
FIN ENDP

CODESG ENDS
END PRINCI