;------------------------------------------------
;MUESTRA LAS COORDENADAS DE LA POSICI?N ACTUAL DEL PUNTERO DEL MOUSE
;USO DE INT 21, SERVICIO 40
;------------------------------------------------
INCLUDE MACRO1.LIB
.MODEL SMALL
.STACK 100H
.DATA
XB DW 00
YB DW 00
VALASC DW 00
MEN1 DB 'Mouse no disponible...$'

DESPDATO LABEL BYTE
XMEN DB 'x= '
XASCII DW ?
YMEN DB ' y= '
YASCII DW ?

YXI DW 00
YXF DW 00
FPP DB 00

.CODE
MAIN PROC FAR
;PROTOCOLO
INICIO_DC
MOV ES,AX
;FIN PROTOCOLO
INITTEXT

MOV FPP,3EH
MOV YXI,00H
MOV YXF,184FH
TEXTBACKGROUND FPP,YXI,YXF

I_MOUSE
CMP AX,00
JE ERROR
M_MOUSE
MOV YXI,1843H
OTRO: 
    CALL P_MOUSE ; SERVICIO 03
    CMP BX,01
    JE EXIT
    GOTOXY YXI
    MOV AX,XB
    CALL CONV
    MOV AX,VALASC
    MOV XASCII,AX
    MOV AX,YB
    CALL CONV
    MOV AX,VALASC
    MOV YASCII,AX
    DESPLIEGA DESPDATO ;SERVICIO 40 DE LA INT 21
    JMP OTRO

ERROR: 
    LEA DX,MEN1
    PRINTF

EXIT: 
    F_MOUSE
    MOV FPP,07h
    MOV YXI,00H
    MOV YXF,184FH
    TEXTBACKGROUND FPP,YXI,YXF
    ;SAL_A_DOS
    EXIT_PROGRAMA
    RET
MAIN ENDP

P_MOUSE PROC NEAR ;La subrutina devuelve XB,YB
SAL3:
    MOV AX,03 
    INT 33H     
    CMP BX,01   
    JE SAL1
    MOV AX,CX 
    MOV CL,3
    SHR AX,CL 
    SHR DX,CL 
    MOV CX,AX 
    CMP CX,XB 
    JNE SAL2 
    CMP DX,YB
    JE SAL3 
SAL2: 
    MOV XB,CX 
    MOV YB,DX
SAL1: 
    RET
P_MOUSE ENDP

CONV PROC NEAR
    MOV VALASC,2020H 
    MOV CX,10 
    LEA SI,VALASC+1
    CMP AX,CX 
    JB C1 
    DIV CL 
    OR AH,30H 
    MOV [SI],AH
    DEC SI
    C1: OR AL,30H 
    MOV [SI],AL
    RET
CONV ENDP

END MAIN