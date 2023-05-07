
; DEFINICION SEGMENTO DE PILA
    PILA segment para stack 'stack'       
        DB 20 DUP (0)                   ; Define espacio en la pila
    PILA ENDS

; DEFINICION  SEGMENTO DE DATOS
DATOS SEGMENT PARA 'DATA'
    
    SALTA db 13, 10,'$'
    promt  DB "-$"
    NUM1 DB ?                     ;Se planea guardar el dato
    CONTENIDO DB 220 DUP ("$"),"$" ;Aqui guardaremos datos
    COMANDO DB 40 DUP ("$"),"$"
    ERROR_MESSAGE DB "___ERROR__$"
    Valid DB "Correct comand$"
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
   LEA DX,promt
   CALL ESCRIBE_CADENA
   
   ;LEER UNA CADENA CARACTER A CARACTER
   LEA SI,COMANDO
   NUEVALECTURA:
            CALL LEER_CAR_CON_ECO
            MOV [SI], AL
            INC SI
            INC CL
            CMP AL,0DH
            JE TERMINOLECTURA
            JMP NUEVALECTURA
   TERMINOLECTURA:
   ;CALL ALIMENTAR_LINEA
   ;CALL LEER_CAR_SIN_ECO
   CALL EVALUACION_COMANDO
   
   
   ;LEA DX,CONTENIDO
   ;CALL ESCRIBE_CADENA
     
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
    CMP AL,61H
    JG LETRAMINUS
    CMP AL,39H
    JG LETRAMAYUS
    SUB AL,30H ;RESTAR 30 QUE ES EL 0
    JMP FIN
    LETRAMAYUS:
      CMP AL,41H
      JL ERROR
      CMP AL,53H
      JE FIN
      CMP AL,46H
      JG ERROR
      SUB AL,37H ; RESTAR 37 PARA LLEGAR AL VALOR DE "A" QUE ES 10D
      JMP FIN
    LETRAMINUS:
      CMP AL,61H
      JL ERROR
      CMP AL,73H
      JE FIN
      CMP AL,66H
      JG ERROR
      SUB AL,57H ; RESTAR 37 PARA LLEGAR AL VALOR DE "A" QUE ES 10D
      JMP FIN
   ERROR:
      MOV AL,0
      LEA DX,ERROR_MESSAGE
      CALL ESCRIBE_CADENA 
   FIN:
      RET
   ASCII_BINARIO ENDP
   
   
   BINARIO_ASCII PROC
    CMP DL,9H  
    JG SUMA37 ;Porque es un numero
    ADD DL,30H
    JMP DESENLACE
   SUMA37:
     ADD DL,37H ;el dato se va a quedar en DL
   DESENLACE: 
     RET
   BINARIO_ASCII ENDP
 ;_________________________________________________________________________________
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
  
   
   DESEMPAQUETA PROC
   PUSH DX
   PUSH CX
   MOV DH,DL ; GUARDANDO EL VALOR ORIGINAL DE DH
   MOV CL,4
   SHR DL,CL ; CUATRO CORRIMIENTOS A LA DERECHA
   CALL BINARIO_ASCII
   CALL ESCRIBE_CAR_
   MOV DL,DH
   AND DL,0FH ;RECUPERANDO EL DATO DE DH
   CALL BINARIO_ASCII
   CALL ESCRIBE_CAR_
   POP CX
   POP DX
   RET
   DESEMPAQUETA ENDP
   
;________________________________________________________________________________   
   EVALUACION_COMANDO PROC
   PUSH BX
   PUSH DX
   LEA SI,COMANDO
   MOV BL,[SI]
   MOV AL,BL
   CALL ASCII_BINARIO
   MOV DL,AL
   CALL BINARIO_ASCII
   CALL ESCRIBE_CAR_
   MOV BL,dL
   JMP CONTINUA_EVAL
   

   CONTINUA_EVAL:
   CMP BL,"E"
   JE  VERIFICA_E
   CMP BL,"D"
   JE VERIFICA_D
   JMP NO_VALID_COMAND ;Considerar si reescribiremos se?alando donde esta el error
   
   
   VERIFICA_E:
   ;CALL COMAND_E
   LEA DX,VALID
   CALL ESCRIBE_CADENA 
    JMP FIN_EVALUACION
   VERIFICA_D:
   ;CALL COMAND_D
   LEA DX,VALID
   CALL ESCRIBE_CADENA 
    JMP FIN_EVALUACION
   
   NO_VALID_COMAND:
   LEA DX,ERROR_MESSAGE
   CALL ESCRIBE_CADENA 
   
   FIN_EVALUACION:
   POP DX
   POP BX
   RET 
   EVALUACION_COMANDO ENDP
   
  ;________________________________________________

  
CODIGO ENDS                 ;Fin segemento de codigo
END MAIN 