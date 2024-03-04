.model small
.stack 100h
.data
gameNameStr db "  AIR XONIC GAME ",'$'
gameNameOwner db "  Powered by SRZ ",'$'
n db  "  Whats your name? :  ",'$'
endl DB 0Dh,0Ah
levels_one db  "  level 1   ",'$'
levels_two db  "  level 2    ",'$'
timer dw 10
temp_start_time dw 10
start_time dw 60
time_len dw 0
selected_level dw 1
scores_var db  "  High Scores      ",'$'
level1_score db  "--    Level 01    --",'$'
level1_score_name db  "  Name:  ",'$'
level1_score_number db  "  Highest score:    ",'$'
headinglevel db  "Enter 1 for level 1, 2 for level 2",'$'
time_msg db "Time ",'$'
level2_score db  "--    Level 02    --",'$'
level2_score_name db  "  Name:  ",'$'
level2_score_number db  "  Total score:    ",'$'
len dw 0
time_up_msg db "Time Up",'$'
temp_score dw 0
linedraw db  "  **************************    ",'$'
timer_top dw 0
timer_inner dw 0FFh
col_num dw 170
counter dw 0
row_num dw 170
blue_movement_type db 3
border_col dw 6
border_row dw 6
row dw 0
inp db 61h
scores db "Score ",'$'
lives db "Lives ",'$'
levels db "Level ",'$'
gameover db "GAME   OVER",'$'
key_enter db "Enter Any Key For Main Menu",'$'
blue_enemy_row dw 150
blue_enemy_col dw 20
black_space_ship_row dw 10
black_space_ship_col dw 10
black_blue_enemy_row dw ?
black_blue_enemy_col dw ?
score dw 0
live dw '3'
level dw 1
collision_with_blue db 0
TriangleColor db ?
; File Var
FNAME DB "abc.txt", 0
handle DW ?
buffer DB 100 DUP('$'), "$"
namex dw ?
scorex dw ?
menu_x dw 70
menu_y dw 59
blue_iterate dw 0

menu_x1 dw 10
menu_y1 dw 12

lineLength dw 6

MenuSelect db 1
new_game db "1.New game  ",'$'
select_level db "2.Select the level  ",'$'
high_score db "3.High score  ",'$'
end_game db "5.Exit ",'$'
instruction db  "4.Instructions  ",'$' 

msg db "  Players can also move their pieces to other spots on the board to create new rows or block their opponent's moves. ",'$' 

userName db 20 dup('$')

initial_sp dw 0


printStr macro p1
    pusha
        mov dx,offset p1
        mov ah,09h
        int 21h
    popa

endm

takeinputstr macro p2
    pusha
		mov cx,20
		mov dx,offset p2
		mov ah,3fh
		int 21h
    popa
endm




clearStack macro
	mov sp,initial_sp
endm

ClearScreen macro
	mov al,13h
	mov ah,0
	int 10h
endm


.code
main proc

mov ax,@data
mov ds,ax
mov ax,0


mov initial_sp,sp
mov al, 13h ;activate video mode
int 10h






Title_Screen::
ClearScreen
call TitleScreen



loop_menu:

call menu

cmp byte ptr menuSelect, byte ptr 1
jne bro2
ClearScreen
call gameplay
bro2:

; menuselect 1

cmp byte ptr menuSelect, byte ptr 2
jne bro
ClearScreen
call levelofgame
bro:


cmp byte ptr menuSelect, byte ptr 3
jne notbro

call score_portion
notbro:

cmp byte ptr menuSelect, byte ptr 4
jne skipcode
call Instructions
skipcode:
cmp byte ptr menuSelect, byte ptr 5
jne loop_menu

je exit




exit::
mov ah,4ch
int 21h
main endp




