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
current_blockR     dw 0
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
                       
              
vertical               dw 45,49,280,290
                       dw 49,52,280,290 
                       dw 52,56,280,290
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


L_shape_izq1           dw 45,49,290,300
                       dw 50,54,290,300
                       dw 55,59,290,300
                       dw 55,59,279,290 
    
                       
next_L_shape_izq1      dw 65,69,430,440
                       dw 70,74,430,440
                       dw 75,79,430,440
                       dw 75,79,419,230 
              
                       
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
                       
currentBlockR          dw 0,0,0,0
                       dw 0,0,0,0
                       dw 0,0,0,0
                       dw 0,0,0,0

currentBlockAux        dw 0,0,0,0
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
    mov ah, 1 ;keyboar buffer check stroke
    int 16h
    
    jz exittt ;keystroke not aviable ZF=1
    mov ah, 0   ; GET KEYSTOKE
    int 16h 
    cmp al,97  ; a checker
    je keya
    cmp al,100 ; d checker
    je keyd
    cmp al,115 ;s checker
    je exitttt ;salir final
    cmp al,119 ;w checker
    je keyw
    jmp exitttt
    keyw:
        call rotate_proc 
    keya:
       ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        call moving_left
        jmp exittt
        
    keyd:
        call moving_right
        jmp exittt    
    
        exittt:;prefinal
            call pre_final_move_block
            cmp bl,1
            je check
            jmp exits2
         exitttt:
            call pre_final_move_block2
            jmp test_timer_loop1
            continua_exitttt:
            cmp bl,1
            je check
            jmp exits2
            
        check:
            MOV timer_flag, 0     
       
       exits:
        ret    
    
       test_timer_loop1:
        CMP timer_flag,1
        jne test_timer_loop1
        call test_timer
        jmp continua_exitttt
        
    exits2:
    mov currentBlock[16],170 ;base del juego
    mov currentBlockR[16],170
    RET
    
move_block EndP


moving_left proc
       xor cx,cx
       xor dx,dx
       mov cx,currentBlock[20]
       sub cx,45
       mov dx,currentBlock[16]
       

       mov ah,0dh ;getting pixel color
       int 10h
       
       cmp al,13
       je end_lft
       cmp al,14
       je end_lft
       cmp al,9
       je end_lft
       
       add dx,10 ;getting pixel again
       int 10h
       cmp al,14
       je end_lft
       cmp al,13
       je end_lft
       cmp al,9
       je end_lft
       jmp other_opc
       end_lft: ;auxiliar
            jmp end_lft1
       
       other_opc:    
       ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
       draw_full_block currentBlock,15,24 ;se borra el anterior para redibujarse

       modify_column_elementsA currentBlock,30,30  ;se corrigen coordenadas
       modify_column_elementsA currentBlockR,30,30  ;se corrigen coordenadas
       
      

       end_lft1:
ret
moving_left endp


moving_right proc
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
       xor cx,cx
       xor dx,dx
       mov cx,currentBlock[20]
       add cx,15
       mov dx,currentBlock[16]
       
    
       mov ah,0dh ;getting pixel
        
        
       int 10h
       cmp al,13
       je end_move_right
       cmp al,14
       je end_move_right
       cmp al,9
       je end_move_right
       
       add dx,10
       int 10h
       cmp al,13
       je end_move_right
       cmp al,14
       je end_move_right
       cmp al,9
       je end_move_right
       jmp fix_r
       end_move_right:; an aux
            jmp end_right
    
        fix_r:
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    draw_full_block currentBlock,15 , 30
    modify_column_elementsD currentBlock,30,30
    modify_column_elementsD currentBlockR,30,30
       
    end_right:
ret
moving_right endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pre_final_move_block proc  
      draw_full_block currentBlock,15, 24 ;borrar
      jmp test_timer_loop
      
      test_timer_loop:
        CMP timer_flag,1
        jne test_timer_loop
        call test_timer
        
      ret      
pre_final_move_block endp


pre_final_move_block2 proc  
         
 draw_full_block currentBlock,15, 24
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
       xor cx,cx
       xor dx,dx
       mov cx,currentBlock[4]
       inc cx
      
       mov dx,currentBlock[16]
       
        xor ax,ax
     
        mov ah,0dh ;getting pixel color
        
       cmp dx,140
       jg test_timer_jmp
       add dx,24
       
       int 10h
       cmp al,13
       je test_timer_jmp
       cmp al,14
       je test_timer_jmp
       cmp al,09
       je test_timer_jmp
       add cx,20
       int 10h
       cmp al,13
       je test_timer_jmp
       cmp al,14
       je test_timer_jmp
       cmp al,9
       je test_timer_jmp
       jmp fix_tt
       
       test_timer_jmp : ;aux
                jmp test_timer_end 
       
       fix_tt:
       cmp current_block,4
       je especial1
       modify_row_elements currentBlock,12, 4
       cmp current_blockR,4
       je especial2
       regresaesp:
       modify_row_elements currentBlockR,12, 4    
       jmp test_timer_end
       
       especial1:
          modify_row_elements currentBlock,12, 4 ;3 jalo
          jmp regresaesp
          
       especial2:
          modify_row_elements currentBlockR,12, 4 ;3 jalo
      test_timer_end:
      ret      
