; Programa ejemplo que muestra la cadena del 0 al 9 en forma inversa.
; Uso de LODSB
STACKSG SEGMENT PARA STACK 'STACK'
DB 100H DUP(0)
STACKSG ENDS

DATASG SEGMENT PARA 'DATA'
tabla DB '0,1,2,3,4,5,6,7,8,9',13,10,09,'$'
TABLAB DB 20 DUP(20H)
DATASG ENDS

CODESG SEGMENT PARA 'CODE'
PRINCI PROC FAR
ASSUME SS:STACKSG, DS:DATASG, CS:CODESG
PUSH DS
SUB AX,AX
PUSH AX
MOV AX,SEG DATASG
MOV DS,AX
MOV DX, OFFSET TABLA
CALL MENSAJE
CLD
MOV CX,13H
MOV SI, OFFSET TABLA
LEA DI, TABLAB+18 ;almacenando caracteres, salto de l?nea y

;tabulador

REGR: LODSB ; MOV AL,[SI], INC SI
MOV [DI],AL
DEC DI
LOOP REGR
;---------------------------------------------------------------
;DIFERENTES FORMAS PARA ASIGNAR EL DELIMITADOR $ A LA CADENA
;------ Direccionamiento indexado directo: DS+SI+cte
MOV SI,19
MOV AL, '$'
MOV TABLAB[SI],AL ;[SI+xxxx]

;-----Direccionamiento de base :DS+bx+cte
; MOV BH,00
; MOV BL,18 ;12H
; MOV TABLAB[BX+1],'$' ; [XXXX+BX+1]
;LEA BX, TABLAB
;MOV AL,'$'
;MOV [BX+19],AL ;[XXXX+18]
;----- Direccionamiento indirecto: DS+SI
;LEA SI,TABLAB+19 ;13H
;MOV AL, '$'
;MOV [SI],AL
;LEA SI, TABLAB
;MOV AL, '$'
;MOV [SI+19], AL ; [SI+19]
;---------------------------------------------------------------
LEA DX,TABLAB
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