Menu proc
       


      
        mov al,0
        mov ah,02h
        mov dl,10
        mov dh,2
        int 10h
        printStr gameNameStr
       
        mov ah,02h
        mov dl,12
        add dh,5
        int 10h
        printStr new_game
        mov ah,02h
        add dh,3
        int 10h
        printStr select_level
        mov ah,02h
        add dh,3
        int 10h
        printStr high_score
        mov ah,02h
        add dh,3
        int 10h
        printStr instruction
        mov ah,02h
        add dh,3
        int 10h
        printStr end_game
        

        l1:
            mov TriangleColor,0Bh
            call DrawTriangle
            mov bl,dh
            mov ah,1
            int 16h
        jnz l1
        mov ah,0
        int 16h
        .if(ah==48h)
            .if(menu_y > 59)
                mov TriangleColor, 00h
                call DrawTriangle
                sub menu_y,24 
                sub menuSelect,1
            .endif
        .elseif(ah==50h)
            .if(menu_y<155)
                mov TriangleColor, 00h
                call DrawTriangle
                add menu_y,24
                add menuSelect,1
            .endif
        .endif
        .if(al!=13)
            jmp l1
        .endif

        ClearScreen
    ret

Menu endp


TitleScreen proc  
       
        mov al,0
        mov ah,02h
        mov dl,10
        mov dh,8
        int 10h
        printStr gameNameStr

        
        mov al,0
        mov ah,02h
        mov dl,9
        mov dh,12
        int 10h
        printstr gameNameOwner
        
       

         mov al,0
        mov ah,02h
        mov dl,9
        mov dh,12
        int 10


         mov dl,10
         mov ah,02h
        int 21h
        mov dl,10
        mov ah,02h
         int 21h
mov dl,10
         mov ah,02h
        int 21h
mov dl,10
         mov ah,02h
        int 21h
mov dl,10
         mov ah,02h
        int 21h
        printstr n

        takeinputstr username
        l1:
            mov bl,dh
            mov ah,1
            int 16h
        jnz l1
        
        ClearScreen 
    ret

        
    


TitleScreen endp



DrawTriangle proc
    mov cx,menu_x  
    mov dx,menu_y
    mov bx,0
    push Linelength
    
    .while( bx !=  4)
        sub LineLength,1
        inc bx
        push bx
        mov bx,0
        mov dx,menu_y
        .while(bx < Linelength)
            inc bx
            mov ah,0ch
            mov al,trianglecolor
            int 10h
            inc dx
        .endw
        inc cx
        pop bx
    .endw

    pop Linelength

    push Linelength
    mov cx,menu_x
    mov dx,menu_y
    mov bx,0
    .while( bx !=  6)
        sub LineLength,1
        inc bx
        push bx
        mov bx,0
        mov dx,menu_y
        .while(bx < Linelength)
            inc bx
            mov ah,0ch
            mov al,trianglecolor
            int 10h
            dec dx
        .endw
        inc cx
        pop bx
    .endw

    pop linelength
    ret
DrawTriangle endp




Instructions proc
	Zf=0
 		mov al,0
        mov ah,02h
        mov dl,1
        mov dh,8
        int 10h
        printStr msg

        l1:
            mov bl,dh
            mov ah,1
            int 16h
        jnz l1 

        mov ah,0
        int 16h
        ClearScreen 
	ret
Instructions endp



levelofgame proc
choose_again:
 mov al,0
        mov ah,02h
        mov dl,1
        mov dh,2
        int 10h
printStr headinglevel




        Zf=0
        mov al,0
        mov ah,02h
        mov dl,1
        mov dh,8
        int 10h
        
        mov al,0     
        mov ah,02h   
        mov dl,9    
        mov dh,12
        int 10h 



       
        printStr levels_one
         
        

     
        add dh,5
        mov al,0
        mov ah,02h
        int 10h
        printStr levels_two
     


		
    

        l1:
            mov bl,dh
            mov ah,1
            int 16h
        jnz l1
		

		mov ah, 01
		int 21h
		
		cmp al,'1'
		je level_one_selected
		cmp al,'2'
		je level_two_selected
		ClearScreen
		jmp choose_again
		
		level_one_selected:
		mov level,1
		jmp return
		level_two_selected:
		mov level,2
		
		 

 return:
 ClearScreen
    ret
      
levelofgame endp



score_portion proc




mov al,0
        mov ah,02h
        mov dl,10
        mov dh,2
        int 10h
