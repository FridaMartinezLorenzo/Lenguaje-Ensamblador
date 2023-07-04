.model small
public leer_car_con_eco 
public leer_car_sin_eco 
public escribe_car 
public escribe_cadena 
public alimentar_linea 
public sal_a_dos 

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

end
