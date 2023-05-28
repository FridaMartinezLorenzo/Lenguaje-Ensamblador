;PROGRAMA PARA RECORRER UN ARREGLO TIPO MATRIZ Y CUENTA LOS N?MEROS QUE PERTENECEN
;A UN DETERMINADO INTERVALO DE N?MEROS SIN SIGNO
; Definicion de stack
.MODEL small
.STACK 100
;DEFINICION DE AREAS DE TRABAJO
.DATA
;variables.
table1 db 254,223,187,54,135,23,77,44,218,199
       db 162,209,85,24,107,233,151,36,92,100
rangei db 0, 51,101,151,201 ;LIMITES INFERIORES DE INTERVALOS
rangeS db 50,100,150,200,255 ;LIMITES SUPERIORES DE INTERVALOS
numb dw 20
numr dw 5
numtab db 0,0,0,0,0 ;GUARDA CONTEO DE NUMEROS HALLADOS EN LOSINTERVALOS
SALTA db 13, 10,'$'

.CODE
PRINCI PROC FAR
;PROTOCOLO
push ds
sub ax,ax
push ax
MOV AX,@DATA
MOV DS,AX

;INICIA PROGRAMA
MOV DI, 0
RANGE: MOV BX, OFFSET TABLE1
MOV SI,0
MOV CX,NUMB
LL: CLC
    MOV DH, TABLE1[BX][SI]
    CMP DH,RANGEI[DI]
    JB CONT ;DEBAJO DE
    CLC
    CMP DH, RANGES[DI]
    JA CONT ;ARRIBA DE
    INC NUMTAB[DI]
CONT:INC SI
    LOOP LL
    INC DI
    CLC
    CMP DI, NUMR
    JB RANGE
    Mov cx, 0 ;cuantos elementos voy a recorrer, empezamos con el 0
inicio:
    mov si, cx
    INC CX
    mov dl,NUMTAB[si]
    CALL DESEMPAQUETA
    mov dx, offset SALTA
    CALL MENSAJE
    cmp cx,4
    jLe inicio
    RET
PRINCI ENDP

MENSAJE PROC
PUSH AX
MOV AH,09H
INT 21H
POP AX
RET
MENSAJE ENDP

Desempaqueta PROC
Push dx
Push cx
Mov dh,dl ; Guardando el valor original en DH
Mov cl,4
Shr dl,cl ; Cuatro corrimientos a la derecha
Call Binario_Ascii
Call Escribe
Mov dl,dh ; Recuperando el dato de DH
And dl,0Fh ; Aplicando mascara
Call Binario_ascii
Call Escribe
Pop cx
Pop dx
RET
Desempaqueta ENDP

escribe PROC
PUSH AX
MOV AH,02 ; Caracter a desplegar almacenado en dl
INT 21h
POP AX
RET
escribe ENDP

Binario_Ascii PROC
CMP DL,9h
JG SUMA37
ADD DL,30h
JMP FIN
SUMA37: ADD DL,37h
FIN : RET
Binario_Ascii ENDP

end princi