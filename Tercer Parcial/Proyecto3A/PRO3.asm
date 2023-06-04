;Juego del ahorcado 402-B
;PROYECTO 3
;INTEGRANTES:   Elorza Vel?squez Jorge Aurelio
;               Martinez Lorenzo Frids Ximena

INCLUDE MACRO.LIB
; DEFINICION SEGMENTO DE PILA
    PILA segment para stack 'stack'       
        DB 120 DUP (0)                   ; Define espacio en la pila
    PILA ENDS

; DEFINICION  SEGMENTO DE DATOS
DATOS SEGMENT PARA 'DATA'
    MSG1 DB 'Ingrese palabra:$'
    CADENA1 DB 31, ?, 31 DUP ("$"), "$"
    CADENA2 DB 31, ?, 31 DUP ("$"), "$"
    CADENA3 DB 31, ?, 31 DUP ("$"), "$"
    CADENA4 DB 31, ?, 31 DUP ("$"), "$"
    CADENA5 DB 31, ?, 31 DUP ("$"), "$"
    GAME1   DB 'Empecemos                  No. Intentos:$' 
    MSG2    DB 'Ingrese caracter: $'
    CADENA_AUX DB 31 DUP (20H),"$","$"
    INTENTOS DB 0
    GAME_OVER DB "HAS LLEGADO AL LIMITE DE INTENTOS, INTENTALO DE NUEVO :)$"
    CONGRA DB "FELICIDADES, LO HAS HECHO BIEN :)$"
    MSG3 DB 'CADENAS INGRESADAS: $'
    BANDERA1 DB 0
DATOS ENDS


; DEFINICION  SEGMENTO DE CODIGO
CODIGO SEGMENT PARA 'CODE'
  
 MAIN PROC FAR      
 ASSUME SS:PILA, DS:DATOS, CS:CODIGO
    INICIO_DL
    MOV ES,AX
    
    ; Establecer el modo VGA 640x480 16 colores
    MOV AH, 0      ; Funci?n de configuraci?n de modo
    MOV AL, 12h
    INT 10h
    
    ; Establecer el color de fondo (negro)
    MOV AH, 0Bh
    MOV BH, 0
    MOV BL, 0  ; C?digo de color de fondo (negro)
    INT 10h
    
    ; Elegir paleta
    MOV BH, 1
    MOV BL, 0  ; Seleccionar paleta
    INT 10h
    
    ;INGRESO DE PALABRAS
    MOV CX,05
    SIGUIENTE:
        LIMPIAR_PANTALLA 70H
        POSICIONA_CURSOR 8,30
        ESCRIBE_CADENA MSG1
        POSICIONA_CURSOR 12,25
        CMP CX,05
        JE CAD1
        CMP CX,04
        JE CAD2
        CMP CX,03
        JE CAD3
        CMP CX,02
        JE CAD4
        CMP CX,01
        JE CAD5
        VERIFICA:
        CMP CX,0
        JE NEXT_STEP
        ;DEC CX 
        JMP SIGUIENTE
        
        CAD1: 
            LEERCADENA CADENA1
            DEC CX
            JMP VERIFICA
        CAD2: 
            LEERCADENA CADENA2
            DEC CX
            JMP VERIFICA
        CAD3: 
            LEERCADENA CADENA3
            DEC CX
            JMP VERIFICA
        CAD4: 
            LEERCADENA CADENA4
            DEC CX
            JMP VERIFICA
        CAD5: 
            LEERCADENA CADENA5
            DEC CX
            JMP SIGUIENTE
    
        NEXT_STEP:
        LIMPIAR_PANTALLA 70H
            POSICIONA_CURSOR 1,1
            
            ESCRIBE_CADENA MSG3
            SALTAR
            SALTAR
            ESCRIBE_CADENA CADENA1+2
            SALTAR
            ESCRIBE_CADENA CADENA2+2
            SALTAR
            ESCRIBE_CADENA CADENA3+2
            SALTAR
            ESCRIBE_CADENA CADENA4+2
            SALTAR
            ESCRIBE_CADENA CADENA5+2
            SALTAR
            LEE
            
            CALL ELEGIR_CADENA
   
 RET
 MAIN ENDP               ;Fin proceso (FIN DEL MAIN)

 
SEMILLA PROC
    PUSH AX
    MOV AH,2CH ; SERVICIO 2CH OBTIENE LA HORA ACTUAL EN EL SISTEMA
    INT 21H ; RETORNA CH=HORAS, EN FORMATO 00-23, MEDIANOCHE=0

    ; CL MINUTOS 00-59
    ; DH SEGUNDOS 00-59
    ; DL CENTESIMAS DE SEGUNDO 00-99

    POP AX
    RET
