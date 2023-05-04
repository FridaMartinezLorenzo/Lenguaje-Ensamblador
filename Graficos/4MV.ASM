;PROGRAMA QUE MUESTRA DIFERENTES MODOS DE VIDEO

; Definicion de stack
.MODEL small
.STACK  100

;DEFINICION DE AREAS DE TRABAJO
.DATA
;variables. 
Modo1 db "Modo Grafico. 40x25. 256 colores. 320x200 pixels. 1 Pagina$", 0  
Modo2 db "Modo Texto. 80x25. 16 colores. 8 Paginas$",0 
Modo3 db "Modo Texto. 40x25. 16 colores. 8 Paginas$", 0  
MODEACT DB ?  
MODE DB ? 
COLOR db ?
COL DW ?
REN DW ?


.CODE
PRINCI PROC FAR
   ;PROTOCOLO
   push ds
   sub ax,ax
   push ax
   MOV AX,@DATA
   MOV DS,AX
  

   ;INICIA PROGRAMA
    CALL ACTUAL
    MOV MODEACT,AL

    ;--------------------------------
    ; modo de video :Modo Texto. 40x25. 16 colores. 8 PaginaS
    mov MODE,00h 
    CALL MODOVIDEO
    
    ;imprimimos cadena del modo GRAFICO 
    mov dx, offset Modo3 
    mov ah, 9 
    int 21h 
    ; hacemos esperar al programa que el usuario toque una tecla                   
    mov ah,0 
    int 16h  

    ;--------------------------
    ;Convetimos al modo 80x25 e imprimimos la cadena en tipo texto   
    mov MODE, 03h 
    CALL MODOVIDEO 

    mov dx, offset Modo2 
    mov ah, 9 
    int 21h  
    ;idem 40x25  
    mov ah, 0 
    int 16h 
    ;-------------------------------------------------------
    ;Convetimos al Modo Grafico. 40x25. 256 colores. 320x200 pixels. 1 Pagina
    mov MODE, 12h 
    CALL MODOVIDEO

    mov dx, offset Modo1 
    mov ah, 9 
    int 21h 
    mov ah, 0 
    int 16h 
    
    ;----------------------------------------------------
    ;RESTAURACI?N DEL MODO DE VIDEO INICIAL
    MOV AL, MODEACT
    mov MODE, AL
    CALL MODOVIDEO


    ;devolvemos el handle a Windows  
    ret                           
       


PRINCI ENDP

PIXEL PROC
;Subrutina p?xel
MOV AH,0CH
MOV AL,COLOR
MOV BH,0
MOV CX,COL
MOV DX,REN
INT 10H
RET
PIXEL ENDP

ACTUAL PROC
MOV AH,0Fh
INT 10H
RET
ACTUAL ENDP


MODOVIDEO PROC

    ; modo de video 
    mov al, MODE 
    mov ah, 0 
    int 10h 

RET
MODOVIDEO ENDP


ESCRIBE PROC
   MOV AH,02
   INT 21H
 RET
ESCRIBE ENDP

SALIR_DOS PROC
   MOV AH,4CH
   INT 21H
RET
SALIR_DOS ENDP

LEE PROC
   MOV AH,01
   INT 21H
RET
LEE ENDP

POS_CUR PROC
PUSH AX
PUSH BX
PUSH DX
MOV AH,02
MOV BH,0
MOV DH,05
MOV DL,20
INT 10h
POP DX
POP BX
POP AX
RET
POS_CUR ENDP

limpiar_pantalla PROC
PUSH AX
PUSH BX
PUSH CX
PUSH DX
MOV AX,0600h
MOV BH,71h      ; FONDO BLANCO CON PRIMER PLANO AZUL
MOV CX,0000H
MOV DX,184FH
INT 10h
POP DX
POP CX
POP BX
POP AX
RET
limpiar_pantalla ENDP


END PRINCI
  
