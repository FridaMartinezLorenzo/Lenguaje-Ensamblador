;PROGRAMA QUE CONTIENE LA BIBLIOTECA DE FUNCIONES
.model small

PUBLIC M_MOUSE
PUBLIC F_MOUSE
PUBLIC I_MOUSE

.stack

.code


;______________________________________________________________________
;FUNCIONES DEL MOUSE
;______________________________________________________________________


;VISUALIZAR EL PUNTERO DEL MOUSE SERVICIO 01H

M_MOUSE PROC
PUSH AX
MOV AX,01H ;Permite visualizar el puntero del Mouse
INT 33H   
POP AX
RET
M_MOUSE ENDP

F_MOUSE PROC
    PUSH AX
    MOV AX,02H ;oculta el puntero del mouse
    INT 33H 
    POP AX
RET
F_MOUSE ENDP

;INICIALIZAR EL MOUSE SERVICIO 00H

I_MOUSE PROC
MOV AX,00 
INT 33H 
RET
I_MOUSE ENDP



end