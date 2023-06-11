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

.CODE
MAIN PROC
    INICIO_DC
    ;procedemos a trabajar en pixeles
    
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

    POSICIONA_CURSOR 6,19
    ESCRIBE_CADENA MSG
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

END MAIN