;Ejemplo para Ensamblar con Directivas Largas
;programa ejemplo para masm
;ES NECESARIO ALINEAR

; DEFINICION SEGMENTO DE PILA
    PILA segment para stack 'stack'       
        DB 20 DUP (0)                   ; Define espacio en la pila
    PILA ENDS

;DEFINICION DE AREAS DE TRABAJO

 ; DEFINICION  SEGMENTO DE DATOS
     DATOS SEGMENT PARA 'DATA'
MEN1 DB ' HOLA MUNDO SOY ESTUDIANTE DE INGENIERIA DE LA UTM$'
SALTA db 13, 10,'$';Retorno de carro(13), nueva l?nea(10)...como la m?quina de escribir
MEN2 DB 'ADIOS$'
MEN3 DB 'MAnANA LE SEGUIMOS$'
DATASG ENDS

; DEFINICION  SEGMENTO DE CODIGO
CODIGO SEGMENT PARA 'CODE'
  
 MAIN PROC FAR        ; SE ABRE EL MAIN                     ;Inicia proceso
 ASSUME SS:PILA, DS:DATOS, CS:CODIGO ;  ;AlineaciOn de Segmentos con el nombre del seg que definimos porque hace referencia al inicio del seg
   
     ;PROTOCOLO (FORZOSO CUANDO ESTAMOS EN DIRECTIVA LARGA)
   PUSH DS ; Guarda la direccion del segmento de datos (del proceso padre que va a iniciar el proceso, a fin de que no se pierda)
           ; cuando termine tiene que recobrar su direccion
   SUB AX,AX
   PUSH AX
   MOV AX,SEG DATOS ;GUARDA LA DIRECCION DEL SEGMENTO DE DATOS DE ESTE PROCESO
   MOV DS,AX

   ;INICIA PROGRAMA
   ;mov ah,01             ; Funcion: Leer caracter 
   ;int 21h               ; Servicio: 01 int 21h alto nivel DOS
   
   
   ;asocia el ah a la interrupcion 21h tambien a dx ahi es donde ve lo que va a imprimir
   
   ;mov dx, offset SALTA  ; Obtiene direccion del mensaje en dx
   ;mov ah,09             ; Funcion: Visualizar cadena
   ;int 21h         ; Servicio: 09 int 21h alto nivel DOS
   
   
   mov dx, offset MEN1
   CALL escribe_cadena
   
   mov dx, offset SALTA
   CALL escribe_cadena
   
   lea dx, MEN2 ; LEA ES EQUIVALENTE A MOV DX,OFFSET 
   CALL escribe_cadena
   
   mov dx, offset SALTA
   CALL escribe_cadena
   
   lea dx, MEN3 ; LEA ES EQUIVALENTE A MOV DX,OFFSET 
   CALL escribe_cadena
   
   mov   ax,4c00h               ;Funccion :Quit with exit code (EXIT)) | LE AVISA AL SISTEMA OPERATIVO QUE EL PROCESO YA MURIO Y PUEDE OCUPAR LOS RECURSOS
   int   21h                    ;Servicio:4c int 21 DOS | va junto la de arriba
    
   
   
   RET
   MAIN ENDP               ;Fin proceso (FIN DEL MAIN)
    
    ; En esta ?rea despu?s del main van las subrutinas
    ;SUBRUTINA1
   escribe_cadena PROC
    PUSH AX
    MOV AH,09
    INT 21H
    POP AX
    RET
   escribe_cadena ENDP
    
    
    
    
    
    
CODIGO ENDS                 ;Fin segemento de codigo
END MAIN  