;dibujado pixel a pixel
INCLUDE MACRO.LIB
.MODEL SMALL
.STACK 100h

.DATA
    
    MSG DB "SALIR $"
    
    ALTURA DB 0
    ANCHO DB 0
    INICIOC DB 0
    INICIOR DB 0
    FINC DB 0
    FINR DB 0
    COLOR DB 05H
     
    MODE DB ? 
    TIEMPO1 DW 0
    TIEMPO2 DW 0
    

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
            
.CODE
MAIN PROC
    INICIO_DC
    ;procedemos a trabajar en pixeles
    MOV ES,AX
    mov MODE, 12h 
    CALL MODOVIDEO
    
    MOV ANCHO, 150 ; Ancho del rect?ngulo
    MOV ALTURA, 100 ; Altura del rect?ngulo
    
    MOV INICIOC,64H ;COLUMNA DE INICIA
    MOV INICIOR,32H ;RENGLON DE INICIO
    
    MOV AH,INICIOC
    MOV FINC,AH
    MOV AH,ANCHO
    ADD FINC,AH
    
    MOV AL,INICIOR
    MOV FINR,AL
    MOV AL,ALTURA
    ADD FINR,AL
    
    CALL DRAW_RECTANGLE
    
    I_MOUSE ;INICIALIZAMOS 
    M_MOUSE ;MOSTRAR EL PUNTERO
    

    POSICIONA_CURSOR 6,19
    ESCRIBE_CADENA MSG

    CALL DOBLE_CLICK
    
    CALL ENMASCARAR_CURSOR 
    M_MOUSE
    POSICIONA_CURSOR 20,5
    EXIT_PROGRAMA
    RET

MAIN ENDP

DRAW_RECTANGLE PROC
   PUSH BX
   PUSH CX
   PUSH DX
   
        MOV DH,0
        MOV DL,INICIOR
    FILA:
        MOV CH,0
        MOV CL,INICIOC
        
       OTRAC:
        CALL PIXEL
        INC CL
        CMP CL,FINC
        JNE OTRAC
        
        INC DL
        CMP DL,FINR
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
    mov al, MODE 
    mov ah, 0 
    int 10h 

RET
MODOVIDEO ENDP

DOBLE_CLICK PROC NEAR
SAL3:
    MOV AX, 03h ; Obtener estado de los botones del mouse
    INT 33h
    CMP BX, 01h ; Bot?n izquierdo presionado
    JNE SAL3

    ;GUARDAMOS INFO DEL CLICK
        MOV AX, 02H ; Inicializar temporizador del sistema
        INT 1Ah ; Leer el temporizador del sistema en CX:DX
        MOV tiempo1, DX ; Guardar el valor del temporizador del primer clic
    

    WAIT_SECOND_CLICK:
        MOV AX,02H
        INT 1AH
        
        SUB DX,TIEMPO1
        CMP DL,03H             ;Ignoramos los segundo y hablamos en terminos de microsegundos
        JB WAIT_SECOND_CLICK ; Si no ha pasado el tiempo suficiente, esperar mas

        
        ;segundo click
        MOV AX, 03h ; Obtener estado de los botones del mouse
        INT 33h
        CMP BX, 01h ; Bot?n izquierdo presionado
        JNE SAL3
        MOV AX, 0 ; Reiniciar temporizador del sistema
        INT 1Ah ; Leer el temporizador del sistema en DX:AX
        
        MOV AX,TIEMPO1
        MOV DX,TIEMPO2
        CMP AX,DX
        JE SAL3
        ; Si llegamos a este punto, se ha detectado un doble clic
        ESCRIBE_CADENA MSG ;Letrero para probar
        JMP SAL1

SAL1:
    RET
DOBLE_CLICK ENDP

ENMASCARAR_CURSOR PROC
    mov ax,09h ;con la forma personalizada 
    xor bx,bx
    xor cx,cx
    lea dx,enmascarar_puntero
    INT 33H
    ret
ENMASCARAR_CURSOR ENDP


END MAIN