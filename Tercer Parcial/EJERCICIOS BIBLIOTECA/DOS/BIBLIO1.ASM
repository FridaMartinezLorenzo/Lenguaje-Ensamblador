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
PUBLIC PUT_CURSOR
PUBLIC SHOW_CURSOR
PUBLIC OCULTA_MOUSE
PUBLIC INIT_MOUSE
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


INIT_MOUSE PROC NEAR
 MOV AX, 00H
 INT 33H
 RET
INIT_MOUSE ENDP

OCULTA_MOUSE PROC NEAR
 MOV AX, 02H
 INT 33H
 RET
OCULTA_MOUSE ENDP

SHOW_CURSOR PROC NEAR
 PUSH AX
 MOV AX, 01H
 INT 33H
 POP AX
 RET
SHOW_CURSOR ENDP

PUT_CURSOR PROC NEAR
 PUSH AX
 MOV AX, 04H
 INT 33H
 POP AX
 RET
PUT_CURSOR ENDP

GRAFICO PROC NEAR
 ; Inicializa modo grafico 640x480x16 (Begin)
 MOV AH, 00H
 MOV AL, 12H
 INT 10H
 ; Inicializa modo grafico 640x480x16 (End)
 RET
GRAFICO ENDP

end
 