pre_final_move_block2 endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
test_timer proc
    xor ax,ax
    CMP timer_flag, 1
    Je CONTINUE_TEST
    ret
    
    CONTINUE_TEST:
    mov bx,0
    cmp current_block,4
    je especial3
    modify_row_elements currentBlock,6 ,4
    
    cmp current_blockR,4
    je especial4
    regresa_tt:
    modify_row_elements currentBlockR,6 ,4
    jmp continue_test2
    
    especial3:
         modify_row_elements currentBlock,6 ,4
         jmp regresa_tt
    
    especial4:
         modify_row_elements currentBlockR,6 ,4
    continue_test2:
    draw_full_block currentBlock,color,24
   
       xor cx,cx
       xor dx,dx
       mov cx,currentBlock[4]
       inc cx
       ;    ; add cx,
       mov dx,currentBlock[16]
       add dx,10
       
       mov ah,0dh ;getting pixel color
        
        
       int 10h
       cmp al,13
       je end_test_timer
       cmp al,14
       je end_test_timer
       cmp al,9
       je end_test_timer
       
       add cx,20
      
       int 10h
       cmp al,13
       je end_test_timer
       cmp al,14
       je end_test_timer
       cmp al,9
       je end_test_timer   
 

       mov bl,1

end_test_timer:
ret
test_timer endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
erase_last_update proc ;adem?s de borrar respaldar? el currentBlock para guardarse como el asociado de rotacon despu?s
     draw_full_block currentBlock,15, 24
     ;respaldamos y actualizamos
     update_block currentBlock,currentBlockAux
     update_block currentBlockR,currentBlock
     update_block currentBlockAux,currentBlockR
ret
erase_last_update endp

erase_last proc 
     draw_full_block currentBlock,15, 24
ret
erase_last endp

rotate_proc proc
   cmp [current_block],1
        je pz1_mov11 ;pieza 1 movimiento 1
        
        cmp [current_block],2
        je pz2_mov11 ;pieza 2 movimiento 1
        
        cmp [current_block],3
        je pz3_mov11
        
        call aux_rotate ;asociar  
        ret
        pz1_mov11:
            call erase_last_update
            mov current_block,4
            mov current_blockR,1
            ret
            
        pz2_mov11:
            call erase_last_update
            mov current_block,5
            mov current_blockR,2
            ret    
         
        pz3_mov11:
            call erase_last_update
            mov current_block,6
            mov current_blockR,3
            ret  
            
            
    ret       
rotate_proc endp

aux_rotate proc
         cmp [current_block],4
         je pz1_mov00 ;pieza 1 movimiento 0 (SE REGRESA AL ORIGINAL)
        
        cmp [current_block],5
        je pz2_mov00 ;pieza 2 movimiento 0 (SE REGRESA AL ORIGINAL)
        
        ;pieza 3 movimiento 0 (SE REGRESA AL ORIGINAL) current_block =6
        call erase_last_update
        mov current_block, 3
        mov current_blockR,6
        ret
        
        pz1_mov00:
            call erase_last_update
            mov current_block ,1
            mov current_blockR,4
            ret
            
        pz2_mov00:
            call erase_last_update
            mov current_block, 2
            mov current_blockR,5
            ret    
 ret      
aux_rotate endp




associate_rotate_block proc
        cmp [current_block],1
        je pz1_mov1 ;pieza 1 movimiento 1
        
        cmp [current_block],2
        je pz2_mov1 ;pieza 2 movimiento 1
        
        cmp [current_block],3
        je pz3_mov1
        
       
        pz1_mov1:
            call erase_last
            update_block vertical,currentBlockR
            mov current_blockR,4
            ret
            
        pz2_mov1:
            call erase_last
            update_block right_L,currentBlockR
            mov current_blockR,5
            ret    
         
        pz3_mov1:
            call erase_last
            update_block L_shape,currentBlockR
            mov current_blockR,6
            ret  
            
            
    ret       
associate_rotate_block endp



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

;keyboard strike


gameover proc
    xor ax,ax
    xor cx,cx
    xor dx,dx
    mov dx,59
    mov cx,297
    mov ah,0dh
    int 10h
    cmp al,09h
    je sesh1
    cmp al,04h
    je sesh1
    cmp al,0eh
    je sesh1
    
   
    sesh: RET
   
    sesh1:
   
    
   mov ah,0bh
   mov bh,1
   mov bl,13
   int 10h
   mov seshs,23
   RET
     
   
gameover endp


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
    MOV BX,03H ;NUMEROS ALEATORIOS ENTRE 0 Y 4
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
            CALL associate_rotate_block
           
            
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