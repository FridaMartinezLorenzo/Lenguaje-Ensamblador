INCLUDE MACRO.LIB
.Model Small
.Stack 100h


.Data

MODE DB 0
;;;;;;;;;;;;;;;;;;;;;;;;;;;
new_timer_vec   dw  ?,?
old_timer_vec   dw  ?,?
a1              dw ?
a2              dw ?
b1              dw ?
b2              dw ?
score           dw ?
flagg           db 0
color           db 9 ;quisiese 9
seshs           db 0
next_color      db 13 ;quisiese 13
line            dw 0
timer_flag      db  0
vel_x           dw  1
vel_y           dw  1
boxer_a         dw  ?   ; these two vars deal with current upper and lower row bounds
boxer_b         dw  ?   ; of the single blocks

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                   strings that will be displayed                        ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

msg_next       db "Next$",0
msg_left       db "A - Izquierda$"
msg_right      db "D - Derecha$"
msg_fast       db "S - + Rapido$"
msg_rotate     db "W - Rotar$"
msg_lines      db "Lines$"
msg_score      db "Score$"
msg_game_over  db "Game Over!$"
msg_tetris     db "TETRIS$"
game_score     db "0000$"



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

screen_width       dw 320
column_limit       dw 0
row_limit          dw 0
block_width        dw 10
block_height       dw 5
block_boundary     dw 153
block_boshche      dw 0
box_medium         dw 100
current_row        dw 0
current_block      dw 0
next_block         dw 0


;;;;;;;;;;;;; blocks ;;;;;;;;;;;;;;;;;;;;;;

horizontal             dw 51,56,290,300
                       dw 51,56,300,310
                       dw 51,56,310,320
                       dw 0,0,0,0
                       

next_horizontal        dw 71,76,430,440
                       dw 71,76,440,450
                       dw 71,76,450,460
                       dw 0,0,0,0
                       
              
vertical               dw 51,56,285,295
                       dw 56,61,285,295 
                       dw 61,66,285,295
                       dw 0,0,0,0
                       
                       
T_shape                dw 51,56,290,300
                       dw 51,56,300,310
                       dw 51,56,310,320
                       dw 56,62,310,320
                       
       
L_shape                dw 51,56,290,300
                       dw 51,56,300,310
                       dw 51,56,310,320
                       dw 45,50,290,300
                       

                       
next_L_shape           dw 71,76,430,440
                       dw 71,76,440,450
                       dw 71,76,450,460
                       dw 65,70,430,440


                       
Ulta_L                 dw 51,56,290,300
                       dw 51,56,300,310
                       dw 51,56,310,320
                       dw 57,64,310,320
                       

Ulta_T                 dw 51,56,290,300
                       dw 51,56,300,310
                       dw 51,56,310,320
                       dw 45,50,310,320
                       
                       
right_L                dw 51,56,290,300
                       dw 51,56,300,310
                       dw 51,56,310,320
                       dw 45,50,310,320 
                       
                       
next_right_L           dw 71,76,430,440
                       dw 71,76,440,450
                       dw 71,76,450,460
                       dw 65,70,450,460
                       
                          
currentBlock           dw 0,0,0,0
                       dw 0,0,0,0
                       dw 0,0,0,0
                       dw 0,0,0,0

next_piece             dw 0,0,0,0
                       dw 0,0,0,0
                       dw 0,0,0,0
                       dw 0,0,0,0
                       
offsetArray            dw 20,20,140,140
                       dw 20,20,140,140
                       dw 20,20,140,140 
                       dw 20,20,140,140 
                       
temp_nxt_piece         dw 0,0,0,0
                       dw 0,0,0,0
                       dw 0,0,0,0
                       dw 0,0,0,0
                       
               
choose_random_piece    dw 0,0,0,0
                       dw 0,0,0,0
                       dw 0,0,0,0
                       dw 0,0,0,0
                       
                       
zero_matrix            dw 0,0,0,0
                       dw 0,0,0,0
                       dw 0,0,0,0
                       dw 0,0,0,0
                        
                      

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.CODE

MAIN PROC 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                              Initialization                        
   MOV AX,@DATA
   MOV DS,AX ;DATA INITIALIZATION 

    CALL GAME_GAME
   ret
   MAIN ENDP


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; all procedures ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; draw screen elements 

