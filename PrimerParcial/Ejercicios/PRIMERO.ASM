;Ejemplo para Ensamblar con Directivas Largas
;programa ejemplo para masm

; DEFINICION SEGMENTO DE PILA
STACKSG segment para stack 'stack'       
        DB 20 DUP (0)                   ; Define espacio en la pila
STACKSG ENDS

;DEFINICION DE AREAS DE TRABAJO

 ; DEFINICION  SEGMENTO DE DATOS
DATASG SEGMENT PARA 'DATA'
MEN1 DB ' HOLA MUNDO SOY ESTUDIANTE DE INGENIERIA DE LA UTM$'
SALTA db 13, 10,'$'
MEN2 DB 'ADIOS$'
DATASG ENDS

; DEFINICION  SEGMENTO DE CODIGO
CODESG SEGMENT PARA 'CODE'
  
PRINCI PROC FAR                             ;Inicia proceso
      ASSUME SS:STACKSG, DS:DATASG,CS:CODESG ;  ;Alineaci?n de Segmentos
                                        ;PROTOCOLO
       PUSH DS
   SUB AX,AX
   PUSH AX
   MOV AX,SEG DATASG
   MOV DS,AX

   ;INICIA PROGRAMA
   mov ah,01             ; Funcion: Leer caracter
   int 21h               ; Servicio: 01 int 21h alto nivel DOS
   mov dx, offset SALTA     ; Obtiene direccion del mensaje en dx
   mov ah,09            ; Funcion: Visualizar cadena
   int 21h              ; Servicio: 09 int 21h alto nivel DOS
   mov dx, offset MEN1
   mov ah,09
   int 21h
   mov dx, offset SALTA
   mov ah,09
   int 21h
   mov dx, offset MEN2
   mov ah,09
   int 21h
    mov   ax,4c00h               ;Funccion :Quit with exit code (EXIT))
  int   21h                 ;Servicio:4c int 21 DOS
 
    RET
    PRINCI ENDP             ;Fin proceso
CODESG ENDS                 ;Fin segemento de c?dico
END PRINCI                  ;Fin de programa