SEMILLA ENDP

ALEATORIO PROC
    ; XN+1=(2053*XN + 13849)MOD (2**16-1)
    ; RETORNA EL NUMERO PSEUDOALEATORIO EN AX
    MOV AX,DX ;CARGANDO A AX EL NUMERO SEMILLA tomado de la int 21H serv  2CH
    MOV DX,0 ;CARGANDO CERO EN LA POSICION MAS SIGNIFICATIVA DEL MULTIPLICANDO
    MOV BX,2053 ; MULTIPLICADOR
    MUL BX
    MOV BX,13849 ;CARGA EN BX LA CONSTANTE ADITIVA
    CLC
    ADD AX,BX ; SUMA PARTES MENOS SIGNIFICATIVAS DEL RESULTADO
    ADC DX,0 ; SUMA EL ACARREO SI ES NECESARIO
    MOV BX,0FFFFH ; CARGAR LA CONSTANTE 2**16-1
    DIV BX
    MOV AX,DX ;MUEVE EL RESIDUO AX
    RET
ALEATORIO ENDP

ESCALANDO PROC
    ; ESCALANDO EL NUMERO PSEUDOALEATORIO OBTENIDO
    MOV DX,0
    MOV BX,05H ;NUMEROS ALEATORIOS ENTRE 0 Y 9
    DIV BX
    ADD DL,DH
    CMP DL,0
    JE SUMA1
    JMP FIN_ES
    SUMA1:
        INC DL
    FIN_ES: ;DATO QUEDA EN DL
    RET
ESCALANDO ENDP

ELEGIR_CADENA PROC
PUSH CX
    CALL SEMILLA
    CALL ALEATORIO
    CALL ESCALANDO
    
    CMP DL,01
    JE C1
    CMP DL,02
    JE C2
    CMP DL,03
    JE C3
    CMP DL,04
    JE C4
    CALL ASIGNA5
    JMP SIGUIENTE_PASO
    C1:
        CALL ASIGNA1
        JMP SIGUIENTE_PASO
    C2:
        CALL ASIGNA2
        JMP SIGUIENTE_PASO
    C3:
        CALL ASIGNA3
        JMP SIGUIENTE_PASO
    C4:
        CALL ASIGNA4
        JMP SIGUIENTE_PASO
        
    SIGUIENTE_PASO:
    
POP CX
ELEGIR_CADENA ENDP

ASIGNA1 PROC
     MOSTRAR_BASE CADENA1
     DESARROLLO CADENA1, CADENA_AUX
    RET
ASIGNA1 ENDP

ASIGNA2 PROC
     MOSTRAR_BASE CADENA2
     DESARROLLO CADENA2, CADENA_AUX
    RET
ASIGNA2 ENDP

ASIGNA3 PROC
     MOSTRAR_BASE CADENA3
     DESARROLLO CADENA3, CADENA_AUX
    RET
ASIGNA3 ENDP

ASIGNA4 PROC
     MOSTRAR_BASE CADENA4
     DESARROLLO CADENA4,CADENA_AUX
    RET
ASIGNA4 ENDP

ASIGNA5 PROC
     MOSTRAR_BASE CADENA5
     DESARROLLO CADENA5, CADENA_AUX
    RET
ASIGNA5 ENDP

;_______________________________________________________

ACTUALIZAR_INTENTOS PROC
         ADD INTENTOS,1
         MOV AL,INTENTOS
         POSICIONA_CURSOR 2,60
         DESEMPAQUETA AL
         CMP AL,3
         JE DIBUJO3
         ;PROCEDEMOS A COMPARAR PARA VER QUE DIBUJO SE VA A MOSTRAR
         CMP AL,01
         JE DIBUJO1
         CMP AL,02
         JE DIBUJO2
         JMP FIN_ACTUALIZAR
         
        DIBUJO1:
            ; Llamar a crear el soporte
            CALL DRAW_SUPPORT
            MOV BH,01 ;ES UNA BANDERA QUE SE VALIDA EN LA MACRO, NOS DICE QUE AUN TIENE INTENTOS
            JMP FIN_ACTUALIZAR
        DIBUJO2:
            CALL HEAD
            MOV BH,01 ;ES UNA BANDERA QUE SE VALIDA EN LA MACRO, NOS DICE QUE AUN TIENE INTENTOS
            JMP FIN_ACTUALIZAR
        
        DIBUJO3:
            CALL BODY
            CALL RIGHT_HAND
            CALL LEFT_HAND
            CALL LEFT_LEG
            CALL RIGHT_LEG
            POSICIONA_CURSOR 40,70
            LEE
         
        FIN_PARTIDA_BAD:
            LIMPIAR_PANTALLA 05H
            POSICIONA_CURSOR 10,3
            ESCRIBE_CADENA GAME_OVER
            LEE
            EXIT_PROGRAMA
    FIN_ACTUALIZAR:
    RET
