;PROGRAMA QUE DIBUJA Y MUEVE UN PUNTO UTILIZANDO INT 21 SERV 07
; Definicion de stack
.MODEL small
.STACK  100

;DEFINICION DE AREAS DE TRABAJO
.DATA
;variables. 
 Y DW 320                ;Centro de la pantalla en Y (Horizontalmente)
 X DW 240                ;Centro de la pantalla en X (Verticalmente)
 COLOR DB 0
Modog db "Modo GRAFICO 80x30 8x16 640x480 16/256k A000 VGA, ATI, VIP $", 0 

.CODE
PRINCI PROC FAR
   ;PROTOCOLO
   push ds
   sub ax,ax
   push ax
   MOV AX,@DATA
   MOV DS,AX
  

   ;INICIA PROGRAMA

    CALL GRAPH                   ;Iniciamos modo gr?fico
    mov dx, offset ModoG 
    mov ah, 9 
    int 21h 
    mov ah, 0 
    int 16h 

OTRO:                   
        
    MOV COLOR,15
    CALL PUNTO              ;Dibujamos punto (La primera iteraci?n es el centro de la pantalla)
        CALL READKEY                 ;Esperamos se *PRESIONE* una tecla         
        CMP AL,56               ;Tecla 8 sube
                JE UP           ;Etiqueta que DECREMENTA RENGLON X= X-1
        CMP AL,50               ;Tecla 2 baja
                JE DOWN         ;Etiqueta que INCREMENTA RENGLON X=X+1
        CMP AL,54               ;Tecla 6 derecha
                JE RIGHT        ;Etiqueta que INCREMENTA COLUMNA Y = Y + 1
        CMP AL,52               ;Tecla 4 izquierda
                JE LEFT         ;Etiqueta que DECREMENTA COLUMNA Y = Y - 1
        CMP AL,27               ;ESC termina el programa
                JE SALIR        ;Etiqueta que va a donde se regresa a modo MSDOS, y termina el programa
                        JnE OTRO        ;Otra iteraci?n o ciclo (Leemos otra tecla para mover punto)

        UP:                     ;Subimos punto
        MOV COLOR,0
        CALL PUNTO      ;Punto de color del fondo para ocultar posici?n anterior
        ;DEC X           ;Decrementamos X
        sub x, 10
                JMP OTRO        ;Etiqueta donde dibuja otro punto (con los nuevos valores)

        DOWN:                   ;Bajamos punto
                MOV COLOR,0     ;Punto de color del fondo para ocultar posici?n anterior
        CALL PUNTO 
                INC X           ;Incrementamos X
                JMP OTRO        ;Etiqueta donde dibuja otro punto (con los nuevos valores)

        RIGHT:                  ;Desplazamos a la derecha el punto
                MOV COLOR,0     ;Punto de color del fondo para ocultar posici?n anterior
        CALL PUNTO 
        ;INC Y           ;Incrementamos Y
        add y, 10
                JMP OTRO        ;Etiqueta donde dibuja otro punto (con los nuevos valores)

        LEFT:                   ;Punto de color del fondo para ocultar posici?n anterior
                MOV COLOR,0     ;Desplazamos a la izquierda el punto
        CALL PUNTO 
                DEC Y           ;Decrementamos Y
                JMP OTRO        ;Etiqueta donde dibuja otro punto (con los nuevos valores)

        SALIR:                  ;Etiqueta que representa el final de la aplicaci?n.
       CALL DOS                             ;Regresamos al modo ambiente MSDOS
                                        ;Termina ejecuci?n de aplicaci?n y devuelve el control al sistema operativo



RET

PRINCI ENDP

READKEY PROC                   ;Equivalente de ReadKey en otros lenguajes
                MOV AH,07H      ;STDIN, direct input, no echo (Func 07/int 21h)
                INT 21h         ;Interrupt 21h DOS Funcions
        RET
READKEY   ENDP

GRAPH PROC                    ;Inicia modo gr?fico
                MOV AH,00H      ;Set video mode (Func 00/int 10h)
                MOV AL,12H      ;12h = 80x30 8x16 640x480 16/256k A000 VGA, ATI, VIP
                INT 10H         ;Interrupt 10h Video functions
        RET
GRAPH   ENDP


PUNTO PROC           ;Dibuja un punto en la pantalla (En modo gr?fico)
                MOV AH,0CH              ;Func 0C/Int 10h
                MOV AL,COLOR    ;color 0-15
                MOV BH,0                ;pagina (0 por default en esta aplicaci?n)
                MOV CX,Y                ;Columna
                MOV DX,X                ;Fila
                INT 10H         ;Interrupt 10h Video functions
        RET
PUNTO  ENDP

        
FONDO   PROC           ;Define la paleta de colores
                MOV AH,0BH      ;Set coloR palette (Func 0B/Int 10h)
                MOV BH,0H       ;
                MOV BL,COLOR   ;color 0-15
                INT 10H         ;Interrupt 10h Video functions
        RET
FONDO  ENDP
        
DOS PROC                       ;Inicia/Regresa a modo MSDOS
                MOV AH,00H      ;Set video mode (Func 00/int 10h)
                MOV AL,03H      ;03h = 80x25 8x8 16 4 B800 CGA
                INT 10H         ;Interrupt 10h Video functions
        RET
DOS  ENDP




END PRINCI
  
