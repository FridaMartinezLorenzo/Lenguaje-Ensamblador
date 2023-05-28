Include MACRO.LIB
.model small

.stack 100h

.data
MEN1 DB 'HOLA BOLA$'
MEN2 DB 'JEJE$'
MEN3 DB "Ingrese un numero de un byte: $"

.code
MAIN proc far

;***********
    INICIO
    ESCRIBE_CADENA MEN1
    LEE
    ESCRIBE_CADENA MEN2
    SALTAR
    ESCRIBE_CADENA MEN3
    EMPAQUETA
    SALTAR 
    DESEMPAQUETA AL
    LEE
    RET
   
MAIN endp

END MAIN