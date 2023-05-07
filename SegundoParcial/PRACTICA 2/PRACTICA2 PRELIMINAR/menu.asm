;ALUMNO: MARTINEZ LORENZO FRIDA XIMENA 402-B

; DEFINICION SEGMENTO DE PILA
    PILA segment para stack 'stack'       
        DB 20 DUP (0)                   ; Define espacio en la pila
    PILA ENDS

;DEFINICION DE AREAS DE TRABAJO

 ; DEFINICION  SEGMENTO DE DATOS
DATOS SEGMENT PARA 'DATA'
    ;DATOS COMUNES
    SALTA db 13, 10,'$'
    ;PRIMER PROBLEMA DATOS
    MENU    DB "MENU",13,10,"01. Hallar los pares de un total de numeros leidos",13,10,"02. Sumar los numeros hallados en el intervalo 1d ... 100d",13,10,"03. Sumar n numeros aleatorios",13,10,"OPC: $"
    MEN1  DB "Ingrese la cant de numeros desea procesar :$"
    MEN2 DB "Ingrese numero: $"
    MEN3 DB "Total: $"
    MEN4 DB "ERROR,INGRESE HEXADECIMAL VALIDO !!$"
    CONTENIDO DB 220 DUP ("$"),"$"
    CONTADOR_PARES DB ?
    ;SEGUNDO PROBLEMA DATOS
    MEN5  DB "SUMA LOS NUMEROS DE 1d a 100d: $"
    ;TERCER PROBLEMA DATOS
    SUMH DB ?
    SUML DB ?
    MEN6 DB 'Ingrese la cantidad de elemento aleatorio a sumar: $'
DATOS ENDS


