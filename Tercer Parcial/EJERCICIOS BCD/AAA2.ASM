
escribe_caracter macro valor
    push ax
    push dx
    mov dl, valor
    MOV AH, 02  ; Caracter a desplegar almacenado en dl
    INT 21h
    pop ax
    pop dx
endm

.model small
.stack 64
.data
ASC1 DB '78'
ASC2 DB '674'
ASCSUM DB '0000'

.code

PRINCI PROC FAR
   ;PROTOCOLO
   push ds
   sub ax,ax
   push ax
   MOV AX,@DATA
   MOV DS,AX

   ;mov si,10
CLC ;limpia la bandera de acarreo.
LEA SI,ASC1+1
LEA DI, ASC2+2
LEA BX, ASCSUM+3
MOV CX,03

SALTA:
    MOV AH,00 ;garantizamos que AH este limpio.
    MOV AL,[SI]
    ADC AL,[DI] ;suma con carry.
    AAA ;esta manejando el carry.
    MOV [BX], AL
    DEC SI
    DEC DI
    DEC BX
LOOP SALTA

MOV [BX],AH ;AH tiene el acarreo.
LEA BX,ASCSUM+3
MOV CX,04

SALTAR:
OR BYTE PTR [BX], 30h
DEC BX
LOOP SALTAR


mov bx, offset ascsum
mov cx, 04

imprime:
    escribe_caracter [bx]
    inc bx
loop imprime
 


 mov ah,04ch
 int 21h
PRINCI ENDP

END PRINCI
