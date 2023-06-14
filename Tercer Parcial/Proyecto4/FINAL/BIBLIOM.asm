;PROGRAMA QUE CONTIENE LA BIBLIOTECA DE FUNCIONES
.model small
public leer_car_con_eco
public leer_car_sin_eco
public escribe_car
public escribe_cadena
public alimentar_linea
public sal_a_dos 
PUBLIC LEE
PUBLIC MENSAJE
PUBLIC POSICIONA_CURSOR
PUBLIC M_MOUSE
PUBLIC F_MOUSE
PUBLIC I_MOUSE

.stack

.code

leer_car_con_eco PROC
 MOV AH,01 ; Deja el caracter le?do en al
 INT 21h
 RET
leer_car_con_eco ENDP
leer_car_sin_eco PROC
 MOV AH,08 ; Deja el caracter le?do en al
 INT 21h
 RET
Leer_car_sin_eco ENDP

escribe_car PROC
 PUSH AX
 MOV AH,02 ; Caracter a desplegar almacenado en dl
 INT 21h
 POP AX
 RET 
escribe_car ENDP
 
escribe_cadena PROC
 PUSH AX
 MOV AH,09 ; La direccion se almacena en el registro Dx
 INT 21h
 POP AX
 RET
escribe_cadena ENDP

alimentar_linea PROC
 PUSH DX
 MOV DL,0Ah ; salto de l?nea
 CALL ESCRIBE_CAR
 MOV DL,0Dh ; retorno de carro
 CALL ESCRIBE_CAR
 POP DX
 RET
alimentar_linea ENDP

sal_a_dos PROC
 MOV AH,4Ch 
 INT 21h
 RET
sal_a_dos ENDP

 LEE PROC
 PUSH AX
 MOV AH,01
 INT 21H
 POP AX
 RET
 LEE ENDP
 
 MENSAJE PROC
 PUSH AX
 MOV AH,09H
 INT 21H
 POP AX
 RET
 MENSAJE ENDP

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

POSICIONA_CURSOR PROC
    MOV AH,02h
    MOV AL,0
    MOV BX,0
    ;MOV DH, RENGLON
    ;MOV DL, COLUMNA
    INT 10H
    RET
POSICIONA_CURSOR ENDP


end