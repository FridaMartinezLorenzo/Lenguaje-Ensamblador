.model small
.stack 100h

.data
nombre db "NUEVO.txt",00h   ;especificar directorio del archivo
maneja dw ?

.code
algo proc near
;PROTOCOLO
    MOV AX,@DATA
    MOV DS,AX
    MOV AH, 3CH
    MOV CX, 00
    LEA DX, nombre
    int 21h
    JC salir
    mov maneja, AX

salir: mov ax, 4c00h
       int 21h
algo endp
END algo