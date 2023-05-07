; EJEMPLO DIRECTIVA CORTA
.model small
.stack

.data
saludo db "Hola Mundo soy Estudiante de ingenieria de la UTM", "$"

.code
main proc ;Inicia proceso
mov ax,@data ;PROTOCOLO resguarda direcci?n del segmento de datos
mov ds,ax ;Protocolo ds = ax

mov ah,09 ; Function (print string)
lea dx,saludo ;DX = String terminated by "$"
int 21h ;Interruptions DOS Functions
;mensaje en pantalla
mov ax,4c00h ;Function (Quit with exit code (EXIT))
int 21h ;Interruption DOS Functions

main endp ;Termina proceso
end main