printStr scores_var

 Zf=0
        mov al,0
        mov ah,02h
        mov dl,1
        mov dh,8
        int 10h

     
        add dh,2
        mov al,0
        mov ah,02h
        int 10h

        
        ;open a file
        Mov ah, 3dh ;for opening an existing file
        Mov al, 02h ;in read only mode
        Mov dx, offset FNAME
        int 21h
        mov handle, ax

        Mov ah, 3fh ;uses for reading a file
        Mov dx, offset buffer
        Mov cx, 100
        Mov bx, handle
        int 21h

        mov ah, 09h
        mov [buffer+10], "$"
        mov bx, offset [buffer]
        mov namex, bx
        mov [buffer+15], "$"
        mov bx, offset [buffer+12]
        mov scorex, bx


        ;Closing File
        mov ah, 3eh
        mov bx, handle
        int 21h

        ; name here
        printStr level1_score_name
        mov dx, namex
        mov ah, 09h
        int 21h
     
        add dh,2
        mov al,0
        mov ah,02h
        int 10h
        
        ;score here
        add dh,2 
        mov dl,1
        mov al,0
        mov ah,02h
        int 10h
        printStr level1_score_number
        mov dx, scorex
        mov ah, 09h
        int 21h



     
   add dh,2
        mov al,0
        mov ah,02h
        int 10h
        ;printStr linedraw
     
   add dh,2
        mov al,0
        mov ah,02h
        int 10h
       ;printStr level2_score 



add dh,2
        mov al,0
        mov ah,02h
        int 10h
       ;printStr level2_score_name


add dh,2
        mov al,0
        mov ah,02h
        int 10h
       ;printStr level2_score_number












        l1:
            mov bl,dh
            mov ah,1
            int 16h
        jnz l1

        mov ah,0
        int 16h




        ClearScreen 
	ret
score_portion endp

gameplay proc
; Set in Video Mode 
mov ah,00h
mov al,13
int 10h
mov start_time, 60
mov ah,0ch
mov cx, blue_enemy_col
mov dx, blue_enemy_row
mov al,3
int 10h



;Timer Position
mov ah,2
mov bh,0
mov dh,0
mov dl,1
int 10h


lea dx, time_msg
mov ah, 9
int 21h

	mov ax, start_time
	mov bx, 10
	mov temp_start_time, ax
	multi_digit:
		mov ax,temp_start_time
		xor dx,dx
		div bx
		push dx
		mov temp_start_time, ax
		inc time_len
	cmp temp_start_time, 0
	jne multi_digit
	
		mov cx, time_len
		print_:
		pop dx
		add dx, 48
		mov ah, 02
		int 21h
		loop print_
		mov time_len, 0
		dec start_time

moves:

cmp start_time,0
je end_
call intersection_with_blue
cmp collision_with_blue, 1
je check_lives
jmp move_on

check_lives:
cmp live, 0
je end_

move_on:
mov cx,row_num
mov black_space_ship_row,cx
mov cx,col_num
mov black_space_ship_col,cx

; Pixel Creation
mov ah, 0ch
mov al, 15
mov dx, row_num
mov cx, col_num
int 10h


cmp blue_iterate,0
je call_blue_enemy
dec blue_iterate
jmp jmps
call_blue_enemy:
mov blue_iterate,50
call move_blue_enemy
jmps:
mov border_col,12
; ; Blue Border (Horizontal Lines)
start:
mov ah,0ch
mov cx,border_col
mov dx,12
mov al,1
int 10h 

mov ah,0ch
mov cx,border_col
mov dx,180
mov al,1
int 10h
inc border_col
cmp border_col,314
jne start

mov ax, 12
mov border_col, ax

; Blue Border (Vertical Lines)
start_2:
mov ah,0ch
mov cx,12
mov dx,border_col
mov al,1
int 10h 

mov ah,0ch
mov cx,313
mov dx,border_col
mov al,1
int 10h
inc border_col
cmp border_col,181
jne start_2



;Timer Position
mov ah,2
mov bh,0
mov dh,0
mov dl,1
int 10h


lea dx, time_msg
mov ah, 9
int 21h

