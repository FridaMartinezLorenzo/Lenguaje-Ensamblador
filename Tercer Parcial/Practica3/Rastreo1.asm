;Definici?n del Stack
STACKSG SEGMENT PARA STACK 'STACK' 
    DB 20 DUP (0)
STACKSG ENDS

;Definici?n de ?reas de trabajo
;area de Datos
DATASG SEGMENT PARA 'DATA' 
    
MEN DB 'Hola ........$' 

DATASG ENDS


;Area de c?digo
CODESG SEGMENT PARA 'CODE'
PRINCI PROC FAR
ASSUME SS:STACKSG, DS:DATASG, CS:CODESG
    ;Protocolo
    PUSH DS
    SUB AX,AX
    PUSH AX
    MOV AX,SEG DATASG
    MOV DS,AX
    ;Inicia programa
    CALL limpia
    CALL PREINI
    RET
PRINCI ENDP

;C?digo de Procedimientos
LIMPIA PROC NEAR
    PUSH AX
    PUSH DX
    MOV AX,0600h
    MOV BH,50h
    MOV CX,0000h
    MOV DX,184Fh
    INT 10h
    POP DX
    POP AX
LIMPIA ENDP

PREINI PROC NEAR
    MOV AH,10H
    INT 16H
    CMP AL,00H
    JE RASTREA
    CMP AL,0E0H
    je RASTREA
    JMP SAL1
   RASTREA:
    CMP AH,4DH ;C?digo de rastreo de la tecla F12
    JNE SAL1
    MOV AH,02
    MOV BH,00
    MOV DX,0c27h
    INT 10H
    LEA DX,MEN ;Lee el mensaje
    MOV AH,09
    INT 21H
   SAL1: RET
PREINI ENDP

CODESG ENDS

END PRINCI
END