procedure_draw_screen proc near
    
    draw_screen_border:
        
        ;top left to top right
        draw_row 5,10,630,03h
        ;top left to bottom left
        draw_column 10,5,195,03h
        ;top right to bottom right
        draw_column 630,5,195,03h
        ;bottom left to bottom right
        draw_row 195,10,630,03h
        
    
    draw_screen_play_area:
        
        ;top left to top right
        draw_row 42,228,381,7
        ;top left to bottom left
        draw_column 228,42,165,7
        ;top right to bottom right
        draw_column 381,42,165,7
        ;bottom left to bottom right
        draw_row 165,228,381,7
        
        
    draw_screen_next_piece:
        
        ;top left to top right
        draw_row 50,400,487,13
        ;top left to bottom left
        draw_column 400,50,90,13
        ;top right to bottom right
        draw_column 487,50,90,13
        ;bottom left to bottom right
        draw_row 90,400,487,13
        
    
    draw_screen_strings:
        
        
    display_string msg_right,10,10,11,4
        display_string msg_left,12,10,13,9
        display_string msg_fast,14,10,12,13
        display_string msg_rotate,16,10,9,14
        display_string msg_tetris,3,35,6,12
        display_string msg_next,12,54,4,2
        display_string msg_score,18,53,5,9
        display_string game_score,16,53,4,8
        
        ret
    
procedure_draw_screen endp



setup_int Proc
;    save old vector and set up new vector
;    input: al = interrupt number
;    di = address of buffer for old vector
;    si = address of buffer containing new vector
;    save old interrupt vector

    MOV AH, 35h     ; get vector
    INT 21h
    MOV [DI], BX    ; save offset
    MOV [DI+2], ES  ; save segment
        
;   setup new vector

    MOV DX, [SI]    ; dx has offset
    PUSH DS         ; save ds
    MOV DS, [SI+2]  ; ds has the segment number
    MOV AH, 25h     ; set vector
    INT 21h
    POP DS
    RET
setup_int EndP


timer_tick Proc
    PUSH DS
    PUSH AX
    
    MOV AX, Seg timer_flag
    MOV DS, AX
    MOV timer_flag, 1
    
     
exit:    
    POP AX
    POP DS
    
    IRET
timer_tick EndP




move_block Proc
;   erase block at current position and display at new position
;   input: CX = col of block position
;   DX = rwo of block position
;   erase block
;   MOV AL, 0
;   mov bx,300
;   mov cx,310
;   push ax

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;keyboard bae
 
;   mov ah, 1 ;keyboar buffer check korbe
    mov ah, 1 ;keyboar buffer check korbe
    int 16h
;   int 16h
    jz foo
    mov ah, 0   ; key input nibe
    int 16h 
    cmp al,97 ; a checker
    je keya
    cmp al,100 ; d checker
    je fix2
    cmp al,115
    je dours
    foo: jmp boo
    
    keya:
       ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      
       xor cx,cx
       xor dx,dx
       mov cx,currentBlock[20]
       sub cx,45
       mov dx,currentBlock[16]
fix1:   
       jmp fix3
fix2:
       jmp keyd
