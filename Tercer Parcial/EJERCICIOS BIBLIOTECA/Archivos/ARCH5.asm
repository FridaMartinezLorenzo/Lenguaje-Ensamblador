.model small
.stack 64

.data
filename db "SCOREINF.TXT",0h
leido db 10 dup("$"), '$'
LIMPIAR db 10 dup("$"), '$'
handle dw 0
MSG DB "ERROR"


.code
main proc
push dS
sub ax, ax
push ax
mov ax,@data
mov ds,ax
MOV ES,AX

;Abre archivo
mov dx, offset filename
mov ah, 3dh
mov al, 00h
int 21h
jc FIN
mov handle, ax


;leer archivo
LEER: 
    MOV AH,3FH
    MOV BX,HANDLE
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
    mov dx,ax ;Desplegar c?digo de error, procesar el valor
    mov ah, 02
    int 21h ;Y salir indicando que hubo error
    JMP FIN   

    IMPRIMIR_FRAGMENTO:;imprimir
mov dx,offset leido
mov  ah,9
int 21h
JMP REGRESA

FIN:

;Cierrra archivo
mov bx, handle
mov ah, 3eh
int 21h


MOV AH, 04CH
INT 21H
MAIN ENDP

END MAIN