ACTUALIZAR_INTENTOS ENDP
     
;____________________________________________________________________

COPY PROC
         MOV BH,01
         MOV [SI],AL
         INC DI
         INC SI
    RET
COPY ENDP         
;_____________________________________________________________________
COMPARAR_CADENAS PROC
PUSH DI
PUSH SI
    ;DI APUNTA A CADENAX(SEA X 1,2,3,4,5)
    ;SI APUNTA A CADENA_AUX
    ;CADENAX+1 (LONGITUD)
    CLD
    MOV CX,0
    MOV CL,[DI]
    INC DI
    REPE CMPSB
    JNE EDO1 ; SALTA A COMPARAR ESTADO DE LAS BANDERAS
    MOV BANDERA1,01

    EDO1: 
    CMP BANDERA1,01
    JNE MAL1
        LIMPIAR_PANTALLA 50H
        POSICIONA_CURSOR 13,05
        ESCRIBE_CADENA CONGRA
        LEE
        EXIT_PROGRAMA
    JMP EXIT
    MAL1: 
 POP SI
 POP DI
 EXIT:
 RET   
COMPARAR_CADENAS ENDP
;____________________________________________________________________________________________

;SUBRUTINAS PARA EL DIBUJO

;______________________________________________________________________________________________

DRAW_SUPPORT PROC NEAR
    MOV AH, 0Ch  ; Funci?n de escritura de pixel
    MOV AL, 3    ; Color amarillo?
    MOV BH, 0    ; P?gina 0
    MOV CX, 30   ; Columna
    
    STAND_OUTER:
        MOV DX, 90   ; Fila inicial
        STAND_INNER:
            INT 10h
            INC DX
            CMP DX, 350
            JL STAND_INNER
        INC CX
        CMP CX, 35
        JL STAND_OUTER
    
    ; Dibujar linea superior ___
    MOV AH, 0Ch  ; Funcion de escritura de p?xel
    MOV AL, 3    ; Color amarillo?
    MOV BH, 0    ; P?gina 0
    MOV DX, 90   ; Fila
    
    ULINE_OUTER:
        MOV CX, 30   ; Columna inicial
        ULINE_INNER:
            INT 10h
            INC CX
            CMP CX, 150
            JL ULINE_INNER
        INC DX
        CMP DX, 95
        JL ULINE_OUTER
    
    ; Dibujar l?nea inferior ___
    MOV AH, 0Ch  ; Funci?n de escritura de p?xel
    MOV AL, 3    ; Color amarillo?
    MOV BH, 0    ; P?gina 0
    MOV DX, 345  ; Fila
    
    BLINE_OUTER:
        MOV CX, 10   ; Columna inicial
        BLINE_INNER:
            INT 10h
            INC CX
            CMP CX, 50
            JL BLINE_INNER
        INC DX
        CMP DX, 350
        JL BLINE_OUTER
    
    ; Dibujar soporte inclinado
    MOV AH, 0Ch  ; Funci?n de escritura de p?xel
    MOV AL, 3    ; Color amarillo?
    MOV BH, 0    ; P?gina 0
    MOV DX, 90   ; Fila inicial
    MOV CX, 90   ; Columna inicial
    
    SLINE_OUTER:
        PUSH CX
        MOV BL, 0
        SLINE_INNER:
            INT 10h
            INC CX
            INC BL
            CMP BL, 7
            JL SLINE_INNER
        INC DX
        POP CX
        DEC CX
        CMP DX, 151
        JL SLINE_OUTER
    
    ; Dibujar cuerda
    MOV AH, 0Ch  ; Funci?n de escritura de p?xel
    MOV AL, 3    ; Color amarillo?
    MOV BH, 0    ; P?gina 0
    MOV DX, 90   ; Fila
    
    ROPE_OUTER:
        MOV CX, 120  ; Columna inicial
        ROPE_INNER:
            INT 10h
            INC CX
            CMP CX, 125
            JL ROPE_INNER
        INC DX
        CMP DX, 160
        JL ROPE_OUTER
    
    RET
DRAW_SUPPORT ENDP


;--------------------------------------Subrutinas para crear el cuerpo del matado :v------------------------------------------
HEAD PROC NEAR
    ;AL = color       
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    MOV AH, 0CH ;WRITE PIXEL      
    MOV AL, 2  ;Color rojo
    MOV BH, 0    ;PAGE 0
    
    MOV DX, 160   ;ROW
    