cmp timer_top, 04Fh
jne reset_timer
	mov ax, start_time
	mov bx, 10
	mov temp_start_time, ax
	multi_digit_9:
		mov ax,temp_start_time
		xor dx,dx
		div bx
		push dx
		mov temp_start_time, ax
		inc time_len
	cmp temp_start_time, 0
	jne multi_digit_9
	
	mov cx, time_len
	print__:
	pop dx
	add dx, 48
	mov ah, 02
	int 21h
	loop print__
	mov time_len, 0
	dec start_time
	mov timer_top, 0
reset_timer:
inc timer_top
scores_msg_output:

;Scores Position
mov ah,2
mov bh,0
mov dh,23
mov dl,2
int 10h

lea dx, scores

mov ah, 9
int 21h

mov ax, score
mov temp_score,ax
mov bx, 10

multi_digit_3:
	mov ax,temp_score
	xor dx,dx
	div bx
	push dx
	mov temp_score, ax
	inc len
cmp temp_score, 0
jne multi_digit_3
	
mov cx, len
print_3:
pop dx
add dx, 48
mov ah, 02
int 21h
loop print_3
mov len , 0
;Lives Position
mov ah,2
mov bh,0
mov dh,23
mov dl,17
int 10h

lea dx, lives
mov ah, 9
int 21h

mov dx, live
mov ah,02
int 21h


;Level Position
mov ah,2
mov bh,0
mov dh,23
mov dl,32
int 10h
lea dx, levels
mov ah, 9
int 21h

mov dx, level
add dx, 48
mov ah,02
int 21h


; Cursor Position
mov ah,2
mov bh,0
mov dh,110
mov dl,150
int 10h


mov ah, 01
int 16h
jnz get_input

cmp inp, 1h
je end_
cmp inp, 48h
je L1
cmp inp, 50h
je L2
cmp inp,4Bh
je L3
cmp inp, 4Dh
je L4
jmp make_pixel
get_input:
inc score
; mov ah,00h
; mov al,13
; int 10h

mov ah, 00
int 16h
mov inp,ah

jmp moves
mov score, '0'
; Move Up ('w')
cmp ah, 1h
je end_
cmp ah, 48h
je L1
cmp ah, 50h
je L2
cmp ah,4Bh
je L3
cmp ah, 4Dh
je L4
jmp moves
; Move Up ('w')
L1:
sub row_num, 1
cmp row_num, 13
jbe C1
jmp make_pixel
C1:
add row_num, 1
jmp make_pixel
; Move Down ('s')
L2:
add row_num, 1
cmp row_num, 178
ja C2
jmp make_pixel
C2:
sub row_num, 1
jmp make_pixel
; Move Left ('a')
L3:
sub col_num, 1
cmp col_num, 14
jb C3
jmp make_pixel
C3:
add col_num, 1
jmp make_pixel
; Move Right ('d')
L4:
add col_num, 1
cmp col_num, 311
ja C4
jmp make_pixel
C4:
sub col_num, 1
jmp make_pixel

make_pixel:
; Pixel Creation
mov ah, 0ch
mov al, 5
mov dx, row_num
mov cx, col_num
int 10h

; Black Space Ship
mov ah, 0ch
mov al, 7
mov dx, black_space_ship_row
mov cx, black_space_ship_col
int 10h


jmp moves

end_ :
mov MenuSelect,1
mov inp, 'a'

mov ah, 00
mov al, 00
int 10h
mov collision_with_blue, 0
mov row_num, 160
mov col_num, 20

mov blue_enemy_col, 50
mov blue_enemy_row, 133
;Game Over Position

mov ah,6
mov al, 0
mov bh,10001100b
mov ch, 3
mov cl, 15
mov dh, 6
mov dl, 27
int 10h

mov ah,2
mov bh,0
mov dh,5
mov dl,15
int 10h

cmp collision_with_blue, 1
je display_timeup

lea dx, gameover
mov ah, 9
int 21h
mov start_time,60
jmp score_msg


display_timeup:
lea dx, time_up_msg
mov ah, 9
int 21h

score_msg:
;Scores Position
mov ah,2
mov bh,0
mov dh,10
mov dl,17
int 10h