; DEFINICION  SEGMENTO DE CODIGO
CODIGO SEGMENT PARA 'CODE'
  
 MAIN PROC FAR      
 ASSUME SS:PILA, DS:DATOS, CS:CODIGO
   
 ;PROTOCOLO 
   PUSH DS 
   SUB AX,AX
   PUSH AX
   MOV AX,SEG DATOS 
   MOV DS,AX

   ;INICIA PROGRAMA
   
   LEA DX,MENU
   CALL ESCRIBE_CADENA
   CALL EMPAQUETA;
   CALL ALIMENTAR_LINEA
   CALL VALIDAR_INICIOM ;COMPARAMOS SI ES UN NUMERO VALIDO
   CALL ALIMENTAR_LINEA
   CMP CH,01H
   JE PRO_VALID_OPC
   JMP FINAL
   PRO_VALID_OPC:       ;PROCEDIMIENTO PARA UN NUMERO VALIDO
    CMP AL,03H
    JE TERCER_PROBLEMA
    CMP AL,02H
    JE SEGUNDO_PROBLEMA
    ;DE LO CONTRARIO ES EL primero
    CALL CASO_UNO
    JMP FINAL
    
    SEGUNDO_PROBLEMA:
        CALL CASO_DOS
        JMP FINAL
    TERCER_PROBLEMA:
        CALL CASO_TRES
   FINAL:    
   CALL sal_a_dos
   
   MAIN ENDP               ;Fin proceso (FIN DEL MAIN)
    
    ;SUBRUTINA1
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
      MOV AL,00
      LEA DX,SALTA
      CALL INVALID_HEXA
      CALL SAL_A_DOS
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
    EMPAQUETA ENDP   ;LO DEJA EN AL
   
   ;_____________________________________________________________________
   
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
   ;_______________________________________________________________________
        SEMILLA PROC
            PUSH AX
            MOV AH,2CH
            INT 21H  ; RETORNA CH=HORAS, EN FORMATO 00-23, MEDIANOCHE=0
                ; CL MINUTOS 00-59
                ;DH SEGUNDOS 00-59
                ; DL CENTESIMAS DE SEGUNDO 00-99
            POP AX
            RET
        SEMILLA ENDP
        ;_______________________________________________________________________
        
        ALEATORIO PROC
        ; XN+1=(2053*XN + 13849)MOD 2**16
        ; RETORNA EL NUMERO PSEUDOALEATORIO EN AX   
        MOV AX,DX ;CARGANDO A AX EL NUMERO SEMILLA tomado de la int 21 serv             2CH
        MOV DX,0  ;CARGANDO CERO EN LA POSICION MAS SIGNIFICATIVA DEL               MULTIPLICANDO
        MOV BX,2053 ; MULTIPLICADOR
        MUL BX
        MOV BX,13849 ;CARGA EN BX LA CONSTANTE ADITIVA
        CLC ;limpiar la bandera de CARRY
        ADD AX,BX ; SUMA PARTES MENOS SIGNIFICATIVAS DEL RESULTADO
        ADC DX,0 ; SUMA EL ACARREO SI ES NECESARIO
        MOV BX,0FFFFH ; CARGAR LA CONSTANTE 2**16-1
        DIV BX
        MOV AX,DX ; MUEVE EL RESIDUO  AX
        RET
    ALEATORIO ENDP

    ;______________________________________________________________________
    
    ESCALANDO PROC
        ; ESCALANDO EL NUMERO PSEUDOALEATORIO OBTENIDO
        MOV DX,0
        MOV BX,64H;NUMEROS ALEATORIOS ENTRE 0 Y 9
        DIV BX
        MOV AX,DX
        MOV BX,0000
        MOV DL,AL
        CALL DESEMPAQUETA
        RET
    ESCALANDO ENDP
    ;_____________________________________________________________________
    LEE PROC
        MOV AH,01
        INT 21H
        RET
    LEE ENDP
   ;______________________________________________________________________
   DESEMPAQUETA_Y_GUARDA PROC
   PUSH DX
   PUSH CX
   MOV DL,BH
   MOV DH,DL ; GUARDANDO EL VALOR ORIGINAL DE DH
   MOV CL,4
   SHR DL,CL ; CUATRO CORRIMIENTOS A LA DERECHA
   CALL BINARIO_ASCII
   MOV [SI],DL
   INC SI
   MOV DL,DH
   AND DL,0FH ;RECUPERANDO EL DATO DE DH
   CALL BINARIO_ASCII  ;EL DATO SE QUEDA EN DL
   MOV [SI],DL
   INC SI
   ;SEGUNDO BYTE
   MOV DL,BL
   MOV DH,DL ; GUARDANDO EL VALOR ORIGINAL DE DH
   MOV CL,4
   SHR DL,CL ; CUATRO CORRIMIENTOS A LA DERECHA
   CALL BINARIO_ASCII
   MOV [SI],DL
   INC SI
   MOV DL,DH
   AND DL,0FH ;RECUPERANDO EL DATO DE DH
   CALL BINARIO_ASCII  ;EL DATO SE QUEDA EN DL
   MOV [SI],DL
   INC SI

   POP CX
   POP DX
   RET
   DESEMPAQUETA_Y_GUARDA ENDP
   ;_____________________________________________________________________________
   
   READ_DATA PROC
       PUSH DX
       LEA DX,SALTA
       CALL ESCRIBE_CADENA
       CALL ALIMENTAR_LINEA
       LEA DX,MEN2
       CALL ESCRIBE_CADENA
       CALL EMPAQUETA
       MOV BH,AL
       CALL EMPAQUETA
       MOV BL,AL
       CALL ALIMENTAR_LINEA
       POP DX
       RET
   READ_DATA ENDP
   ;______________________________________________________________________________
   
   ES_PAR_VERI PROC
    PUSH BX
    MOV BX,0002H
    IDIV BX
    CMP DX,0000H
    JE PAR
    ;PROCEDIMIENTO IMPAR
    MOV CH,00H ;CH ES LA BANDERA, 0 IMPAR
    JMP LAST_STEP
    PAR:
        MOV CH,01H; CH 1 ES PAR
    LAST_STEP:
        POP BX
        RET
   ES_PAR_VERI ENDP
   ;////////////////////////////////////////////////////////////////////////////////////////
   ;                VALIDACIONES DE LOS DATOS INICIALES
   ;///////////////////////////////////////////////////////////////////////////////////////
   VALIDAR_INICIO1 PROC
    CMP AL,00H
    JLE NONONO
    MOV CH,01H
    JMP EXIT
    NONONO:
        MOV CH,00H
        CALL INVALID_HEXA
    EXIT:
        RET
   VALIDAR_INICIO1 ENDP
  ;_______________________________________________________________________________________ 
   VALIDAR_INICIOM PROC
       CMP AL,00H
       JLE WRONG
       CMP AL,03H
       JG WRONG
       MOV CH,01H
       JMP FN
       WRONG:
        MOV CH,00H
        CALL INVALID_HEXA
        FN:
           RET
     VALIDAR_INICIOM ENDP
   ;_______________________________________________________________________________________ 
   INVALID_HEXA PROC
      LEA DX,SALTA
      CALL ESCRIBE_CADENA
      CALL ALIMENTAR_LINEA
      LEA DX,MEN4
      CALL ESCRIBE_CADENA
      CALL ALIMENTAR_LINEA
      CALL SAL_A_DOS
      RET
   INVALID_HEXA ENDP
   ;////////////////////////////////////////////////////////////////////////////////////////
   ;                CODIGOS     PROBLEMAS
   ;///////////////////////////////////////////////////////////////////////////////////////
   ;_______________________________________________________________________________________
   ; CASO1   
   CASO_UNO PROC
   MOV CH,00H
   MOV CONTADOR_PARES,CH
   LEA DX,MEN1
   CALL ESCRIBE_CADENA
   CALL EMPAQUETA
   CALL ALIMENTAR_LINEA
   CALL VALIDAR_INICIO1
   MOV  CL,AL     ;FF ES EL M?XIMO 
 
   SIGUIENTE:  
    ;DATO QUEDA EN AL
    CALL READ_DATA  
    ; PROCESA_DATO
    MOV DX,0000
    MOV AX,BX
    CALL ES_PAR_VERI
    CMP CH,00H
    JE TERMINAMOS_VERI
    ;BUSCAR_ESPACIO PARA GUARDAR
    LEA SI,CONTENIDO
   REVISA:
    MOV CH,[SI]
    CMP CH,"$"
    JE SAVE
    INC SI
    JMP REVISA
   SAVE:
    
    CALL DESEMPAQUETA_Y_GUARDA
    MOV CH,20H
    MOV [SI],CH; GUARDAMOS UN ESPACIO
    MOV CH,CONTADOR_PARES
    INC CH
    MOV CONTADOR_PARES,CH
    
    
   TERMINAMOS_VERI: 
    DEC CL
    CMP CL,0H
    JE ENDING
    JMP SIGUIENTE
   
    ENDING:
    CALL ALIMENTAR_LINEA
    LEA DX,CONTENIDO
    CALL ESCRIBE_CADENA
    CALL ALIMENTAR_LINEA
    LEA DX,MEN3
    CALL ESCRIBE_CADENA
    MOV DL,CONTADOR_PARES
    CALL DESEMPAQUETA    
    RET
    CASO_UNO ENDP
   ;____________________________________________________________________________
   ;CASO DOS
   CASO_DOS PROC
     LEA DX,MEN5
     CALL ESCRIBE_CADENA
     CALL ALIMENTAR_LINEA
     MOV BX,0000 ;BX VA A SER NUESTRO ACUMULADOR
     MOV CX,64H  ; CONTADOR DEL 100 AL 1
    SUMATORIA:
     ADD BX,CX
     DEC CL   
     CMP CL,0H
     MOV DL,BH
     JNE SUMATORIA
     MOV DL,BH
     CALL DESEMPAQUETA
     MOV DL,BL
     CALL DESEMPAQUETA ;LA SUMA NO DEBE SER MAYOR A UN BYTE
     RET
    CASO_DOS ENDP
   ;_________________________________________________________________________________________________
   ;CASO_TRES
   CASO_TRES PROC
   
   MOV CH,00H
   MOV SUMH,CH
   MOV SUML,CH
   LEA DX,MEN6
   CALL ESCRIBE_CADENA
   CALL EMPAQUETA
   CALL VALIDAR_INICIO1
   CALL ALIMENTAR_LINEA
   MOV CH,00H
   MOV CL,AL
   ;MOV CX,10
   OTRO:   PUSH CX
   CALL SEMILLA
   CALL ALEATORIO
   CALL ESCALANDO
   ;NUMERO ALEATORIO EN AL
   PUSH DX
   CLC   
   MOV DH,SUMH
   MOV DL,SUML
   ADD DL,AL
   ADC DH,0H
   MOV SUMH,DH
   MOV SUML,DL
   POP DX
   CALL LEE
   
   POP CX
   LOOP OTRO
   
   LEA DX,MEN3
   CALL ESCRIBE_CADENA 
   MOV DL,SUMH
   CALL DESEMPAQUETA
   MOV DL,SUML
   CALL DESEMPAQUETA
   CALL ALIMENTAR_LINEA
   RET
   
   CASO_TRES ENDP
CODIGO ENDS                 ;Fin segemento de codigo
END MAIN 