dours: jmp dour
fix3:
      
       ; xor ax,ax
       ;  mov dx,158
       ;  mov cx,301
       mov ah,0dh
        
        
       int 10h
       cmp al,13
       je boo
       cmp al,14
       je boo
       cmp al,9
       je boo
       add dx,10
       int 10h
       cmp al,14
       je boo
       cmp al,13
       je boo
       cmp al,9
       je boo
      
       ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
       draw_full_block currentBlock,15 ,24
       modify_column_elementsA currentBlock,30,30
        
    boo:   jmp exittt
    
    dour:  
         jmp exitttt
    
    keyd: 
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
       xor cx,cx
       xor dx,dx
       mov cx,currentBlock[20]
       add cx,15
       mov dx,currentBlock[16]
       
       ; xor ax,ax
       ;  mov dx,158
       ;  mov cx,301
       mov ah,0dh
        
        
       int 10h
       cmp al,13
       je exittt
       cmp al,14
       je exittt
       cmp al,9
       je exittt
       
       add dx,10
       int 10h
       cmp al,13
       je exittt
       cmp al,14
       je exittt
       cmp al,9
       je exittt
       ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    draw_full_block currentBlock,15 , 30
    modify_column_elementsD currentBlock,30,30
        jmp exittt
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;muhahaha hoya gese  


    
exittt:    
    
      draw_full_block currentBlock,15, 24
      
     ;draw_full_block vertical,15
     ;draw_full_block L_shape,15
  
      jmp test_timer
      
     ;   draw_block boxer_a,boxer_b,320,330,15
     ;   draw_block boxer_a,boxer_b,332,342,15
     ;   draw_block boxer_a,boxer_b,344,354,15
    
     ;   get new position  
     ;   check boundary
     ;   cmp cx,160
     ;   jl exits
     ;   CALL 
     
     ;   wait for 1 timer tick to display block
     
 exitttt:
    
 draw_full_block currentBlock,15, 24
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
       xor cx,cx
       xor dx,dx
       mov cx,currentBlock[4]
       inc cx
       ;   add cx,20
       mov dx,currentBlock[16]
       
        xor ax,ax
       ;  mov dx,158
       ;  mov cx,301
          mov ah,0dh
        
       cmp dx,140
       jg test_timer 
       add dx,24
       
       int 10h
       cmp al,13
       je test_timer
       cmp al,14
       je test_timer
       cmp al,9
       je test_timer
       add cx,20
       int 10h
       cmp al,13
       je test_timer
       cmp al,14
       je test_timer
       cmp al,9
       je test_timer
    ;   add cx 20
      
       ; add dx,10
       ;int 10h
       ; cmp al,09h
       ;  je exittt
       ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
       modify_row_elements currentBlock,12, 4
    jmp test_timer
 
test_timer:
   
    xor ax,ax
    CMP timer_flag, 1
    JNE test_timer
    
    modify_row_elements currentBlock,6 ,16
    
    draw_full_block currentBlock,color,24
   ; modify_row_elements vertical
   ; modify_row_elements L_shape
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
       ;  push ax
       ;  push cx
       ;  push dx
       xor cx,cx
       xor dx,dx
       mov cx,currentBlock[4]
       inc cx
       ;    ; add cx,
       mov dx,currentBlock[16]
       add dx,10
       ; xor ax,ax
       ;  mov dx,158
       ;  mov cx,301
       mov ah,0dh
        
        
       int 10h
       cmp al,13
       je exits2
       cmp al,14
       je exits2
       cmp al,9
       je exits2
       
       add cx,20
      
       int 10h
       cmp al,13
       je exits2
       cmp al,14
       je exits2
       cmp al,9
       je exits2   
 
      ; jne exits
             
           
      ;   pop dx
      ;   pop cx
      ;   pop ax
          
      ;   jne exits2
           
      ;   exits2:
      ;   mov currentBlock[18],160
      ;   RET
      
      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      ;   halum:    
      
      ;draw_full_block currentBlock,09h
     
   ;  draw_full_block vertical,08h
   ;  draw_full_block L_shape,08h
    
    
    ;draw_block boxer_a,boxer_b,320,330,08h
    ;draw_block boxer_a,boxer_b,332,342,08h
    ;draw_block boxer_a,boxer_b,344,354,08h
    ;
    
    MOV timer_flag, 0
   ; MOV AL, 3
    
    exits:
    
        RET
        
    exits2:
    
    ; mov cx,170

    ; draw_full_block currentBlock,09h
    mov currentBlock[16],170
    
    RET
    
    ;dec cx
     
        
        
move_block EndP


check_line Proc
   xor ax,ax
   xor bx,bx
   xor cx,cx
   xor dx,dx
    
hambahamba:
    
     mov ah,0dh
    
     mov a1,164
     mov b1,56
     mov a2,230
     mov b2,240
     
     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    
     mov line,170
 ;    mov dx,line
 continua:
      mov cx,235  ;la ultima columna, pero despu?s del borde (inmediata sig)
      sub line,6  ;ultimo renglon
      mov dx,line ;renglon
      mov a1,dx   
      
evaluar_sig_elem:
    add cx,10  ; columnas 
    cmp cx,380 ; El final del area de juego (la ultima columna)
    jg adjust_score  ; Se completo la linea, ajustar score
    xor ax,ax  
    mov ah,0dh  ;obtener el color de un solo pixel   
    int 10h
    cmp al,13  ;comparar con el rosita pastel
    je evaluar_sig_elem
    cmp al,14  ;comparar con el amarillo
    je evaluar_sig_elem
    cmp al,9  ;comparar con el azuk
    je evaluar_sig_elem
    jmp hh3
    
