;PROGRAMA QUE POSICIONA CURSOR E IMPRIME UN TEXTO EN ESCALERA
; Definicion de stack
.MODEL small
.STACK  100

;DEFINICION DE AREAS DE TRABAJO
.DATA
;variables. 
msg1 db "La escalera$", 0

.CODE
PRINCI PROC FAR
   ;PROTOCOLO
   push ds
   sub ax,ax
   push ax
   MOV AX,@DATA
   MOV DS,AX
  

   ;INICIA PROGRAMA

    ;modo de video 
    mov al, 13h     ;Modo Grafico. 40x25. 256 colores. 320x200 pixels. 1 Pagina 
    mov ah, 0 
    int 10h     ; definicion con la interrupcion del modo grafico 
    mov cx, 1   ; Contador en uno 
    mov dh, 1   ; asignamos antes del bucle para despues incrementar la fila 
    mov dl, 1   ; asignamos antes del bucle para despues incrementar la Columna                   

Cursor: 
    mov ah, 2   ;Funcion elegida la dos es decir AH = 2 int 10H 
    mov bh, 0   ;Modo normal 
    int 10h      ; Aqui esta int 10.. La primera vuelta empieza en 1,1 
                ; despues ira incrementando 
    push dx     ; EMPILAMOS el valor en la pila para imprimir 
    mov dx, offset msg1 
    mov ah, 9 
    int 21h     ; Imprimimos el msg1
    pop dx      ; devolvemos el ultimo valor de DX 
    inc cx       ; Incrementamos el contador... 
    inc dh      ; La Fila, tambien al igual que 
    inc dl      ; la columna 
    cmp cx, 16  ;Comparamos el contador con 16 
    jne cursor  ; SI NO ES IGUAL.. Va a la etiqueta cursor... 

salir: 
    ret         


                       
       


PRINCI ENDP



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
  
