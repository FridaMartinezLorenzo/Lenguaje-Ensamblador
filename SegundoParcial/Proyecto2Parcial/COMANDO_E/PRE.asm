; DEFINICION SEGMENTO DE PILA
    PILA segment para stack 'stack'       
        DB 20 DUP (0)                   ; Define espacio en la pila
    PILA ENDS

; DEFINICION  SEGMENTO DE DATOS
DATOS SEGMENT PARA 'DATA'
    
    SALTA db 13, 10,'$'
    promt  DB 13, 10,"-$"
    NUM1 DB ?                     ;Se planea guardar el dato
    COMANDO DB 230 DUP ("$"),"$"
    
    VERDADERO DB 01H
    DIRECCION_H DB ?
    DIRECCION_L DB ?
    ERROR_MESSAGE DB "___ERROR__",13, 10,"$"
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
   SIGUIENTE_COMANDO:
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
   CALL EVALUACION_COMANDO
   CMP VERDADERO,01H
   JE SIGUIENTE_COMANDO
   
   ;LEA DX,CONTENIDO
   ;CALL ESCRIBE_CADENA
   
 
       
   ;CALL sal_a_dos
   
   RET
   MAIN ENDP               ;Fin proceso (FIN DEL MAIN)
   
   
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
  
    
    ;SUBRUTINA4
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
   
   ASCII_BINARIO PROC ;EL DATO SE GUARDA EN AL
    CMP AL,30H
    JL ERROR
    CMP AL,60H
    JG LETRAMINUS
    CMP AL,39H
    JG LETRAMAYUS
    SUB AL,30H ;RESTAR 30 QUE ES EL 0
    JMP FIN
    LETRAMAYUS:
      CMP AL,41H
      JL ERROR
      CMP AL,46H
      JG ERROR
      SUB AL,37H ; RESTAR 37 PARA LLEGAR AL VALOR DE "A" QUE ES 10D
      JMP FIN
    LETRAMINUS:
      CMP AL,61H
      JL ERROR
      CMP AL,66H
      JG ERROR
      SUB AL,57H ; RESTAR 37 PARA LLEGAR AL VALOR DE "A" QUE ES 10D
      JMP FIN
   ERROR:
   ;MOV AL,00
   MOV AL,28H ;ES PARENTESIS QUE ABRE PERO ES UN CHAR NO VALIDO
      ;LEA DX,ERROR_MESSAGE
      ;CALL ESCRIBE_CADENA 
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
    ;MOV DL,AL
    ;CALL DESEMPAQUETA
    POP CX
    RET
   EMPAQUETA ENDP
  
   EMPAQUETA_SINT PROC ;SIN LEER CARACTER
    PUSH CX                 
    ;SE RECIBE EN AL EL PRIMER CARACTER YA PASADO DE ASCII_BINARIO VIENE EN AL
    ;PROCESA EL 1ER CARACTER
    MOV CL,04
    SHL AL,CL               ;INSTRUCCION LOGICA DE CORRIMIENTO A LA IZQ
    MOV CH,AL               ;ALMACENANDO EL VALOR DE AL A UN REGISTRO AUX
    INC SI
    MOV BL,[SI] ;TOMAMOS EL SIGUEINTE CARACTER
    CALL IS_A_NUM           ;PROCESA EL 2O. CARACTER
    ADD AL,CH               ;la subrutina empaqueta deja la suma en al
    POP CX 
    RET
   EMPAQUETA_SINT ENDP
    
   EMPAQUETA_MODIFICADO_ENTER PROC
    PUSH CX                 ;shift left compromete al registro cx como contador
    MOV DX,0
    CALL LEER_CAR_CON_ECO
    CMP AL,0DH
    JE FINAL_EMPAQUETA_M ;SE CONSERVA 
    ;MOV DH,00
    CALL ASCII_BINARIO      ;PROCESA EL 1ER CARACTER
    CMP AL,28H
    JE ERROR_DATO_ENTRANTE
    MOV CL,04
    SHL AL,CL               ;INSTRUCCION LOGICA DE CORRIMIENTO A LA IZQ
    MOV CH,AL               ;ALMACENANDO EL VALOR DE AL A UN REGISTRO AUX
    CALL LEER_CAR_CON_ECO   ;LEER L SEGUNDO CAR
    CALL ASCII_BINARIO      ;PROCESA EL 2O. CARACTER
    CMP AL,28H
    JE ERROR_DATO_ENTRANTE
    ADD AL,CH               ;la subrutina empaqueta deja la suma en al
    JMP FINAL_EMPAQUETA_M
   
    ERROR_DATO_ENTRANTE:
    MOV AL,28H ;SE CONSERVA EL DATO CONSIDERADO COMO ERROR
    
    FINAL_EMPAQUETA_M:
    ;MOV DL,AL
    ;CALL DESEMPAQUETA
    POP CX
    RET
    EMPAQUETA_MODIFICADO_ENTER ENDP
   
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
   
   DESEMPAQUETA_Y_GUARDA PROC
   PUSH DX
   PUSH CX
   MOV DL,BL
   MOV DH,DL ; GUARDANDO EL VALOR ORIGINAL DE DH
   MOV CL,4
   SHR DL,CL ; CUATRO CORRIMIENTOS A LA DERECHA
   CALL BINARIO_ASCII
   MOV [DI],DL
   INC DI
   MOV DL,DH
   AND DL,0FH ;RECUPERANDO EL DATO DE DH
   CALL BINARIO_ASCII  ;EL DATO SE QUEDA EN DL
   MOV [DI],DL
   INC DI
   MOV CH,20H
   MOV [DI],CH; GUARDAMOS UN ESPACIO
   INC DI
   POP CX
   POP DX
   RET
   DESEMPAQUETA_Y_GUARDA ENDP
   
   
   TRADUCIR PROC
    PUSH AX
    PUSH DX
    MOV AL,BL ;DATO DE ENTRADA EN BL
    CALL ASCII_BINARIO
    MOV DL,AL
    CALL BINARIO_ASCII
    ;CALL ESCRIBE_CAR_
    MOV BL,DL ;DATO FINAL EN BL
    POP DX
    POP AX
    RET
   TRADUCIR ENDP
  ;_____________________________________________________________________________
   
  EVALUACION_COMANDO PROC
   PUSH BX
   PUSH DX
   LEA SI,COMANDO
   MOV BL,[SI]
   CALL TRADUCIR ;CONVIERTE A MAYUS SI FUESE NECESARIO
   CMP BL,"0"
   JE EXIT
   CMP BL,"E"
   JE  VERIFICA_E
   CMP BL,"D"
   JE  VERIFICA_D
   JMP NO_VALID_COMAND ;Considerar si reescribiremos se?alando donde esta el error
   
   
   EXIT:
    CALL SAL_A_DOS
    
   VERIFICA_E:
     CALL COMAND_E
    ;LEA DX,VALID
    ;CALL ESCRIBE_CADENA 
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

   COMAND_E PROC
   PUSH BX
   PUSH CX
   MOV BX,0 
   INC SI
   MOV BL,[SI]
   CMP BL,20H ;TIENE QUE EXISTIR UN ESPACIO
   JNE SINTAX_ERROR_E
   ;DEFINIMOS EL CASO 
   INC SI
   MOV BL,[SI]
   CALL IS_A_NUM ;FALTA SI SE METE UN ENTER 
   CMP AH,0 ;BANDERA APAGADA
   JE SINTAX_ERROR_E
   CALL GET_DIRECCION
   
   INC SI
   MOV BL,[SI]
   CMP BL,0DH
   JE DATO_POR_DATO
   
   CMP BL,20H
   JNE SINTAX_ERROR_E
   
   ;CONTINUA_CON_DATOS:
   CALL GET_DATOS
   JE FIN_COMAND_E
   
   DATO_POR_DATO:
     CALL INGRESO_DATO_UNOXUNO
     JMP FIN_COMAND_E
        
   SINTAX_ERROR_E:
    LEA DX,ERROR_MESSAGE
    CALL ESCRIBE_CADENA 
   
   FIN_COMAND_E:
   ;LEA DX,VALID
    ;CALL ESCRIBE_CADENA
    POP CX
    POP BX 
    RET
   COMAND_E ENDP
   ;___________________________________________   
   
 IS_A_NUM PROC
    MOV AL,BL
    CALL ASCII_BINARIO
    CMP AL,00H
    JL NOT_A_NUM
    CMP AL,09H
    JG NOT_A_NUM
    
    MOV AH,01
    JMP VEREDICTO_IS_A_NUM
    
    NOT_A_NUM:
      MOV AH,00
      
    VEREDICTO_IS_A_NUM:
      ;MOV DL,AL
      ;CALL BINARIO_ASCII
      ;CALL ESCRIBE_CAR_
      RET
   IS_A_NUM ENDP
   ;___________________________________________
   GET_DIRECCION PROC
    PUSH CX
    ;PARTE ALTA DIRECCION
    ;AL SIGUE TENIENDO EL DATO RESULTANTE DE ASCII_BINARIO
    MOV CX,0
    MOV CL,04
    SHL AL,CL
    MOV CH,AL  ; Respaldamos
    INC SI
    MOV BL,[SI]
    CALL IS_A_NUM
    CMP AH,00H
    JE ERROR_EN_DIRECCION
    ADD CH,AL
    MOV DIRECCION_H,CH
    
    ;PARTE BAJA
    INC SI
    MOV BL,[SI]
    CALL IS_A_NUM
    CMP AH,00H
    JE ERROR_EN_DIRECCION
    MOV CL,04
    SHL AL,CL
    MOV CH,AL  ; RespaldamoS
    INC SI
    MOV BL,[SI]
    CALL IS_A_NUM
    CMP AH,00H
    JE ERROR_EN_DIRECCION
    ADD CH,AL
    MOV DIRECCION_L,CH
        
    ;IMPRIMIR DIRECCION
    ;MOV DL,DIRECCION_H
    ;CALL DESEMPAQUETA
    ;MOV DL,DIRECCION_L
    ;CALL DESEMPAQUETA
    JMP FIN_DIRECCION
    
    ERROR_EN_DIRECCION:
          LEA DX,ERROR_MESSAGE
          CALL ESCRIBE_CADENA 
          
    FIN_DIRECCION:
    POP CX
    RET
   GET_DIRECCION ENDP
   ;___________________________________________
   GET_DATOS PROC ;LISTADOS
     PUSH CX
     PUSH DI
     PUSH DX
     
     MOV BH,DIRECCION_H
     MOV BL,DIRECCION_L
     LEA DI,[BX]
     ;LEA DI,CONTENIDO
     
    SIG_DATO:
     MOV BL,[SI]
     CMP BL,0DH
     JE FIN_GET_DATOS
     CMP BL,20H ;TIENE QUE EXISTIR UN ESPACIO
     JNE SINTAX_ERROR_DATOS
     INC SI
     MOV BL,[SI]
     
     CMP BL,22H ;SI ES UNA COMILLA
     JE PROCESAR_CADENA
     
     MOV AL,BL
     CALL ASCII_BINARIO
     CMP AL,28H
     JE SINTAX_ERROR_DATOS
    
     CALL EMPAQUETA_SINT ;EL DATO COMPLETO QUEDA EN AL
     MOV BL,AL
     CALL DESEMPAQUETA_Y_GUARDA  
     INC SI
     JMP SIG_DATO
    
     PROCESAR_CADENA:
     CALL VALIDAR_CADENA
     CMP AH,00
     JE SINTAX_ERROR_DATOS
     GUARDAR_CADENA:
        INC SI ;PARA NO GUARDAR LA COMILLA
        MOV BL,[SI]
        CMP BL,24H
        JE FIN_GET_DATOS
        MOV [DI],BL
        INC DI
        JMP GUARDAR_CADENA    
     
     JMP FIN_GET_DATOS
     
    SINTAX_ERROR_DATOS:
        LEA DX,ERROR_MESSAGE
        CALL ESCRIBE_CADENA

    FIN_GET_DATOS:
     MOV BH,24H
     MOV [DI],BH
     MOV BH,DIRECCION_H
     MOV BL,DIRECCION_L
     LEA DX,[BX]
     CALL ESCRIBE_CADENA
    POP BX
    POP DI
    POP CX 
    RET
   GET_DATOS ENDP
   ;___________________________________________
   
   VALIDAR_CADENA PROC
    PUSH DI
    MOV DI,SI
    ;NOS SALTAMOS LAS COMILLAS YA EVALUADAS
    SIGUIENTE_CARACTER_A_VALIDAR:
    INC SI
    MOV BL,[SI]
    CMP BL,24H
    JE VAMOS_BIEN_EN_SINTAXIS ;EVALUAMOS EL FINAL
    JMP SIGUIENTE_CARACTER_A_VALIDAR
    
    
    VAMOS_BIEN_EN_SINTAXIS:
    INC SI
    MOV BL,[SI]
    CMP BL,22H
    JNE ERROR_SINTAXIS_CADENA
    MOV AH,01 ; BIEN
    JMP VEREDICTO_CADENA
    
    ERROR_SINTAXIS_CADENA:
    MOV AH,00
    
    VEREDICTO_CADENA:
    MOV SI,DI
    POP DI
    RET    
   VALIDAR_CADENA ENDP
