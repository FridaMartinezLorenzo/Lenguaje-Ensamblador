;Ejemplo para Ensamblar con Directivas Largas
;programa ejemplo para masm
;ES NECESARIO ALINEAR

; DEFINICION SEGMENTO DE PILA
    PILA segment para stack 'stack'       
        DB 20 DUP (0)                   ; Define espacio en la pila
    PILA ENDS

;DEFINICION DE AREAS DE TRABAJO

 ; DEFINICION  SEGMENTO DE DATOS
DATOS SEGMENT PARA 'DATA'
    
    SALTA db 13, 10,'$'
    MENSAJE4 DB 'ESTE LETRERO SE RECORRIO CARACTER A CARACTER $'
    MENSAJE5 DB 'PROPORCIONE 20 CARACTERES: $'
    CONTENIDO DB 20 DUP ("S"),"$"    
DATOS ENDS

; DEFINICION  SEGMENTO DE CODIGO
CODIGO SEGMENT PARA 'CODE'
  
 MAIN PROC FAR      
 ASSUME SS:PILA, DS:DATOS, CS:CODIGO
   
 ;PROTOCOLO (FORZOSO CUANDO ESTAMOS EN DIRECTIVA LARGA)
   PUSH DS 
   SUB AX,AX
   PUSH AX
   MOV AX,SEG DATOS 
   MOV DS,AX

   ;INICIA PROGRAMA
  
   ;Imprimir cadena caracter a caracter
   CALL alimentar_linea
   LEA DI,MENSAJE4
OTRO:MOV DL,[DI]
     CMP DL,"$"
     JE SALIR
     INC DI
     CALL escribe_CAR_
     JMP OTRO
     SALIR: CALL leer_car_con_eco
   
   ;LEER UNA CADENA CARACTER A CARACTER, LA LONGITUD ES DE 20 CARACTERES
   CALL alimentar_linea
   LEA DX,MENSAJE5
   CALL ESCRIBE_CADENA
   LEA SI,CONTENIDO
   MOV CL,1
   NUEVALECTURA:
            CALL ALIMENTAR_LINEA
            CALL LEER_CAR_CON_ECO
            MOV [SI], AL
            INC SI
            INC CL
            CMP CL,20
            JG TERMINO
            JMP NUEVALECTURA
   TERMINO:
   CALL ALIMENTAR_LINEA
   CALL LEER_CAR_SIN_ECO
   
   
   
    CALL sal_a_dos
   
   
   RET
   MAIN ENDP               ;Fin proceso (FIN DEL MAIN)
    
    ; En esta ?rea despu?s del main van las subrutinas
    ;SUBRUTINA1
   escribe_cadena PROC
    PUSH AX
    MOV AH,09
    INT 21H
    POP AX
    RET
   escribe_cadena ENDP
    
    
   leer_car_con_eco PROC
    MOV AH,01 ;no podemos resguardar ax en esa subrutina porque se pierde el char
    INT 21H
    RET
   leer_car_con_eco ENDP
    
   leer_car_sin_eco PROC
   MOV AH,08
    INT 21H
    RET
    leer_car_sin_eco ENDP 
    
   escribe_car_ PROC
        PUSH AX
        MOV AH,02 ;CARACTER ALMACENADO EN DL
        INT 21H
        POP AX
        RET
        escribe_car_ ENDP 
   
   sal_a_dos PROC
   MOV AH,4CH
    INT 21H
    RET
   sal_a_dos ENDP
   
   alimentar_linea PROC
    PUSH DX
    MOV DL,0AH
    CALL ESCRIBE_CAR_
    MOV DL,0DH
    CALL ESCRIBE_CAR_
    POP DX
    RET
   alimentar_linea ENDP
   
CODIGO ENDS                 ;Fin segemento de codigo
END MAIN 