H1_OUTER:
    MOV CX, 102   ;STARTING COLUMN
H1_INNER:
    INT 10H
    INC CX
    CMP CX, 143
    JL H1_INNER
    INC DX
    CMP DX, 165
    JL H1_OUTER
     
    MOV DX, 195   ;ROW        
H2_OUTER:
    MOV CX, 102   ;STARTING COLUMN
H2_INNER:
    INT 10H
    INC CX
    CMP CX, 143
    JL H2_INNER
    INC DX
    CMP DX, 200
    JL H2_OUTER
 
    MOV DX, 165   ;ROW        
H3_OUTER:
    MOV CX, 102   ;STARTING COLUMN
H3_INNER:
    INT 10H
    INC CX
    CMP CX, 107
    JL H3_INNER
    INC DX
    CMP DX, 195
    JL H3_OUTER
     
    MOV DX, 165   ;ROW        
H4_OUTER:
    MOV CX, 138   ;STARTING COLUMN
H4_INNER:
    INT 10H
    INC CX
    CMP CX, 143
    JL H4_INNER
    INC DX
    CMP DX, 195
    JL H4_OUTER
    
    POP DX
    POP CX
    POP BX
    POP AX
    RET
HEAD ENDP


BODY PROC NEAR
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    MOV AH,0CH ;WRITE PIXEL      
    MOV AL,2   ;COLOR rojo
    MOV BH,0    ;PAGE 0
    MOV DX,200   ;ROW
    
    BODY_OUTER:
    MOV CX,119   ;STARTING COLUMN
        BODY_INNER:
            INT 10H
            INC CX
            CMP CX,126
            JL BODY_INNER
        INC DX
        CMP DX,265
        JL BODY_OUTER
    POP DX
    POP CX
    POP BX
    POP AX
    RET
BODY ENDP

RIGHT_HAND PROC NEAR
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    MOV AH,0CH ;WRITE PIXEL      
    MOV AL,2   ;COLOR rojo
    MOV BH,0    ;PAGE 0
    MOV DX,215   ;STARTING ROW
    MOV CX,119   ;STARTING COLUMN
    
    rHAND_OUTER:
        PUSH CX
        MOV BL,0
        rHAND_INNER:
            INT 10H
            INC CX
            INC BL
            CMP BL,7
            JL rHAND_INNER
        INC DX
        POP CX
        DEC CX
        CMP DX,245
        JL rHAND_OUTER
    POP DX
    POP CX
    POP BX
    POP AX
    RET
RIGHT_HAND ENDP

LEFT_HAND PROC NEAR
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    MOV AH,0CH  ;WRITE PIXEL      
    MOV AL,2    ;COLOR rojo
    MOV BH,0    ;PAGE 0
    MOV DX,215  ;STARTING ROW
    MOV CX,119  ;STARTING COLUMN
    
    lHAND_OUTER:
        PUSH CX
        MOV BL,0
        lHAND_INNER:
            INT 10H
            INC CX
            INC BL
            CMP BL,7
            JL lHAND_INNER
        INC DX
        POP CX
        INC CX
        CMP DX,245
    JL lHAND_OUTER
    POP DX
    POP CX
    POP BX
    POP AX
    RET
LEFT_HAND ENDP

LEFT_LEG PROC NEAR
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    MOV AH,0CH ;WRITE PIXEL      
    MOV AL,2   ;COLOR rojo
    MOV BH,0    ;PAGE 0
    MOV DX,265   ;STARTING ROW
    MOV CX,119   ;STARTING COLUMN
    
    lLEG_OUTER:
        PUSH CX
        MOV BL,0
        lLEG_INNER:
            INT 10H
            INC CX
            INC BL
            CMP BL,7
            JL lLEG_INNER
        INC DX
        POP CX
        INC CX
        CMP DX,295
        JL lLEG_OUTER
    POP DX
    POP CX
    POP BX
    POP AX
    RET
LEFT_LEG ENDP


RIGHT_LEG PROC NEAR
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    MOV AH,0CH ;WRITE PIXEL      
    MOV AL,2   ;COLOR rojo
    MOV BH,0    ;PAGE 0
    MOV DX,265   ;STARTING ROW
    MOV CX,119   ;STARTING COLUMN
    
    rLEG_OUTER:
        PUSH CX
        MOV BL,0
        rLEG_INNER:
            INT 10H
            INC CX
            INC BL
            CMP BL,7
            JL rLEG_INNER
        INC DX
        POP CX
        DEC CX
        CMP DX,295
        JL rLEG_OUTER
    POP DX
    POP CX
    POP BX
    POP AX
    RET
RIGHT_LEG ENDP




CODIGO ENDS
END MAIN