adjust_score:
     add score,10
     
  hh1:
    mov a2,220
    sub a1,6
    
  hh2:
    cmp a1,55
    jl hh3
    
    add a2,10
    cmp a2,370 ;fin la columna hasta donde se colocan los bloques (la barra inicial)
    jg hh1
    
    mov bx,a1
    add bx,6
    mov b1,bx ;ultimo renglon del area de juego
    
    mov bx,a2
    add bx,10
    mov b2,bx ;columna inicial del area donde estan los bloques
    
    xor ax,ax
    xor bx,bx
    xor cx,cx
    xor dx,dx
    
    mov cx,a2
    inc cx
   ; add cx,15
    mov dx,a1
    sub dx,4
    mov ah,0dh
    int 10h
    
    draw_block a1,b1,a2,b2,al ;Se limpia y actualizan las partes que sobran de la linea superior en la ultima (al tiene el color)
    jmp hh2
    
hh3: 
    mov a2,220
    cmp line,60
    jl fin_check
    jmp continua
    fin_check:

RET
check_line Endp


score_dekhao proc
        
        push ax
        push bx
        push cx
        push dx
        
        
        mov cx,10d
        xor bx,bx
        mov bx,3
        mov ax,score
        
        bhag_kor:
            
            xor dx,dx
            div cx
            
            ;push bx
            ;inc cx
            
            or dl,30h
            mov game_score[bx],dl
            dec bx
            
            
            or ax,ax
            jne bhag_kor
            
         
       

         display_string game_score,16,53,4,8
         
         
         pop dx
         pop cx
         pop bx
         pop ax
        
       
        ret


score_dekhao Endp


gen_block proc

    CALL SEMILLA
    CALL ALEATORIO
    CALL ESCALANDO
    ;DL trae el numero aleatorio,esto nos permitir? generar una pieza aleatoria
    mov dh,0
    MOV next_block,dx
    
    cmp [current_block],1
    je horizontal_piece
    
    cmp [current_block],2
    je L_shape_piece
     
    cmp [current_block],3
    je right_L_piece
    
    
    horizontal_piece:
    update_block horizontal, choose_random_piece
            ;mov [next_block],2
            ret
   
            
    L_shape_piece:
            update_block L_shape, choose_random_piece
            ;mov [next_block],3
            ret
               
    right_L_piece:
             update_block right_L, choose_random_piece
             ;mov [next_block],1
             ret
      
    
    ret 
    
gen_block endp


gen_next_piece proc

    cmp [next_block],1
    je horizontal_pz
    
    cmp [next_block],2
    je L_shape_pz
    
    cmp [next_block],3
    je right_L_pz
    
   
    horizontal_pz:
            update_block next_horizontal, next_piece
            ret
            
    L_shape_pz:
           update_block next_L_shape, next_piece
           ret
            
    right_L_pz:
           update_block next_right_L, next_piece
           ret

         
    ret 


gen_next_piece endp


show_next_piece proc ;pattern_name - konta next piece box e dekhano hobe 
   
       push bx
       push cx
       push dx
       
       draw_block 61,89,401,470,0Fh
       
       draw_full_block next_piece,[next_color], 24
      
      pop dx
      pop cx
      pop bx
      
      ret
      
show_next_piece endp




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;           GENERACION ALEATORIA DE LA PIEZA
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SEMILLA PROC
    PUSH AX
    MOV AH,2CH ; SERVICIO 2CH OBTIENE LA HORA ACTUAL EN EL SISTEMA
    INT 21H ; RETORNA CH=HORAS, EN FORMATO 00-23, MEDIANOCHE=0

    ; CL MINUTOS 00-59
    ; DH SEGUNDOS 00-59
    ; DL CENTESIMAS DE SEGUNDO 00-99

    POP AX
    RET
SEMILLA ENDP