lea dx,scores
mov ah, 09
int 21h


mov ax, score
	mov bx, 10
	mov temp_score,ax
	multi_digit_2:
		mov ax,temp_score
		xor dx,dx
		div bx
		push dx
		mov temp_score, ax
		inc len
	cmp temp_score, 0
	jne multi_digit_2
		
	mov cx, len
	print_2:
	pop dx
	add dx, 48
	mov ah, 02
	int 21h
	loop print_2
	mov len, 0

; write 
; userName
; scores
;lives (but additionally)

MOV AH, 3CH ; open file function

LEA DX, FNAME ; DX has filename address
mov Cl, 1 ; read-only attribute
INT 21H ; open file
MOV handle, AX ; save handle or error code

MOV BX, ax
LEA DX, userName
MOV CX, LENGTHOF userName
MOV AH, 40h
INT 21H

; MOV BX, ax
LEA DX, endl
MOV CX, 2
MOV AH, 40h
INT 21H

mov dx , score
MOV AH, 40h
INT 21H




;Closing File
mov ah, 3eh
mov bx, handle
int 21h


;Lives Position
mov ah,2
mov bh,0
mov dh,13
mov dl,17
int 10h

lea dx, lives
mov ah, 9
int 21h

mov dx, live
mov ah,02
int 21h


; Enter Key
mov ah,2
mov bh,0
mov dh,17
mov dl,6
int 10h

lea dx, key_enter
mov ah, 9
int 21h

mov ah,00h
int 16h

mov score, 0
ClearScreen
	
ret
gameplay endp

move_blue_enemy proc

mov cx, blue_enemy_col
mov black_blue_enemy_col, cx
mov cx, blue_enemy_row
mov black_blue_enemy_row, cx

cmp blue_movement_type, 0
je top_right
cmp blue_movement_type,1
je bottom_left
cmp blue_movement_type,2
je bottom_right
cmp blue_movement_type,3
je top_left

top_right:
	add blue_enemy_col,5
	sub blue_enemy_row,7
	mov blue_movement_type, 0
	jmp normal_movement
bottom_left:
	sub blue_enemy_col,7
	add blue_enemy_row,5
	mov blue_movement_type, 1
	jmp normal_movement
	
bottom_right:
	add blue_enemy_row,5
	add blue_enemy_col,7
	mov blue_movement_type, 2
	jmp normal_movement

top_left:
	sub blue_enemy_row,7
	sub blue_enemy_col,5
	mov blue_movement_type, 3
	jmp normal_movement


normal_movement:
cmp blue_enemy_col, 12
jbe top_right
cmp blue_enemy_col,314
jae bottom_left
cmp blue_enemy_row,12
jbe bottom_right
cmp blue_enemy_row,185
jae top_left


; top_left_movement:
; dec blue_enemy_col
; dec blue_enemy_row
; jmp make_blue_enemy_pixel

; top_right_movement:
; dec blue_enemy_row
; inc blue_enemy_col
; jmp make_blue_enemy_pixel

; bottom_right_movement:
; inc blue_enemy_row
; inc blue_enemy_row
; jmp make_blue_enemy_pixel

; bottom_left_movement:
; inc blue_enemy_row
; dec blue_enemy_col

make_blue_enemy_pixel:
; Ememy 1 (Light Blue)
mov ah, 0ch
mov cx, blue_enemy_col
mov dx, blue_enemy_row
mov al, 3
int 10h

;Ememy 1 (Blue-Black)
mov ah, 0ch
mov cx, black_blue_enemy_col
mov dx, black_blue_enemy_row
mov al, 0
int 10h
ret
move_blue_enemy endp

intersection_with_blue proc

	mov collision_with_blue,0
	mov dx, col_num
	cmp blue_enemy_col, dx
	je label1
	jmp ret_inter_blue
	label1:
		mov dx, row_num
		cmp blue_enemy_row,dx
		je label2
		jmp ret_inter_blue
	label2:
		mov collision_with_blue,1
		dec live
		
		
ret_inter_blue:


ret
intersection_with_blue endp




end main

