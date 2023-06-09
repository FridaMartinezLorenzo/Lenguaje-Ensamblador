INCLUDE MACRO.LIB
.model small
.stack 64
.data
ASC1 DB 4 DUP(0)
ASC2 DB 4 DUP(0)
ASCSUM DB 5 DUP(0)

RES DB "RESULTADO: $"
N DB "NUMERO: $"
BANDERA DB 1
MENU DB "MENU",13,10,"01.Suma",13,10,"02.Resta",13,10,"03.Salir",13,10,"OPC: $"
.code

PRINCI PROC FAR
   ;PROTOCOLO
   push ds
   sub ax,ax
   push ax
   MOV AX,@DATA
   MOV DS,AX
   
  AGAIN:
   CLEAR
   ESCRIBE_CADENA MENU
   EMPAQUETA
   CMP AL,01
   JE SUMA
   CMP AL,02
   JE RESTA
   CMP AL,03
   JE FIN
  JMP AGAIN
  
   SUMA:
    CALL SUMABCD
    LEE
    JMP AGAIN
 
   RESTA:
    CALL RESTABCD
    LEE
    JMP AGAIN
    
   FIN:
   EXIT_PROGRAMA

 mov ah,04ch
 int 21h
PRINCI ENDP

LEER_DATA PROC
  ;LEEMOS LOS DATOS
  ESCRIBE_CADENA N
  LEA SI,ASC1
  MOV CL,04
 OTRO1:
  LEER_ECO ;EL DATO QUEDA EN AL
  MOV [SI],AL
  INC SI
  DEC CX
  CMP CX,0
  JNE OTRO1
  
  SALTAR
  ESCRIBE_CADENA N
  LEA DI,ASC2
  MOV CL,04
 OTRO2:
  LEER_ECO ;EL DATO QUEDA EN AL
  MOV [DI],AL
  INC DI
  DEC CX
  CMP CX,0
  JNE OTRO2
  RET
  LEER_DATA ENDP

SUMABCD PROC
  CLEAR
  CALL LEER_DATA
  CLC ;limpia la bandera de acarreo.
  LEA SI,ASC1+3
  LEA DI, ASC2+3
  LEA BX, ASCSUM+4
  MOV CX,04

  SALTA1_S:
    MOV AH,00 ;garantizamos que AH este limpio.
    MOV AL,[SI]
    ADC AL,[DI]
    AAA ;esta manejando el carry.
    MOV [BX], AL
    DEC SI
    DEC DI
    DEC BX
    LOOP SALTA1_S

    MOV [BX],AH ;AH tiene el acarreo.
    LEA BX,ASCSUM+4
    MOV CX,04

    SALTA_S:
    OR BYTE PTR [BX], 30h
    DEC BX
    LOOP SALTA_S

    SALTAR
    SALTAR
    ESCRIBE_CADENA RES

    mov bx, offset ascsum
    mov cx, 05

    imprimeS:
        ESCRIBE_CAR[bx]
        inc bx
    loop imprimeS
    RET
SUMABCD ENDP

RESTABCD PROC
  CLEAR
  CALL LEER_DATA
  CLC ;limpia la bandera de acarreo.
  LEA SI,ASC1+3
  LEA DI, ASC2+3
  LEA BX, ASCSUM+4
  MOV CX,04

  SALTA1_R:
    MOV AH,00 ;garantizamos que AH este limpio.
    MOV AL,[SI]
    SBB AL,[DI]
    AAS ;esta manejando el carry.
    MOV [BX], AL
    DEC SI
    DEC DI
    DEC BX
    LOOP SALTA1_R

    MOV [BX],AH ;AH tiene el acarreo.
    LEA BX,ASCSUM+4
    MOV CX,04

    SALTA_R:
    OR BYTE PTR [BX], 30h
    DEC BX
    LOOP SALTA_R

    SALTAR
    SALTAR
    ESCRIBE_CADENA RES

    mov bx, offset ascsum
    mov cx, 05

    imprimeR:
        ESCRIBE_CAR[bx]
        inc bx
    loop imprimeR
    RET
RESTABCD ENDP

END PRINCI