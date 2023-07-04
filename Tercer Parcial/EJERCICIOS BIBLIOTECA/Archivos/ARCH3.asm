;Ejemplo 2: El siguiente c?digo muestra la creaci?n, escritura y cierre de un archivo. Se agregan,
;como comentario, invocaciones a funciones de C, como comparativa.
;Creaci?n y escritura de un archivo
.model small

.stack

.data
narchivo db "texto.txt",0h
contenido db "Hola, Mundo$"
fid dw ?

.code
main proc
mov ax,@data
mov ds,ax
mov es,ax
;Crear y abrir
;fid=fopen( "texto.txt", "w" );
mov ah,3Ch ;C?digo para crear archivo.
mov cx,0 ;Archivo normal.
mov dx,offset narchivo ;Direcci?n del nombre.
int 21h ;Crear y abrir, devuelve ident.
jc error ;Saltar en caso de error.
mov fid,ax ;guardar identificador en variable.


;Escribir en el archivo

;fwrite( &contenido, srtlen( contenido ), 1, fid );

mov ah,40h ;C?digo para escribir en archivo.
mov bx,fid ;Identificador.
mov cx,12 ;Tama?o de datos.
mov dx,offset contenido ;Direcci?n b?fer.
int 21h ;Escribir.
jc error ;Saltar en caso de error.
;Cerrar archivo
;fclose( fid );
mov ah,3Eh ;C?digo para cerrar archivo
mov bx,fid ;Identificador.
int 21h ;Cerrar archivo
jc error ;Saltar en caso de error
jmp salida
error: mov dx,ax ;Desplegar c?digo de error, procesar el valor
mov ah, 02
int 21h ;Y salir indicando que hubo error
salida:
mov ax,4c00h
int 21h ;Salir sin indicar error
endp
end main