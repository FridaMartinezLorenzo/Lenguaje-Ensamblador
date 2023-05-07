.MODEL tiny

.CODE
Inicio: ;Punto de entrada al programa
Mov AX,0 ;AX=0
Mov BX,1 ;BX=1 Estos son los dos primeros elementos 0+1=1
Mov CX,10 ;Repetir 10 veces
Repite:
Mov DX,AX ;DX=AX
Add DX,BX ;DX=AX+BX
Mov AX,BX ;Avanzar AX
Mov BX,DX ;Avanzar BX
Loop Repite ;siguiente n?mero
Mov AX,4C00h ;Terminar programa y salir al DOS
Int 21h ;

END Inicio
END