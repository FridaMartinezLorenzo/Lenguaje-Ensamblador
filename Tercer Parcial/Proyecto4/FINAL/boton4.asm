;dibujado pixel a pixel
EXTRN I_MOUSE: NEAR
EXTRN M_MOUSE: NEAR
EXTRN POSICIONA_CURSOR: NEAR
EXTRN ESCRIBE_CADENA: NEAR
EXTRN SAL_A_DOS: NEAR
.MODEL SMALL
.STACK 100h

.DATA
    
    MSG DB "SALIR $"
    
    ;DATOS DEL RECT?NGULO 
    ALTURA DW 0 
    ANCHO DW 0
    INICIOC DW 0
    INICIOR DW 0
    FINC DW 0
    FINR DW 0
    COLOR DB 05H
     
    ;VARIABLE PARA EL MODO GRAFICO
    MODE DB ? 
    
    ;TIEMPO DE LOS CLICKS
    TIEMPO1 DW 0
    TIEMPO2 DW 0
    
    ;COORDENADAS DEL CLICK
    X1 DW 0 ;HORIZONTAL
    Y1 DW 0 ;VERTICAL
    X2 DW 0
    Y2 DW 0
    
    ;BANDERAS DE VALIDACION 
    B1 DB 0
    B2 DB 0
    
    ENMASCARAR_PUNTERO   dw 1111110000111111b  
            dw 1111110000111111b              
            dw 1111110000111111b
            dw 1111110000111111b
            dw 1111110000111111b
            dw 1111110000111111b
            dw 0000000000000000b
            dw 0000000000000000b
            dw 0000000000000000b
            dw 0000000000000000b
            dw 1111110000111111b              
            dw 1111110000111111b
            dw 1111110000111111b
            dw 1111110000111111b
            dw 1111110000111111b
            dw 1111110000111111b
            ;TRANSPARENTE(0) O NO(1)
            dw 0000011111100000b 
            dw 0000010000100000b              
            dw 0000010000100000b
            dw 0000010000100000b
            dw 0000010000100000b
            dw 1111110000111111b
            dw 1000000000000001b
            dw 1000000000000001b
            dw 1000000000000001b
            dw 1000000000000001b
            dw 1111110000111111b              
            dw 0000010000100000b
            dw 0000010000100000b
            dw 0000010000100000b
            dw 0000010000100000b
            dw 0000011111100000b            
.CODE
MAIN PROC
    PUSH DS
    SUB AX,AX
    PUSH AX
    MOV AX,@data
    MOV DS,AX 
    MOV ES,AX
   
    ;procedemos a trabajar en pixeles
    MOV MODE, 12h 
    CALL MODOVIDEO
    
    MOV ANCHO, 150 ; Ancho del rectangulo
    MOV ALTURA, 100 ; Altura del rectangulo
    
    MOV INICIOC,64H ;COLUMNA DE INICIA
    MOV INICIOR,32H ;RENGLON DE INICIO
    
    MOV AX,INICIOC
    MOV FINC,AX
    MOV AX,ANCHO
    ADD FINC,AX
    
    MOV AX,INICIOR
    MOV FINR,AX
    MOV AX,ALTURA
    ADD FINR,AX
    
    CALL DRAW_RECTANGLE
    
    CALL I_MOUSE ;INICIALIZAMOS 
    CALL M_MOUSE ;MOSTRAR EL PUNTERO
    
    MOV DH,6 ;RENGLON
    MOV DL,19 ;COLUMNA
    CALL POSICIONA_CURSOR 
    LEA DX,MSG
    CALL ESCRIBE_CADENA
    
    OTRA_VEZ:
    MOV AX,0
    MOV BX,0
    MOV CX,0
    MOV DX,0
    CALL DOBLE_CLICK
    CALL RASTREAR_COORDENADA
    CMP B2,0
    ;JE ESPERA
    JE OTRA_VEZ
    CALL ENMASCARAR_CURSOR 
    CALL M_MOUSE
    JMP FIN_PROGRAMA
    
    ESPERA:
      WAIT_CLICK:
        MOV AX,02H ;Read Real-Time Clock Time
        INT 1AH    ;DX tiene segundos(DH) y microsegundos (DL)
        
        SUB DX,TIEMPO1
        CMP DL,03H             ;Ignoramos los segundo y hablamos en terminos de microsegundos
        JB WAIT_CLICK   ; Si no ha pasado el tiempo suficiente, esperar mas
       JMP OTRA_VEZ
       
       
    FIN_PROGRAMA:
    MOV DH,20 ;RENGLON
    MOV DL,05 ;COLUMNA
    CALL POSICIONA_CURSOR
    CALL SAL_A_DOS
    RET

