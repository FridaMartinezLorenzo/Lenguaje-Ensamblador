;ALUMNO: MARTINEZ LORENZO FRIDA XIMENA 402-B


; DEFINICION SEGMENTO DE PILA
    PILA segment para stack 'stack'       
        DB 20 DUP (0)                   ; Define espacio en la pila
    PILA ENDS

;DEFINICION DE AREAS DE TRABAJO

 ; DEFINICION  SEGMENTO DE DATOS
DATOS SEGMENT PARA 'DATA'
    
    SALTA db 13, 10,'$'
    MENSAJE4 DB 'Ingrese un numero 0-F: $'
    MENSAJE5 DB 'Total: $'
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
  
   CALL alimentar_linea  ;Imprime letrero
   LEA DX,MENSAJE4
   CALL ESCRIBE_CADENA  
   CALL LEER_CAR_CON_ECO ;Lee caracter 
   CALL ASCII_BINARIO
   MOV BL,AL
   
   CALL alimentar_linea  ;Imprime letrero
   LEA DX,MENSAJE4
   CALL ESCRIBE_CADENA
   CALL LEER_CAR_CON_ECO ;Lee caracter 
   CALL ASCII_BINARIO
   ADD BL,AL
   MOV DL,BL
   CALL BINARIO_ASCII
   MOV BL,DL ;RESPALDAMOS PARA IMPRIMIR EL LETRERO
   CALL alimentar_linea ;Imprimimos letrero total
   LEA DX,MENSAJE5
   CALL ESCRIBE_CADENA
   MOV DL,BL ;RECUPERAMOS EL DATO
   CALL ESCRIBE_CAR_
   
     
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
    
   ;SUBRUTINA2
   leer_car_con_eco PROC
    MOV AH,01 ;no podemos resguardar ax en esa subrutina porque se pierde el char
    INT 21H
    RET
   leer_car_con_eco ENDP
   
   ;SUBRUTINA3
   leer_car_sin_eco PROC
   MOV AH,08
    INT 21H
    RET
    leer_car_sin_eco ENDP 
    
    ;SUBRUTINA4
   escribe_car_ PROC
        PUSH AX
        MOV AH,02 ;CARACTER ALMACENADO EN DL
        INT 21H
        POP AX
        RET
        escribe_car_ ENDP 
    
    ;SUBRUTINA5
   sal_a_dos PROC
   MOV AH,4CH
    INT 21H
    RET
   sal_a_dos ENDP
   
   ;SUBRUTINA6
   alimentar_linea PROC
    PUSH DX
    MOV DL,0AH
    CALL ESCRIBE_CAR_
    MOV DL,0DH
    CALL ESCRIBE_CAR_
    POP DX
    RET
   alimentar_linea ENDP
   
   ;SUBRUTINA7 CODIGO ASCII_BINARIO
    ASCII_BINARIO PROC ;EL DATO SE GUARDA EN AL
    CMP AL,30H
    JL ERROR
    CMP AL,39H
    JG LETRA
    SUB AL,30H ;RESTAR 30 QUE ES EL 0
    JMP FIN
   LETRA:
      CMP AL,41H
      JL ERROR
      CMP AL,46H
      JG ERROR
      SUB AL,37H ; RESTAR 37 QUE ES EL VALOR DE "A"
      JMP FIN
   ERROR:
      MOV AL,0
   FIN:
      RET
   ASCII_BINARIO ENDP
   
   
   BINARIO_ASCII PROC
    CMP DL,9H
    JG SUMA37
    ADD DL,30H
    JMP DESENLACE
   SUMA37:
     ADD DL,37H ;el dato se va a quedar en DL
   DESENLACE: 
     RET
   BINARIO_ASCII ENDP
   
   EMPAQUETA PROC
    PUSH CX                 ;shift left compromete al registro cx como contador
    CALL LEER_CAR_CON_ECO
    CALL ASCII_BINARIO      ;PROCESA EL 1ER CARACTER
    MOV CL,04
    SHL AL,CL               ;INSTRUCCION LOGICA DE CORRIMIENTO A LA IZQ
    MOV CH,AL               ;ALMACENANDO EL VALOR DE AL A UN REGISTRO AUX
    CALL LEER_CAR_CON_ECO   ;LEER L SEGUNDO CAR
    CALL ASCII_BINARIO      ;PROCESA EL 2O. CARACTER
    ADD AL,CH               ;la subrutina empaqueta deja la suma en al
    POP CX
    RET
   EMPAQUETA ENDP
   
CODIGO ENDS                 ;Fin segemento de codigo
END MAIN 