ALEATORIO PROC
    ; XN+1=(2053*XN + 13849)MOD (2**16-1)
    ; RETORNA EL NUMERO PSEUDOALEATORIO EN AX
    MOV AX,DX ;CARGANDO A AX EL NUMERO SEMILLA tomado de la int 21H serv  2CH
    MOV DX,0 ;CARGANDO CERO EN LA POSICION MAS SIGNIFICATIVA DEL MULTIPLICANDO
    MOV BX,2053 ; MULTIPLICADOR
    MUL BX
    MOV BX,13849 ;CARGA EN BX LA CONSTANTE ADITIVA
    CLC
    ADD AX,BX ; SUMA PARTES MENOS SIGNIFICATIVAS DEL RESULTADO
    ADC DX,0 ; SUMA EL ACARREO SI ES NECESARIO
    MOV BX,0FFFFH ; CARGAR LA CONSTANTE 2**16-1
    DIV BX
    MOV AX,DX ;MUEVE EL RESIDUO AX
    RET
ALEATORIO ENDP

ESCALANDO PROC
    ; ESCALANDO EL NUMERO PSEUDOALEATORIO OBTENIDO
    MOV DX,0
    MOV BX,05H ;NUMEROS ALEATORIOS ENTRE 0 Y 9
    DIV BX
    ADD DL,DH
    CMP DL,0
    JE SUMA1
    JMP FIN_ES
    SUMA1:
        INC DL
    FIN_ES: ;DATO QUEDA EN DL
    RET
ESCALANDO ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MODOVIDEO PROC
    MOV AL,MODE
    MOV AH,0
    INT 10H
RET
MODOVIDEO ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;PROTOCOLO DEL JUEGO PARA SOLO MANDARLA A LLAMAR

GAME_GAME PROC
   ; set CGA 640x200 high res mode
   MOV MODE,0EH
   CALL MODOVIDEO
   
   SET_BGD 15
   
   call procedure_draw_screen
    
   draw_block 158,164,236,360,0Fh ;es un bloque en la base del juego que nos ayudar? despu?s
  
     
    MOV new_timer_vec, offset timer_tick
    MOV new_timer_vec+2, CS
    MOV AL, 1CH; interrupt type
    LEA DI, old_timer_vec
    LEA SI, new_timer_vec
    CALL setup_int
  
    mov score,0
     
    CALL SEMILLA
    CALL ALEATORIO
    CALL ESCALANDO
    ;DL trae el numero aleatorio,esto nos permitir? generar una pieza aleatoria
    mov dh,0
    MOV current_block,dx
    
notun_notun_block_banao:
        
        cmp [current_block],3
        jle continue_kor
        
        mov [current_block],1
    
        continue_kor:
        
            call gen_block
      
            update_block choose_random_piece, currentBlock
            
            
            ;SEGUIR PROBANDO LA FORMA
            ;update_block l_shape, currentBlock
            ;set_bgd 07h
            ;limpiar_pantalla 05h
            ;mov bx,0
            ;mov dx, [currentBlock+bx+]
            ;desempaqueta dh
            ;desempaqueta dl
            
            call gen_next_piece
            call show_next_piece
            
            time_delay currentBlock
             
            call check_line
            
            mov ax,next_block
            mov current_block,ax
            
            call score_dekhao
            call gameover
            cmp seshs,23
            je FIN_DEL_JUEGO
            
            cmp color,13
            je Corrige_color
            
            cmp next_color,9
            je Corrige_next_color
            
            add next_color,1
            
            cmp next_color,14
            jg Ooops_next
           
            add color,4
           
            cmp color,14
            jg Ooops
            

            jmp notun_notun_block_banao
Ooops:  
        mov color,9
        jmp notun_notun_block_banao
        
Ooops_next:  
        mov next_color,9
        jmp notun_notun_block_banao
        
Corrige_color:
        mov color,14
        mov next_color,9
        jmp notun_notun_block_banao

Corrige_next_color:
        mov next_color,13
        mov color,9
        jmp notun_notun_block_banao        
        
FIN_DEL_JUEGO:
    
 CALL GAME_OVER_SCREEN
 LEE ; SE ESPERARA CUALQUIER TECLA ANTES DE VOLVER AL MENU
 LEE
RET
GAME_GAME ENDP


GAME_OVER_SCREEN PROC
  MOV MODE,13H
  CALL MODOVIDEO
      

  SET_BGD 10


   display_string msg_game_over ,10,15,10,2 
    display_string msg_game_over ,10,15,10,2
     display_string msg_game_over ,10,15,10,2
      display_string msg_game_over ,10,15,10,2
 RET
GAME_OVER_SCREEN ENDP
End main