MAIN ENDP

DRAW_RECTANGLE PROC
   PUSH BX
   PUSH CX
   PUSH DX
           
        MOV DX,INICIOR
    FILA:
        MOV CX,INICIOC
        
       OTRAC:
        CALL PIXEL
        INC CX
        CMP CX,FINC
        JNE OTRAC
        
        INC DX
        CMP DX,FINR
        JNE FILA
        
        
   POP DX
   POP CX
   POP BX     

   RET
DRAW_RECTANGLE ENDP

PIXEL PROC
PUSH AX
PUSH BX
    MOV AH,0CH
    MOV AL,COLOR
    MOV BH,0
    ;MOV CX,COL
    ;MOV DX,REN
    INT 10H
POP BX
POP AX
RET
PIXEL ENDP

MODOVIDEO PROC
    ; modo de video 
    MOV AL,MODE
    MOV AH,0
    INT 10H
RET
MODOVIDEO ENDP

DOBLE_CLICK PROC NEAR
SAL3:
    MOV AX, 03h ; Obtener estado de los botones del mouse
    INT 33h
    CMP BX, 01h ; Boton izquierdo presionado
    JNE SAL3
    ;GUARDAMOS COORDENADAS
    MOV X1,CX
    MOV Y1,DX
    ;GUARDAMOS INFO DEL PRIMER CLICK
        MOV AX, 02H     ; Read Real-Time Clock Time
        INT 1Ah 
        MOV TIEMPO1, DX ; Guardar el valor del temporizador del primer click
    
    
    WAIT_SECOND_CLICK:
        MOV AX,02H ;Read Real-Time Clock Time
        INT 1AH    ;DX tiene segundos(DH) y microsegundos (DL)
        
        SUB DX,TIEMPO1
        CMP DL,03H             ;Ignoramos los segundo y hablamos en terminos de microsegundos
        JB WAIT_SECOND_CLICK   ; Si no ha pasado el tiempo suficiente, esperar mas

        
        ;Segundo click
        MOV AX, 03h ; Obtener estado de los botones del mouse
        INT 33h
        CMP BX, 01h ; Boton izquierdo presionado
        JNE SAL3
        
        ;GUARDAMOS COORDENADAS
        MOV X2,CX
        MOV Y2,DX
        ;COMPARAMOS 
        MOV AX,X1
        MOV BX,X2
        CMP AX,BX
        JNE SAL3
        MOV AX,Y1
        MOV BX,Y2
        CMP AX,BX
        JNE SAL3
        
        ;GUARDAMOS INFO DEL SEGUNDO CLICK
        MOV AX, 02H ; Read Real-Time Clock Time
        INT 1Ah 
        MOV TIEMPO2, DX ; Guardar el valor del temporizador del segundo click
        
        
        MOV AX,TIEMPO1
        MOV DX,TIEMPO2
        CMP AX,DX
        JE SAL3
        ; Si llegamos a este punto, se ha detectado un doble clic
        
        JMP SAL1

SAL1:
    RET
DOBLE_CLICK ENDP

ENMASCARAR_CURSOR PROC
    MOV AX,09H ;Colocar un cursor personalizado
    XOR BX,BX
    XOR CX,CX
    LEA DX,ENMASCARAR_PUNTERO
    INT 33H
    RET
ENMASCARAR_CURSOR ENDP

RASTREAR_COORDENADA PROC
    ;BASTA CON EVALUAR UNA DE LAS DOS PUES YA SE VALIDO SON IGUALES
    
    MOV AX,X1
   
    MOV CX,INICIOC
    
    COL:
        CMP AX,CX
        JE BANDERA1
        INC CX
        CMP CX,FINC
        JNE COL
 
        JMP FIN_R ;NO COINCIDIO, FINALIZAMOS DE UNA VEZ
      
     VALIDA2:
        MOV AX,Y1
        MOV CX,INICIOR
        REN:
            CMP AX,CX
            JE BANDERA2
            INC CX
            CMP CX,FINR
            JNE REN
        JMP FIN_R
        
     BANDERA1:
        MOV B1,1
        JMP VALIDA2
        
     BANDERA2:
        MOV B2,1
    
  FIN_R:
    RET
RASTREAR_COORDENADA ENDP

END MAIN