;_________________________________________________________

INGRESO_DATO_UNOXUNO PROC
    PUSH DX
    PUSH DI
    PUSH BX
    MOV BH,DIRECCION_H
    MOV BL,DIRECCION_L
    LEA DI,[BX]
     
    SIGUIENTE_DATO_DATO:
    
    MOV AL,[DI] ;LEEMOS EL DATO EN MEMORIA
    ;CONVERTIR A HEXADECIMAL
    CALL ASCII_BINARIO 
    CMP AL,28H
    JNE CONTINUA1
    MOV AL,00H ;CORRIGE
    
  CONTINUA1:
    MOV DL,AL
    CALL BINARIO_ASCII
    CALL ESCRIBE_CAR_

    
    INC DI
    MOV AL,[DI]
    CALL ASCII_BINARIO
    CMP AL,28H
    JNE CONTINUA2
    MOV AL,00H ;CORRIGE
   CONTINUA2:
    MOV DL,AL
    CALL BINARIO_ASCII
    CALL ESCRIBE_CAR_
    
    ;CADA BYTE SON DOS NIBBLES
    
    MOV DL,2EH ;EL PUNTO
    CALL ESCRIBE_CAR_
    
    DEC DI ;PARA GUARDAR APARTIR DE LA CORRECTA
    ;CALL EMPAQUETA
    CALL EMPAQUETA_MODIFICADO_ENTER; EL DATO SE QUEDO EN AL
    CMP AL,0DH  ;SI es enter se anula la opcion
    JE FIN_DATO_UNO_A_UNO
       
    CMP AL,28H
    JE ERROR_DATO_INGRESADO
    MOV BL,AL 
    CALL DESEMPAQUETA_Y_GUARDA
    CALL LEER_CAR_CON_ECO
    CMP AL,0DH
    JE FIN_DATO_UNO_A_UNO
    CMP AL,20H
    JNE ERROR_DATO_INGRESADO
    MOV DL,20H
    CALL ESCRIBE_CAR_
    JMP SIGUIENTE_DATO_DATO
    
    
    ERROR_DATO_INGRESADO:
        CALL ALIMENTAR_LINEA
        LEA DX,ERROR_MESSAGE
        CALL ESCRIBE_CADENA
        
    FIN_DATO_UNO_A_UNO:
    MOV CH,24H
    MOV [DI],CH
    MOV BH,DIRECCION_H
    MOV BL,DIRECCION_L
    LEA DX,[BX]
    CALL ESCRIBE_CADENA
    POP BX
    POP DI
    POP DX
    RET
INGRESO_DATO_UNOXUNO ENDP
;____________________________________________________


CODIGO ENDS                 ;Fin segemento de codigo
END MAIN