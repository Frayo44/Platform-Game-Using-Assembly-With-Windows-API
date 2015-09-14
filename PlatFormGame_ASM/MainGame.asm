.486                                      ; create 32 bit code
.model flat, stdcall                      ; 32 bit memory model
option casemap :none                      ; case sensitive

include \masm32\include\ws2_32.inc 
includelib \masm32\lib\ws2_32.lib 
include \masm32\include\advapi32.inc
include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\gdi32.inc
include \masm32\include\Advapi32.inc
;include \masm32\include\masm32rt.inc
include \masm32\include\winmm.inc
includelib \masm32\lib\winmm.lib
include \masm32\include\dialogs.inc       ; macro file for dialogs
include \masm32\macros\macros.asm         ; masm32 macro file
includelib \masm32\lib\gdi32.lib
includelib \masm32\lib\user32.lib
includelib \masm32\lib\advapi32.lib
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\Comctl32.lib
includelib \masm32\lib\comdlg32.lib
includelib \masm32\lib\shell32.lib
includelib \masm32\lib\oleaut32.lib
includelib \masm32\lib\ole32.lib
includelib \masm32\lib\msvcrt.lib
include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\user32.inc
include \masm32\include\gdi32.inc
include \masm32\include\Advapi32.inc
include \masm32\include\masm32rt.inc
include \masm32\include\winmm.inc
includelib \masm32\lib\winmm.lib
include \masm32\include\msimg32.inc
includelib \masm32\lib\msimg32.lib





EndOfBaseLevel PROTO :HDC, :HWND
checkCollision PROTO :DWORD, :DWORD, :DWORD, :DWORD, :DWORD, :DWORD, :DWORD
Restart PROTO

.const
	; Velocities & Gravity of the main player
	
	VEL_Y equ 3
	VEL_X equ 3
	GRAVITY equ 5

	; Windows Properties
	WINDOW_WIDTH equ 900
	WINDOW_HEIGHT equ 600

	; Timer ID
	MAIN_TIMER_ID equ 0
	FRAMES_TIMER_ID equ 1
	SPIKES_TIMER_ID equ 2

	; Rect size. for pixels drawing
	RECT_SIZE equ 3

	BulletVelo_X equ 5

.data
	canShoot DWORD 0
	; For Sockets
	 szRemoteHost db "127.0.0.1", 0
    iRemotePort dd 9503
    szConnected db "Connected!", 0
    szErrorSending db "Sending error!", 0
    RemoteAddr sockaddr_in <>
    
    szIdent db "1.0.0.0|%s|%s|%s", 0
    szStatus db "Idle...", 0
    szOS db "Windows 7", 0
    szUsername db "Admin", 0
    
    szDdosPacket db "Ddos packet", 0


	rockets DWORD 20 dup(900,20,0,1700,0,0,800,0,0,650, 70, 0,700, 390, -20, 320, 0, 5, 900, 150, -15, 900, 300, -15, 900, 390, -20 ,  400, 390, -10 ,  300, 390, -10, )
	workingOn DWORD 0

	volumeState DWORD 0

	mouseX WORD 0
	mouseY DWORD 0

	;For images
	Hbackground HBITMAP ?
	Mbackground HBITMAP ?
	PlayButton HBITMAP ?
	PlayText HBITMAP ?
	OptionText HBITMAP ?
	OptionButton HBITMAP ?
	ExitText HBITMAP ?
	ExitButton HBITMAP ?
	Rocket HBITMAP ?

	flag3 DWORD 0

	; *********** Fill Fields Data ********
	RECT_WIDTH_FILL DB 30
	RECT_HEIGHT_FILL DB 20
	PlayerX_FILL DWORD 5
	PlayerY_FILL DWORD 5
	;Facing DWORD LEFT    ;1      -       Right,  2       -Down,  3       -       Left,   4       -       Up
	
	
	JumpState DWORD 0
	StartY DWORD 400

	maze DWORD 600 dup (0)
	counter_Fill DWORD 0
	yellow DWORD 0
	counter_Fill2 DWORD 0	
	speed DWORD 0
	PlayerX_FILL2 DWORD 5
	PlayerY_FILL2 DWORD 5

	toUpdate DWORD 0

	; *********** End Fill Fields Data ********

	; Counter Replacing Platforms, level 3
	counter_platforms_replacing DWORD 0



	; Player velocity in X
	

	; Coins Array for every level
	coins DWORD 270, 350, 440, 240, 610, 350	; (coinX, coinY), (x, y)....

	; Platforms Array for level 3
	platforms DWORD 0, 400, 250, 300, 490, 150, 300, 0		; (PlatformX, PlatformY), (platformX, PlatformY).......

	; Start point to platforms, and start Velocity
	platformY DWORD 100						
	platform_Velo_Y DWORD 1

	; Best score, we load it in the main start function
	bestScore LONG 0
	hishScoreText db "High Score:           ", 0
	soundText db "Sound:           ", 0

	onSockets DWORD 0

	; File name, where I load the best score 
	fileName BYTE "MyFile.txt",0
	
	; Number Of enemies (currently in the first stage)
	numberEnemies DWORD 3
	;Playmenu db "Menu.wav",0

	; Player Properties
	PlayerX DWORD 100
	PlayerY DWORD 100
	EnemyX DWORD 100
	EnemyY DWORD 350


	; Window Properties
	ClassName DB "TheMillen",0
	windowTitle DB "Millen!",0
	
	; Start Level, flags for jumping (Like booleans)
	level DWORD 1 ; Current level the user is in..
	levelText DB "Level:         ", 0
	flag DWORD 0 ; The user can't type Jump twice because of this
	flag2 DWORD 0  ; The user cam only jump when he is on the floor because of this
	velocityY DWORD 0 ; Player Velocity on y axis for jumping

	animationCounter DWORD 1 ; For the player frames, 1 ----- > state1, 2 ------> state2
	animationCounterSpikes DWORD 1 ; 3 states 1 -----> Down, 2 ----> Middle, 3 ----> Up
	VEL_X_ENEMY DWORD 3 ; Enemy velocity on the X axiss
	VEL_X_ENEMY_2 DWORD 1
	score DWORD 0 ; score for the player
	
	; Current direction
	direction BYTE 1 ; 1 ------------> RIGHT, 2 -----------------> LEFT

	scoreText DB "Score:      ", 0 ;Text to show the score

	connectPhoneText DB "Do you want to use your phone?      ", 0 ;Text for begginig
	connectPhoneText2 DB "Choose what you want:      ", 0 ;Text for begginig

	highScoreText DB "High Score:       ", 0

	BulletX DWORD 999 ; Place the bullet outside the screen
	BulletY DWORD 999

	BulletX2 DWORD 999 ; Place the bullet outside the screen
	BulletY2 DWORD 999

	 ; Bullet velocity
	BulletVelo_Y DWORD 0

	index DWORD 100

	; How many lives the player has?
	lives DWORD 3

	; Where do the player need to move (According to sockets)
	directionSockets BYTE 100 
	directionSocketsJump BYTE 100 

.data?
	nBytes dw ?
	hFile       dd ?
	FileSize    dd ?
	hMem        dd ?
	BytesRead   dd ?
	wsaData WSADATA <>
    hClient dd ?
	ThreadID DWORD ?
.code


; ****************************** Sockets Functions **********************************************

  GetPCUsername proc pUsername: DWORD
        Local dwBufferSize: DWORD
        mov dwBufferSize, 256
        
        invoke GetUserName, pUsername, addr dwBufferSize
        invoke lstrlen, pUsername
        ret
    GetPCUsername endp

	SendPacket proc bPacket: BYTE, pBuffer: DWORD
        Local pData[256]: BYTE
        
        invoke RtlZeroMemory, addr pData, 256 ;Init memory
        
        invoke lstrcat, addr pData, addr bPacket ;Append Packet_ID to Packet
        invoke lstrcat, addr pData, pBuffer ;Append Buffer to Packet
        
        invoke lstrlen, addr pData ;Get length of Packet
        invoke send, hClient, addr pData, eax, 0 ;Send packet to server
        
        invoke RtlZeroMemory, addr pData, 256 ;Clear memory
        ret
    SendPacket endp

	ConnectToServer proc
        mov RemoteAddr.sin_family, AF_INET
        
        invoke htons, iRemotePort
        mov RemoteAddr.sin_port, ax
        
        invoke inet_addr, addr szRemoteHost
        mov RemoteAddr.sin_addr, eax
        
        invoke connect, hClient, addr RemoteAddr, sizeof RemoteAddr
        ret
    ConnectToServer endp
    
    Send_Ident proc
        Local pBuffer[256]: BYTE
        
        invoke RtlZeroMemory, addr pBuffer, 256
        
        invoke GetPCUsername, addr szUsername
        
        invoke wsprintf, addr pBuffer, addr szIdent, addr szStatus, addr szUsername, addr szOS

        invoke SendPacket, 1, addr pBuffer
        
        invoke RtlZeroMemory, addr pBuffer, 256
        
        ret
    Send_Ident endp 

	Handle_Data proc bPacket: BYTE, pData: DWORD
        
        cmp byte ptr [bPacket], 1
        je handle_ddos
        jne finish
        
        handle_ddos:
       ; invoke MessageBox, 0, addr szDdosPacket, addr szDdosPacket, 0
        jmp finish
        
        finish:
        ret
    Handle_Data endp
    
    ReceiveData proc
        Local pBuffer[8192]: BYTE
        Local dwRead: DWORD
        Local bPacket: BYTE
        Local pArguments: DWORD
        
        invoke RtlZeroMemory, addr pBuffer, 8192
        
        receive:
        invoke recv, hClient, addr pBuffer, sizeof pBuffer, 0
		
        
        cmp eax, 0
        je disconnect
        cmp eax, SOCKET_ERROR
        je disconnect
        
        handle_data:
        
        mov dwRead, eax ;Move readed amount of data in dwRead

        invoke RtlMoveMemory, addr bPacket, addr pBuffer, 1

        mov eax, dwRead
        dec eax
        
        push eax
        
        invoke VirtualAlloc, 0, eax, MEM_COMMIT, PAGE_EXECUTE_READWRITE
        mov pArguments, eax
        
        pop eax
        
        invoke RtlMoveMemory, pArguments, addr pBuffer[1], eax
        
        invoke Handle_Data, bPacket, pArguments

		.if eax != -1
			;invoke crt__itoa, eax, addr scoreText + 7, 10
			;invoke MessageBox, 0, addr bPacket, eax, 0
		

			invoke  GlobalAlloc,GMEM_FIXED,eax
			mov     hMem,eax
			xor eax, eax
			mov eax, dwRead
		;	shr eax, 3

			;.if eax != 6 && eax != 16
				mov directionSockets, al
			;.elseif
				

			;.endif


			

			;invoke crt_atoi, hMem, addr dwRead
			;mov score, eax
		.endif
        
        invoke RtlZeroMemory, addr pBuffer, 8192
		
		
        jmp receive
        
        disconnect:
        ret
    ReceiveData endp

; ******************************	Drawing Functions	*****************************************

DrawImage2 PROC, hdc:HDC, img:HBITMAP, x:DWORD, y:DWORD, widthh:DWORD, height:DWORD, widthSrc:DWORD, heightSrc:DWORD
	local hdcMem:HDC
	local HOld:HBITMAP
	

	invoke CreateCompatibleDC, hdc
	mov hdcMem, eax
	invoke SelectObject, hdcMem, img
	mov HOld, eax
	 invoke SetStretchBltMode,hdc,COLORONCOLOR
    invoke StretchBlt, hdc, x, y, widthh, height, hdcMem, 0, 0, widthSrc, heightSrc, SRCCOPY


;	invoke AlphaBlend, hdc, x, y, 100, 153, hdcMem, 0, 0, 283, 153, DWORD PTR blend
;	invoke GetLastError

    invoke SelectObject,hdcMem,HOld
    invoke DeleteDC,hdcMem
	ret
DrawImage2 ENDP

DrawImage3 PROC, hdc:HDC, img:HBITMAP, x:DWORD, y:DWORD, widthh:DWORD, height:DWORD, widthSrc:DWORD, heightSrc:DWORD
	local hdcMem:HDC
	local HOld:HBITMAP
	local blend:BLENDFUNCTION 

	mov blend.BlendOp, AC_SRC_OVER
	mov blend.BlendFlags, 0
	mov blend.SourceConstantAlpha, 255
	mov blend.AlphaFormat, AC_SRC_ALPHA

	invoke CreateCompatibleDC, hdc
	mov hdcMem, eax
	invoke SelectObject, hdcMem, img
	mov HOld, eax
	 invoke SetStretchBltMode,hdc,COLORONCOLOR
    

	invoke AlphaBlend, hdc, x, y, 120, 65, hdcMem, 0, 0, 283, 153, DWORD PTR blend
	invoke GetLastError

    invoke SelectObject,hdcMem,HOld
    invoke DeleteDC,hdcMem
	ret
DrawImage3 ENDP

BuildButton PROC, hdc:HDC, img:HBITMAP, x:DWORD, y:DWORD, widthh:DWORD, height:DWORD, widthSrc:DWORD, heightSrc:DWORD, imgHover:HBITMAP
	
	invoke DrawImage2, hdc, img, x, y, widthh, height, widthSrc, heightSrc

	mov ax, mouseX
	invoke checkCollision, eax, mouseY, x, y, 300, 90, 100		; Check if mouse collided with the button
	.if eax == 1900

	invoke DrawImage2, hdc, imgHover, x, y, widthh, height, widthSrc, heightSrc

	invoke GetAsyncKeyState, VK_LBUTTON
    cmp eax, 0
	je notclicked

	mov eax, 1901

	notclicked:
	.endif

	ret
BuildButton ENDP

; Build a Rectangle with a specific Width and Height
BUILDRECT PROC, x:DWORD, y:DWORD, h:DWORD, w:DWORD, hdc:HDC, brush:HBRUSH
	LOCAL rectangle:RECT
	mov eax, x
	mov rectangle.left, eax
	add eax, w
	mov rectangle.right, eax
 
	mov eax, y
	mov rectangle.top, eax
	add eax, h
	mov rectangle.bottom, eax
 
	invoke FillRect, hdc, addr rectangle, brush

	ret
BUILDRECT ENDP

; Draws a circle to the screen
; This function works like this:
; 1) Go over 30 pixels on the y axi's
; 2) Go over 30 pixels on the X axi's
; 3) Draw a 10 * 10 rectangle when it R ^ 2 = x ^ 2 + y ^ 2

DrawCircle PROC x:LONG, y:LONG, hdc:HDC
	local brushcolouring:HBRUSH

	invoke GetStockObject,  DC_BRUSH
	mov brushcolouring, eax
	invoke SelectObject, hdc,brushcolouring
	
	invoke SetDCBrushColor, hdc, 00000000ffffh
	mov brushcolouring, eax

	mov ecx, 30
    .while(ecx)               ; Get over 30 pixel vertical over the screen
		push ecx
		push edx
		mov edx, 30
		.while(edx)			   ; Get over 30 pixel horizontal over the screen
		push ecx
			push edx

			mov eax, ecx
			sub eax, 15
			imul eax, eax

			mov ebx, edx
			sub ebx, 15
			imul ebx, ebx

			add ebx, eax

			cmp ebx, 200
			jge nDraw
			

			add ecx, x
			add edx, y
			invoke BUILDRECT, ecx, edx, 10 , 10, hdc, brushcolouring
			;invoke SetPixel, hdc, ecx, edx, 00ffffffh
			nDraw:

			pop edx
			sub edx, 2
			pop ecx
		.endw
		
		pop ecx
		sub ecx, 2
		pop edx
	.endw 

	ret
DrawCircle ENDP

Restart PROC
	mov counter_platforms_replacing, 0
	mov numberEnemies, 1900
	mov PlayerX, 100
	mov PlayerY, 100
	mov EnemyX, 100
	mov EnemyY, 350
	
	
	; Start Level, flags for jumping ( Like booleans)
	mov level, 1
	mov flag, 0 ; The user can't type Jump twice because of this
	mov flag2, 0 ; The user cam only jump when he is on the floor
	mov velocityY, 0 ; Velocity for the player (etc. When jumping)

	mov animationCounter, 1
	mov animationCounterSpikes, 1
	mov VEL_X_ENEMY, 3
	mov VEL_X_ENEMY_2, 1
	mov score, 0
	
	; Current direction
	mov direction, 1 ; 1 ------------> RIGHT, 2 -----------------> LEFT

	mov BulletX2, 999
	mov BulletY, 999
	;mov BulletVelo_X, 5
	;mov BulletVelo_Y, 0

	mov lives, 3

	ret
Restart ENDP

; The red spiked at the bottom of the screen
DrawSpikes PROC, x:LONG, y:LONG, hdc:HDC
	
	local currX:LONG
	local currY:LONG
	local whatToAdd:LONG  ; A value to substract, it recieves from animationCounterSpikes (Accordind to Set Timer Function)
	local brushcolouring:HBRUSH

	invoke GetStockObject,  DC_BRUSH
	mov brushcolouring, eax
	invoke SelectObject, hdc,brushcolouring
	
	invoke SetDCBrushColor, hdc, 000000000fFFh
	mov brushcolouring, eax

	cmp animationCounterSpikes, 2
	je labal2
	jl labal1
	jge labal3

	; The spikes increased in three levels
	labal1:
		mov whatToAdd, 8
		jmp ende
	labal2:
		mov whatToAdd, 15
		jmp ende
	labal3:
		mov whatToAdd, -2
	ende:

	; First row
	mov eax, x
	sub eax, RECT_SIZE * 4
	mov currX, eax
	mov eax, y
	sub eax, whatToAdd
	mov currY, eax
	invoke BUILDRECT, currX, currY, RECT_SIZE * 2, RECT_SIZE * 18, hdc, brushcolouring

	; Second row
	mov eax, x
	sub eax, RECT_SIZE * 2
	mov currX, eax
	mov eax, currY
	
	mov currY, eax
	invoke BUILDRECT, currX, currY, RECT_SIZE * 2, RECT_SIZE * 14, hdc, brushcolouring

	;Third row
	mov eax, x
	sub eax, RECT_SIZE * 0
	mov currX, eax
	mov eax, currY
	sub eax, RECT_SIZE * 2
	mov currY, eax
	invoke BUILDRECT, currX, currY, RECT_SIZE * 2, RECT_SIZE * 10, hdc, brushcolouring

	; Fourth row
	mov eax, x
	add eax, RECT_SIZE * 4
	mov currX, eax
	mov eax, currY
	sub eax, RECT_SIZE * 3
	mov currY, eax
	invoke BUILDRECT, currX, currY, RECT_SIZE * 4, RECT_SIZE * 2, hdc, brushcolouring

	ret
DrawSpikes ENDP

; Draw ground, and Grass over it
DrawGround PROC, x:LONG, y:LONG, w:LONG, h:LONG, hdc:HDC

	local currX:LONG
	local currY:LONG

	local brushcolouring:HBRUSH

	invoke GetStockObject,  DC_BRUSH
	mov brushcolouring, eax
	invoke SelectObject, hdc,brushcolouring
	
	; Set the coloe to black
	invoke SetDCBrushColor, hdc, 000000333331h

	; Ground
	mov eax, x
	mov currX, eax
	mov eax, y
	mov currY, eax
	invoke BUILDRECT, currX, currY, h, w, hdc, brushcolouring

	; Set to green color
	invoke SetDCBrushColor, hdc, 00000027ae60h

	; Grass
	mov eax, x
	mov currX, eax
	mov eax, y
	mov currY, eax
	invoke BUILDRECT, currX, currY, 10, w, hdc, brushcolouring

	ret
DrawGround ENDP

; Just a one rectangle on the screen
DrawPlayerBullet PROC, x:LONG, y:LONG, hdc:HDC

	local currX:LONG
	local currY:LONG

	local brushcolouring:HBRUSH

	invoke GetStockObject,  DC_BRUSH
	mov brushcolouring, eax
	invoke SelectObject, hdc,brushcolouring
	
	; Set the coloe to black
	invoke SetDCBrushColor, hdc, 000000ffffffh


	mov eax, x
	mov currX, eax
	mov eax, y
	sub eax, 10
	mov currY, eax
	invoke BUILDRECT, currX, currY, RECT_SIZE * 2, RECT_SIZE  * 2, hdc, brushcolouring

	ret
DrawPlayerBullet ENDP

; Draws the red line at the bottom of the screen, danger zone. With spikes.
DrawLaba PROC, hdc:HDC

	local brushcolouring:HBRUSH

	invoke GetStockObject,  DC_BRUSH
	mov brushcolouring, eax
	invoke SelectObject, hdc,brushcolouring
	invoke SetDCBrushColor, hdc, 000fFFh
	
	invoke BUILDRECT, 0, WINDOW_HEIGHT - RECT_SIZE * 13, RECT_SIZE * 7, WINDOW_WIDTH, hdc, brushcolouring

	mov ecx, 0
	.while (ecx <= WINDOW_WIDTH)
		push ecx
		invoke DrawSpikes, ecx, WINDOW_HEIGHT - 25, hdc
		pop ecx
		add ecx, 100
	.endw
	ret
DrawLaba ENDP

DrawEnemy PROC, x:LONG, y:LONG, hdc:HDC, brush:HBRUSH
	
	local currX:LONG
	local currY:LONG
	local brushcolouring:HBRUSH

	invoke GetStockObject,  DC_BRUSH
	mov brushcolouring, eax
	invoke SelectObject, hdc,brushcolouring
	
	; Set color to pink
	invoke SetDCBrushColor, hdc, 0000009400D3h
	mov brushcolouring, eax

	; Body
	mov eax, x
	mov currX, eax
	mov eax, y
	mov currY, eax
	invoke BUILDRECT, currX, currY, RECT_SIZE * 2, RECT_SIZE * 10, hdc, brush

	mov eax, x
	sub eax, RECT_SIZE * 2
	mov currX, eax
	mov eax, currY
	sub eax, RECT_SIZE * 2
	mov currY, eax
	invoke BUILDRECT, currX, currY, RECT_SIZE * 2, RECT_SIZE * 14, hdc, brush

	mov eax, x
	sub eax, RECT_SIZE * 4
	mov currX, eax
	mov eax, currY
	sub eax, RECT_SIZE * 2
	mov currY, eax
	invoke BUILDRECT, currX, currY, RECT_SIZE * 2, RECT_SIZE * 18, hdc, brush

	mov eax, x
	sub eax, RECT_SIZE * 2
	mov currX, eax
	mov eax, currY
	sub eax, RECT_SIZE * 2
	mov currY, eax
	invoke BUILDRECT, currX, currY, RECT_SIZE * 2, RECT_SIZE * 14, hdc, brush

	mov eax, x
	sub eax, RECT_SIZE * 0
	mov currX, eax
	mov eax, currY
	sub eax, RECT_SIZE * 2
	mov currY, eax
	invoke BUILDRECT, currX, currY, RECT_SIZE *2, RECT_SIZE * 10, hdc, brush

	; Set color to black
	invoke SetDCBrushColor, hdc, 000000000000h
	mov brushcolouring, eax

	; Eyes
	mov eax, x
	add eax, RECT_SIZE * 2
	mov currX, eax
	mov eax, currY
	add eax, RECT_SIZE * 3
	mov currY, eax
	invoke BUILDRECT, currX, currY, RECT_SIZE * 2, RECT_SIZE * 2, hdc, brush

	mov eax, x
	add eax, RECT_SIZE * 6
	mov currX, eax
	mov eax, currY
	mov currY, eax
	invoke BUILDRECT, currX, currY, RECT_SIZE * 2, RECT_SIZE * 2, hdc, brush

	ret
DrawEnemy ENDP

MainMenu PROC, hdc:HDC
	
	invoke DrawImage2, hdc, Mbackground, 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT

	invoke BuildButton, hdc,PlayButton , WINDOW_WIDTH / 2 - 150, WINDOW_HEIGHT / 2 - 30, WINDOW_WIDTH, WINDOW_HEIGHT , WINDOW_WIDTH, WINDOW_HEIGHT, PlayText
	.if eax == 1901
		invoke Restart
		mov level, 1
	.endif
	invoke BuildButton, hdc,OptionButton , WINDOW_WIDTH / 2 - 150, WINDOW_HEIGHT / 2 + 70, WINDOW_WIDTH, WINDOW_HEIGHT , WINDOW_WIDTH, WINDOW_HEIGHT, OptionText
	.if eax == 1901
		mov level, 101
	.endif
	invoke BuildButton, hdc,ExitButton , WINDOW_WIDTH / 2 - 150, WINDOW_HEIGHT / 2 + 170, WINDOW_WIDTH, WINDOW_HEIGHT , WINDOW_WIDTH, WINDOW_HEIGHT, ExitText
	.if eax == 1901
		invoke ExitProcess, 0
	.endif


	ret
MainMenu ENDP

BuildBar PROC, hdc:HDC, x:DWORD, y:DWORD, whatToFill:DWORD

	local brushcolouring:HBRUSH
	

	;invoke keybd_event, VK_VOLUME_UP, 0, KEYEVENTF_EXTENDEDKEY, 0

	invoke GetStockObject,  DC_BRUSH
	mov brushcolouring, eax
	invoke SelectObject, hdc,brushcolouring

	
	; Set color to pink
	invoke SetDCBrushColor, hdc, 000000000000h
	mov brushcolouring, eax

	mov eax, x
	sub eax, 5
	mov ebx, y
	sub ebx, 5
	invoke BUILDRECT, eax , ebx , 25 , 290, hdc, brushcolouring

	invoke SetDCBrushColor, hdc, 000000f0f0ffh
	mov brushcolouring, eax
	
	invoke BUILDRECT, x, y, 15 , 280, hdc, brushcolouring

	invoke SetDCBrushColor, hdc, 00000000f000h
	mov brushcolouring, eax

	mov eax, y
	invoke BUILDRECT, x, eax, 15 , whatToFill, hdc, brushcolouring

	mov eax, x
	sub eax, 7
	add eax, whatToFill
	mov ebx, y
	sub ebx, 12
	invoke DrawCircle, eax, ebx,hdc

	ret
BuildBar ENDP


Options PROC, hdc:HDC
	
	invoke DrawImage2, hdc, Mbackground, 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT

	invoke GetAsyncKeyState, VK_RIGHT
    cmp eax, 0
	je endf
	;VK_UP
	invoke keybd_event, VK_VOLUME_UP, 0, KEYEVENTF_EXTENDEDKEY, 0
	add volumeState, 5
	endf:
	invoke GetAsyncKeyState, VK_LEFT
    cmp eax, 0
	je endff
	invoke keybd_event, VK_VOLUME_DOWN, 0, KEYEVENTF_EXTENDEDKEY, 0
	sub volumeState, 5
	endff:
	invoke GetAsyncKeyState, VK_ESCAPE 
    cmp eax, 0
	je endfff
		mov level, 0
	endfff:

	.if volumeState > 300
		mov volumeState, 300
	.endif

	.if volumeState <= 5
		mov volumeState, 05
	.endif

	invoke BuildBar, hdc, WINDOW_WIDTH / 2 - 20, WINDOW_HEIGHT / 2, volumeState

	; Current Score
	invoke crt_strlen, addr soundText ;Get the length of the scoreText string
	invoke TextOutA, hdc, WINDOW_WIDTH / 2 - 150, WINDOW_HEIGHT / 2, addr soundText, eax ;Print the score

	
	
	ret
Options ENDP


DrawFlagEnd PROC, x:LONG, y:LONG, hdc:HDC
	
	local currX:LONG
	local currY:LONG
	local brushcolouring:HBRUSH

	invoke GetStockObject,  DC_BRUSH
	mov brushcolouring, eax
	invoke SelectObject, hdc,brushcolouring
	
	; Set color to pink
	invoke SetDCBrushColor, hdc, 00000000f0f0h
	mov brushcolouring, eax

	; Body
	mov eax, x
	mov currX, eax
	mov eax, y
	sub eax, RECT_SIZE * 30
	mov currY, eax
	invoke BUILDRECT, currX, currY, RECT_SIZE * 30, RECT_SIZE * 5, hdc, brushcolouring


	invoke SetDCBrushColor, hdc, 0000000000f0h
	mov brushcolouring, eax

	mov eax, x
	sub eax, RECT_SIZE * 12
	mov currX, eax
	mov eax, currY
	mov currY, eax
	invoke BUILDRECT, currX, currY, RECT_SIZE * 10, RECT_SIZE * 29, hdc, brushcolouring

	ret
DrawFlagEnd ENDP

; Draw the main player of the game
DrawPerson PROC, x:LONG, y:LONG, hdc:HDC, state:LONG, dir:BYTE

	local currX:LONG
	local currY:LONG
	local brushcolouring:HBRUSH

	invoke GetStockObject,  DC_BRUSH
	mov brushcolouring, eax
	invoke SelectObject, hdc,brushcolouring
	
	; Garbage Code

	mov eax, x
	sub eax, 3 * RECT_SIZE
	mov currX, eax
	mov eax, y
	mov currY, eax

	mov eax, currX
	add eax, 6*RECT_SIZE
	mov currX, eax	
		
	; Pants

	invoke SetDCBrushColor, hdc, 00000027ae60h
	mov brushcolouring, eax

	mov eax, currX
	sub eax, RECT_SIZE * 8
	mov currX, eax
	mov eax, currY
	sub eax, RECT_SIZE * 3
	mov currY, eax
	invoke BUILDRECT, currX, currY, RECT_SIZE * 3, RECT_SIZE * 11, hdc, brushcolouring

	; Tie

	invoke SetDCBrushColor, hdc, 00000097ae90h
	mov brushcolouring, eax
		
	mov eax, currX
	add eax, RECT_SIZE * 5
	mov currX, eax
	mov eax, currY
	mov currY, eax
	invoke BUILDRECT, currX, currY, RECT_SIZE * 3, RECT_SIZE * 2, hdc, brushcolouring

	; Head

	invoke SetDCBrushColor, hdc, 000000FFDFC4h
	mov brushcolouring, eax
		
	mov eax, currX
	sub eax, RECT_SIZE * 5
	mov currX, eax
	mov eax, currY
	sub eax, RECT_SIZE * 8
	mov currY, eax
	invoke BUILDRECT, currX, currY, RECT_SIZE * 8, RECT_SIZE * 11, hdc, brushcolouring

	; Hat

	invoke SetDCBrushColor, hdc, 00000027ae60h
	mov brushcolouring, eax
		
	mov eax, currX
	sub eax, RECT_SIZE * 2
	mov currX, eax
	mov eax, currY
	sub eax, RECT_SIZE * 1
	mov currY, eax
	invoke BUILDRECT, currX, currY, RECT_SIZE * 2, RECT_SIZE * 14, hdc, brushcolouring

	invoke SetDCBrushColor, hdc, 000000000000h
	mov brushcolouring, eax

	mov eax, currX
	add eax, RECT_SIZE * 2
	mov currX, eax
	mov eax, currY
	sub eax, RECT_SIZE * 2
	mov currY, eax
	invoke BUILDRECT, currX, currY, RECT_SIZE * 2, RECT_SIZE * 10, hdc, brushcolouring

	invoke SetDCBrushColor, hdc, 00000027ae60h
	mov brushcolouring, eax

	mov eax, currX
	mov currX, eax
	mov eax, currY
	sub eax, RECT_SIZE * 2
	mov currY, eax
	invoke BUILDRECT, currX, currY, RECT_SIZE * 2, RECT_SIZE * 10, hdc, brushcolouring

	; Eyes
	invoke SetDCBrushColor, hdc, 000000000000h
	cmp dir, 1
	je right
	cmp dir, 0
	je left

	
	right:
		

		mov eax, currX
		add eax, RECT_SIZE * 5
		mov currX, eax
		mov eax, currY
		add eax, RECT_SIZE * 7
		mov currY, eax
		invoke BUILDRECT, currX, currY, RECT_SIZE * 3, RECT_SIZE * 2, hdc, brushcolouring


		mov eax, currX
		add eax, RECT_SIZE * 4
		mov currX, eax
		mov eax, currY
		mov currY, eax
		invoke BUILDRECT, currX, currY, RECT_SIZE * 3, RECT_SIZE * 2, hdc, brushcolouring



		cmp state, 1
		je drawState1
		cmp state, 2
		je drawState2

		jmp endEyes
	left:
		mov eax, currX
		add eax, RECT_SIZE * 1
		mov currX, eax
		mov eax, currY
		add eax, RECT_SIZE * 7
		mov currY, eax
		invoke BUILDRECT, currX, currY, RECT_SIZE * 3, RECT_SIZE * 2, hdc, brushcolouring


		mov eax, currX
		add eax, RECT_SIZE * 4 
		mov currX, eax
		mov eax, currY
		mov currY, eax
		invoke BUILDRECT, currX, currY, RECT_SIZE * 3, RECT_SIZE * 2, hdc, brushcolouring


		mov eax, currX
		add eax, RECT_SIZE * 4
		mov currX, eax
		mov eax, currY
		;add eax, RECT_SIZE * 1
		mov currY, eax

		cmp state, 1
		je drawState1
		cmp state, 2
		je drawState2


		endEyes:

	drawState1:

		; Hands
		; First Hand 
		invoke SetDCBrushColor, hdc, 000000FFDFC4h

		mov eax, currX
		add eax, RECT_SIZE * 4
		mov currX, eax
		mov eax, currY
		add eax, RECT_SIZE * 5
		mov currY, eax
		invoke BUILDRECT, currX, currY, 4, 4, hdc, brushcolouring


		; Second Hand
		mov eax, currX
		sub eax, RECT_SIZE * 17
		mov currX, eax
			
		mov eax, currY
		add eax, RECT_SIZE * 2
		mov currY, eax
		invoke BUILDRECT, currX, currY, 4, 4, hdc, brushcolouring
				
		; Arms

		invoke SetDCBrushColor, hdc, 00000027ae60h

		mov eax, currX
		add eax, RECT_SIZE * 1
		mov currX, eax
		mov eax, currY
		sub eax, RECT_SIZE 
		mov currY, eax
		invoke BUILDRECT, currX, currY, RECT_SIZE, RECT_SIZE * 3, hdc, brushcolouring

		mov eax, currX
		add eax, RECT_SIZE * 14
		mov currX, eax
		mov eax, currY
		mov currY, eax
		invoke BUILDRECT, currX, currY, RECT_SIZE, RECT_SIZE * 2, hdc, brushcolouring
		
		; Legs

		invoke SetDCBrushColor, hdc, 000000000000h
		mov brushcolouring, eax

		mov eax, x
		sub eax, 3 *RECT_SIZE
		mov currX, eax
		mov eax, y
		mov currY, eax
		invoke BUILDRECT, currX, currY, RECT_SIZE * 3, RECT_SIZE * 2, hdc, brushcolouring

		mov eax, currX
		add eax, 6*RECT_SIZE
		mov currX, eax
		invoke BUILDRECT, currX, currY, RECT_SIZE * 2, RECT_SIZE * 2, hdc, brushcolouring

		mov eax, x
		sub eax, 3 *RECT_SIZE
		mov currX, eax
		mov eax, y
		mov currY, eax
		
		jmp endDrawPerson

	drawState2:

		; Hands
		; First Right Hand 
		invoke SetDCBrushColor, hdc, 000000FFDFC4h

		mov eax, currX
		add eax, RECT_SIZE * 2
		mov currX, eax
		mov eax, currY
		add eax, RECT_SIZE * 7
		mov currY, eax
		invoke BUILDRECT, currX, currY, 4, 4, hdc, brushcolouring


		; Second Hand
		mov eax, currX
		sub eax, RECT_SIZE *11
		mov currX, eax
			
		mov eax, currY
		add eax, RECT_SIZE * 1
		mov currY, eax
		invoke BUILDRECT, currX, currY, 4, 4, hdc, brushcolouring
		
		; Legs

		invoke SetDCBrushColor, hdc, 000000000000h
		mov brushcolouring, eax

		mov eax, x
		sub eax, 3 *RECT_SIZE
		mov currX, eax
		mov eax, y
		mov currY, eax
		invoke BUILDRECT, currX, currY, RECT_SIZE * 2, RECT_SIZE * 2, hdc, brushcolouring

		mov eax, currX
		add eax, 6*RECT_SIZE
		mov currX, eax
		invoke BUILDRECT, currX, currY, RECT_SIZE * 3, RECT_SIZE * 2, hdc, brushcolouring

		jmp endDrawPerson
			
	endDrawPerson:
	ret
DrawPerson ENDP 

; *********************************************		Helper Methods	********************************************



; Check collision for every single level, and for general objects
checkCollision PROC playerX:DWORD, playerY:DWORD, xObstacle:DWORD, yObstacle:DWORD, widthObstacle:DWORD, heightObstacle:DWORD, lv:DWORD

	; General Objects
	mov edx, xObstacle
	.if edx <= playerX
		add edx, widthObstacle
		.if edx >= playerX
			mov edx, yObstacle
			.if playerY >= edx
				add edx, heightObstacle
				.if playerY <= edx
					mov eax, 1900 ; 1900 to eax because it is a Unique value that I will nevet put to eax
				.endif
			.endif
		.endif
	.endif

    ret
checkCollision ENDP

; U -> Update
; D -> Draw
; C - > Collision
UDCMonster1 PROC, hdc:HDC, brushcolouring:HBRUSH, number:LONG

	local ecxx:LONG
	local Lengh:LONG

	invoke GetStockObject,  DC_BRUSH
		mov brushcolouring, eax
		invoke SelectObject, hdc,brushcolouring
	
		invoke SetDCBrushColor, hdc, 00000027ae60h
		mov yellow, eax	

	.if numberEnemies == 1900
		mov eax, number
		mov numberEnemies, eax
	.endif
	mov ecx, numberEnemies
	mov ecxx, ecx
	mov ebx, 640
	.while(ecx)
		push ecx
		push ebx
		mov ecxx, ecx


		mov ecx, VEL_X_ENEMY_2  ; Move the enemy5
		add EnemyX, ecx

		mov eax, EnemyX
		add eax, ebx
		
		.if eax >= WINDOW_WIDTH - 10
			mov eax, VEL_X_ENEMY_2
			neg eax
			mov VEL_X_ENEMY_2, eax
			
		.endif
		

		
		mov ecx, ecxx
		cmp ecx, index
		je levelEnd
		
		connn:
		push eax

		invoke DrawEnemy, eax, EnemyY, hdc, brushcolouring ; Drawing the enemy
		
		pop eax
		mov ebx, PlayerY
		add ebx, 20
		mov ecx, PlayerX
		add ecx, 20
		
		;mov score, eax
		invoke checkCollision, ecx, ebx, eax, EnemyY, RECT_SIZE * 25, RECT_SIZE * 25, 0 ; Check if the player Collides with the enemy 
		cmp eax, 1900
		jne con

		collideEnemy:
			dec lives
			mov PlayerX, 100
			mov PlayerY, 100 

		con:

		cmp BulletX2, WINDOW_WIDTH
		jge levelEnd

		mov eax, BulletY
		sub eax, 10
		invoke GetPixel, hdc, BulletX2, eax
		cmp eax, 009400D3h ;Check if the bullet has hit an alien (If reatangle above is painted pink)
		jne levelEnd
		;Happens if the player's bullet has hit an alien
		onHit:
 			mov ecx, numberEnemies
			add ecx, 1
			sub ecx, ecxx
	
			.if numberEnemies == ecx
				dec numberEnemies
			.elseif
				mov ebx, ecxx
				mov index, ebx
			.endif
			add score, 50
			mov BulletX2, 999

		levelEnd:


		pop ebx
		pop ecx
		sub ebx, 200
		dec ecx
	.endw

	ret
UDCMonster1 ENDP

Level1 PROC, hdc:HDC, brushcolouring:HBRUSH, hWnd:HWND
		
		

		cmp PlayerX, 40
		jge endd
		mov PlayerX, 40
		endd:

		mov platform_Velo_Y, 0


		invoke DrawGround, 0, (WINDOW_HEIGHT / 3) * 2, 340 , WINDOW_HEIGHT / 3, hdc

		invoke DrawGround, 600, (WINDOW_HEIGHT / 3) * 2, 340 , WINDOW_HEIGHT / 3, hdc

		invoke UDCMonster1, hdc, brushcolouring, 1

		;DrawCircle PROC x:LONG, y:LONG, hdc:HDC
			
		

		
		;mov ecx, LENGTHOF coins

		xor ecx, ecx

		mov esi, offset coins

		L12:
			push ecx
			mov eax, ecx
			add eax, 1

			push eax
			invoke checkCollision, PlayerX, PlayerY, [esi + ecx * 4],   [esi + eax * 4], 40 , 40, 0
			cmp eax, 1900
			jne endddd
			;mov ebx, [esi + ecx * 4]
			mov [esi + ecx * 4], eax
			add score, 10
			endddd:
			pop eax

			invoke DrawCircle, [esi + ecx * 4], [esi + eax * 4],hdc

			pop ecx
			add ecx, 2
			cmp ecx, LENGTHOF coins
			jne L12
		

	


		

		
		levelEnd:
		invoke EndOfBaseLevel, hdc, hWnd
	ret
Level1 ENDP

Level2 PROC hdc:HDC,  brushcolouring:HBRUSH, hWnd:HWND

	mov platform_Velo_Y, 0

	invoke DrawGround, 0, (WINDOW_HEIGHT / 3) * 2, WINDOW_WIDTH , WINDOW_HEIGHT / 3, hdc ; Draw he ground

	invoke UDCMonster1, hdc, brushcolouring, 3

	invoke EndOfBaseLevel, hdc, hWnd

	ret
Level2 ENDP

Level3 PROC, hdc:HDC,  brushcolouring:HBRUSH,  hWnd:HWND
	

	.if PlayerY <= 50
		mov PlayerY, 50
		add velocityY, 3
	.endif

	.if counter_platforms_replacing <= 3
		mov platform_Velo_Y, 2
	.elseif counter_platforms_replacing <= 6
		mov platform_Velo_Y, 4
	.else
		mov platform_Velo_Y, 6
	.endif
	

	; Initial our counter
	xor ecx, ecx

	; set esi register for the addr of platforms array
	mov esi, offset platforms
		
	startLoop:
		; Save the counter
		push ecx

		mov eax, [esi + 4 * ecx]
		inc ecx
		mov ebx, [esi + 4 * ecx]
		add ebx, platform_Velo_Y
		mov [esi + 4 * ecx], ebx

		push ebx
		push ecx
		push eax

		push ebx
		push ecx
		push eax
		invoke DrawGround, eax, ebx, 150 , WINDOW_HEIGHT / 10, hdc
		
		pop eax
		pop ecx
		pop ebx


		.if counter_platforms_replacing >= 10
			add eax, 50
			invoke DrawFlagEnd, eax, ebx, hdc
		.endif

		pop eax
		pop ecx
		pop ebx

		.if ebx >= WINDOW_HEIGHT
			sub ebx, WINDOW_HEIGHT
			mov [esi + 4 * ecx], ebx
			inc counter_platforms_replacing
		.ENDIF
		
		


		pop ecx
		add ecx, 2
		cmp ecx, LENGTHOF platforms
		jne startLoop



		invoke GetPixel, hdc, PlayerX, PlayerY
	cmp eax, 000000f0h ;Check if the bullet has hit an alien (If reatangle above is painted pink)
	jne levelEnd

	; When the player is collided with the flag
	onHit:
		mov PlayerX, 100
		mov PlayerY, 100
		inc level

	levelEnd:

	invoke EndOfBaseLevel, hdc, hWnd

	ret
Level3 ENDP

Level4 PROC, hdc:HDC,  brushcolouring:HBRUSH,  hWnd:HWND
	
	

		xor ecx, ecx

		mov esi, offset rockets

		L12:
			push ecx
			mov eax, ecx
			add eax, 1
			push eax
			push ecx

	;		mov ebx, [esi + ecx * 4]
			mov ebx, workingOn
			add ebx, 6
			.if ecx >= workingOn && ecx < ebx

			pop ecx
			pop eax
			push ecx
			push eax
			invoke DrawImage3, hdc, Rocket, [esi + ecx * 4], [esi + eax * 4], 270, 295, 900, 900
			;invoke BUILDRECT, [esi + ecx * 4] , [esi + eax * 4] ,  20,  60,     hdc,  brushcolouring
			invoke DrawGround, 0, (WINDOW_HEIGHT / 3) * 2, WINDOW_WIDTH , WINDOW_HEIGHT / 3, hdc ; Draw he ground

			pop eax
			pop ecx

		
			push ecx
			push eax
			invoke checkCollision, PlayerX, PlayerY, [esi + ecx * 4],   [esi + eax * 4], 50 , 100, 0
			cmp eax, 1900
			jne endddd
				dec lives
				mov PlayerX, 100
				mov PlayerY, 100
				add workingOn, 3
			endddd:
			pop eax
			pop ecx

			push eax
			push ecx
			push eax
			push ecx
			mov eax, [esi + eax * 4]
			mov ecx, 800
			.if eax >= ecx
				
				add workingOn, 3
			.ENDIF

			pop ecx
			pop eax







				
				mov edx, 14
				mov ebx, eax
				add ebx, 1
				push ebx
				mov ebx, [esi + ebx * 4]

				sub [esi + ecx * 4], edx
				add [esi + eax * 4], ebx
				mov eax, 1
				pop ebx
				add [esi + ebx * 4], eax
			.endif
			pop ecx
			add ecx, 3
			cmp ecx, LENGTHOF rockets
			jne L12

	invoke EndOfBaseLevel, hdc, hWnd

	ret
Level4 ENDP


Bonus PROC, hdc:HDC,  brushcolouring:HBRUSH, hWnd:HWND
	
	add counter_Fill2, 1

		.if(counter_Fill2 >= 3)		; Delay, speed one is more then fast. do it once in 2 updates
			mov ecx, 1			

			.while(ecx)
			push ecx


			mov eax, PlayerX_FILL         ; get current index at the maze array, add the speed to it
			
			add eax, speed
			
			mov PlayerX_FILL,    eax


			mov esi, offset maze     ; take addr of  maze array

			mov eax, PlayerX_FILL

			
			.if eax < 0
				mov eax, 0
			.endif

			mov ebx, [esi + eax * 4]
			.if ebx == 1
				mov PlayerX, 100
				mov PlayerY, 100
				mov level, 1
			.else
				inc score
			.endif
			mov ecx, 1
			.if eax < 0
				mov eax, 0
			.endif
			mov [esi + eax * 4], ecx    ; Change index in maze to one 1 - > Black


			mov eax, PlayerX_FILL ; eax, end result eax / ebx
			mov ebx, 30
			sub edx, edx          ;set edx to zero
			div ebx				; calulate col ------> index / numberOfRows
			
;			add eax, 1

			imul eax, 30

			;mov PlayerX_FILL2, eax
			mov PlayerY_FILL2, eax


			mov eax, PlayerX_FILL ; eax, end result eax / ebx
			mov ebx, 30
			sub edx, edx          ;set edx to zero
			div ebx				; calulate row ------> index / numberOfRows
			
		
			;sun edx, 1
			imul edx, 30

			mov PlayerX_FILL2, edx

			.if (speed == -1)
				mov ecx, PlayerX_FILL
				add ecx, -1
			.elseif (speed == 1)
				mov ecx, PlayerX_FILL
				add ecx, 1
			.elseif (speed == 30)
				mov ecx, PlayerX_FILL
				add ecx, 30
			.elseif (speed == -30)
				mov ecx, PlayerX_FILL
				add ecx, -30
			.endif
			.if ecx < 0
				mov ecx, 0
			.endif
			mov eax, [esi + ecx * 4]
			.if(eax == 3) ||  eax == 2
				;invoke DoChangesInPainting, 1 
				;invoke FloodFill2
				
			.endif


			mov counter_Fill2, 0
				pop ecx
				dec ecx
			.endw
		.endif



		.if(counter_Fill2 >= 180)
			mov counter_Fill, 0
		.endif


       	invoke GetStockObject,  DC_BRUSH
		mov brushcolouring, eax
		invoke SelectObject, hdc,brushcolouring
	
		invoke SetDCBrushColor, hdc, 00000027ae60h
		mov yellow, eax

		

		xor ecx, ecx
		mov esi, offset maze
		
		L122:
			push ecx ; Push ecx to the stack
			push ecx

			mov eax, ecx ; eax, end result eax / ebx
			mov ebx, 30
			sub edx, edx          ;set edx to zero
			div ebx				; calulate row
			
			add eax, 1

			imul eax, 30
			push eax

			mov eax, ecx ; eax, end result eax / ebx
			mov ebx, 30
			sub edx, edx          ;set edx to zero
			div ebx
			mov ecx, edx

			
			imul ecx, 30

			pop eax
			sub eax, 30

			pop edx

			cmp ecx, 0
			jne con1

			mov ebx, 3 ; Blue
			mov [esi + edx * 4], ebx

			con1:
			cmp ecx, 870
			jne con2

			mov ebx, 3 ; Blue
			mov [esi + edx * 4], ebx

			con2:
			cmp eax, 0
			jne con3

			mov ebx, 3 ; Blue
			mov [esi + edx * 4], ebx

			con3:
			cmp eax, 540
			jne dntChange

			mov ebx, 3 ; Blue
			mov [esi + edx * 4], ebx
		
			dntChange:
		
			mov ebx, [esi + edx * 4]    ; Check if state one
			cmp ebx, 1
			je drawGreen
			mov ebx, [esi + edx * 4]    ; Check if state one
			cmp ebx, 3
			je drawBlue

			mov ebx, [esi + edx * 4]    ; Check if state one
			cmp ebx, 2
			je drawBlue

			mov ebx, [esi + edx * 4]    ; Check if state one
			cmp ebx, 4
			je drawRed
			

			push eax
			push ecx
			push edx
			invoke SetDCBrushColor, hdc, 000000ffffffh
			mov brushcolouring, eax
			pop edx
			pop ecx
			pop eax

			
			invoke BUILDRECT, ecx , eax ,  28,  28,     hdc,  brushcolouring
			jmp enddraw

			drawBlue:
			
			push eax
			push ecx
			push edx
			invoke SetDCBrushColor, hdc, 000000f00000h
			mov brushcolouring, eax
			pop edx
			pop ecx
			pop eax

			invoke BUILDRECT, ecx , eax ,  28,  28,     hdc,  brushcolouring
			JMP enddraw

			drawGreen:

			push eax
			push ecx
			push edx
			invoke SetDCBrushColor, hdc, 0000000f0000h
			mov brushcolouring, eax
			pop edx
			pop ecx
			pop eax

			
			invoke BUILDRECT, ecx , eax ,  28,  28,     hdc,  brushcolouring

			drawRed:

			push eax
			push ecx
			push edx
			invoke SetDCBrushColor, hdc, 000000000f00h
			mov brushcolouring, eax
			pop edx
			pop ecx
			pop eax

			
			invoke BUILDRECT, ecx , eax ,  28,  28,     hdc,  brushcolouring

		
		


			enddraw:
			pop ecx
			add ecx, 1
			cmp ecx, LENGTHOF maze
			jne L122

	

			invoke BUILDRECT, PlayerX_FILL2 , PlayerY_FILL2 ,  28,  28,     hdc,  3

	invoke EndOfBaseLevel, hdc, hWnd

	ret
Bonus ENDP

Jump PROC
	
	cmp flag, 0 ; The player can only jump one time, So cmp this flag to check if he can jump again
	jnz @D
	.if flag2 == 0
		mov eax, 1
	.endif
	cmp eax, 0
	jne jump
		    
    jmp endmovement
	
	
	movedown:

		mov speed, 30

		mov eax, PlayerY
		add eax, VEL_Y
		mov PlayerY, eax      
		jmp endmovement
	jump:
		mov flag, 1
		mov velocityY, -20
		jmp endmovement
	
	@D:
		invoke GetAsyncKeyState, VK_UP
		cmp eax, 0
		jNz endddd
		mov flag, 0
 endddd:

endmovement:
 

	ret
Jump ENDP

EndOfBaseLevel PROC, hdc:HDC, hWnd:HWND
	
	
	mov eax, PlayerY
	add eax, 28
	invoke GetPixel, hdc, PlayerX, eax
	cmp eax, 00333331h 
	jne collideEnd
	start:
		;mov eax, velocityY
		;imul eax, -1
		;mov velocityY, eax
		mov velocityY, 0
		;mov PlayerY
		mov eax, PlayerX
		add eax, 10
		invoke GetPixel, hdc, eax, PlayerY
		cmp eax, 00333331h 
		
		jne enddd
		mov eax, PlayerX
		mov bl, direction
		.if bl == 0
			add eax, 10
		.elseif
			sub eax, 10
		.endif
		mov PlayerX, eax
	;	mov VEL_X, 0
		jmp end2
		enddd:
;		mov VEL_X, 3
		end2:
		
		mov flag2, 0
		jmp endfg
	collideEnd:
		add PlayerY, GRAVITY
		mov flag2, 1
	endfg:

	mov eax, PlayerY
	add eax, 28
	invoke GetPixel, hdc, PlayerX, eax
	;0000ffffh
	cmp eax, 0000ffffh 
	jne collideEnd2

	add score, 10

	collideEnd2:

	invoke DrawLaba, hdc

	invoke GetAsyncKeyState, VK_SPACE
    cmp eax, 0
	je endf

	shoot:
		
		
		.if canShoot == 1 || onSockets == 0
 		mov eax, WINDOW_WIDTH

		
		.if BulletX2 > eax
			mov eax, PlayerX
			mov BulletX2, eax
			mov eax, PlayerY
			mov BulletY, eax
		.endif
		.endif
	endf:



	; Current Score
	invoke crt__itoa, score, addr scoreText + 7, 10 ; Convert integer to string
	invoke crt_strlen, addr scoreText ;Get the length of the scoreText string
	invoke TextOutA, hdc, 10, 40, addr scoreText, eax ;Print the score

	; High Score
	invoke crt__itoa, bestScore, addr highScoreText + 12, 10 ; Convert integer to string
	invoke crt_strlen, addr highScoreText ;Get the length of the scoreText string
	invoke TextOutA, hdc, WINDOW_WIDTH - 140, 10, addr highScoreText, eax ;Print the score


	; Current Score
	invoke crt__itoa, level, offset levelText + 7, 10 ; Convert integer to string
	invoke crt_strlen, addr levelText ;Get the length of the scoreText string
	invoke TextOutA, hdc, 10, 10, addr levelText, eax ;Print the score
	ret
EndOfBaseLevel ENDP

BaseLevel PROC, brushcolouring:HBRUSH, brushcolouring2:HBRUSH,  hdc:HDC, hWnd:HWND
	
	; DrawImage2 PROC, hdc:HDC, img:HBITMAP, x:DWORD, y:DWORD, width:DWORD, height:DWORD, widthSrc:DWORD, heightSrc:DWORD
	invoke DrawImage2, hdc, Hbackground, 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT, 1000, 500
	invoke GetStockObject,  DC_BRUSH
	mov brushcolouring, eax
	invoke SelectObject, hdc,brushcolouring
	invoke SetDCBrushColor, hdc,    000000FFFFFFh
	mov brushcolouring, eax

	; Draw the main player of the game, with animation
	invoke DrawPerson, PlayerX, PlayerY, hdc, animationCounter, direction

	.if level != 100	; if level is not bonus level
	; Store playes lives
	mov ecx, lives
	mov eax, 100
	cmp ecx, 0 
	jge continue

	asmIsAwsome:
		invoke Restart
		jmp continueW
	continue:
		
		.while (ecx)    ; Loop through lives
			push ecx
			push eax
			invoke DrawPerson, eax, 50, hdc, 1, 1
			pop eax
			pop ecx
			dec ecx
			add eax, 60
		.endw

	continueW:

	mov ebx, BulletVelo_X
 	add BulletX2, 5
	mov ecx, BulletVelo_Y
	sub BulletY, ecx
	
	invoke DrawPlayerBullet, BulletX2, BulletY, hdc

	mov ecx, PlayerX
	.if ecx >= WINDOW_WIDTH
		inc level
		mov index, 100
		mov PlayerX, 10
		mov EnemyX, 100
		mov numberEnemies, 1900
		.if level == 2
		mov numberEnemies, 3
		.endif
	.elseif ecx <= 10
	mov index, 100
		dec level
		mov numberEnemies, 1900
		mov EnemyX, 100
		mov PlayerX, WINDOW_WIDTH - 10
	.endif

	; GameUpdate
			
	cmp flag2, 0
	je conti
	add velocityY, 1
	conti:

	cmp velocityY, 20
	jng lavale
			
	laval:
		mov velocityY, 20
	lavale:

	.if toUpdate == 0

	mov ebx, velocityY
	add PlayerY, ebx

	.endif

	.if PlayerY >= WINDOW_HEIGHT - 30		; If the player fall down
		mov PlayerY, 100
		mov PlayerX, 100
		dec lives
	.ENDIF
	
	endd:


	.if score == 80
		invoke MessageBox, hWnd, addr scoreText, addr scoreText, MB_OK
		mov level, 100
	
		inc score
	.endif
	.endif
	.if onSockets == 1
	.if directionSockets == 4
		mov speed, -1
		
		mov direction, 0

		mov eax, VEL_X
		
		mov eax, PlayerX
		mov ebx, VEL_X
		imul ebx, 3
		sub eax, ebx
		mov PlayerX,    eax
	.endif

	.if directionSockets == 5 
		mov canShoot, 1
		invoke keybd_event, VK_SPACE, 0, KEYEVENTF_EXTENDEDKEY, 0
	.elseif
		mov canShoot, 0
	.endif


	.if directionSockets == 11


		invoke keybd_event, VK_UP, 0, KEYEVENTF_EXTENDEDKEY, 0
		mov flag, 0

		mov speed, -1
		
		mov direction, 0

		mov eax, VEL_X
		
		mov eax, PlayerX
		mov ebx, VEL_X
		imul ebx, 3
		sub eax, ebx
		mov PlayerX,    eax
	.elseif
		mov flag, 1
	.endif


	.if directionSockets == 6
		;VK_UP
		
		invoke keybd_event, VK_UP, 0, KEYEVENTF_EXTENDEDKEY, 0
		mov flag, 0
	;	invoke Jump
	.elseif directionSockets != 11
		mov flag, 1
	.endif

	.if directionSockets == 16

	invoke keybd_event, VK_UP, 0, KEYEVENTF_EXTENDEDKEY, 0
		mov flag, 0

		
		mov speed, 1

		mov direction, 1
		
		mov ebx, VEL_X
		imul ebx, 3
        mov eax, PlayerX
        add eax, ebx
        mov PlayerX, eax  
	.elseif directionSockets != 6
		mov flag, 1
	.endif


	.if directionSockets == 9
		mov speed, 1

		mov direction, 1
		
		mov ebx, VEL_X
		imul ebx, 3
        mov eax, PlayerX
        add eax, ebx
        mov PlayerX, eax  
		 
	.endif
	.endif
	ret
BaseLevel ENDP



; ******************************* Window Functions ******************************

ProjectWndProc  PROC,   hWnd:HWND, message:UINT, wParam:WPARAM, lParam:LPARAM
    local paint:PAINTSTRUCT	
    local hdc:HDC
    local brushcolouring:HBRUSH
	local brushcolouring2:HBRUSH
	local pixelcolor:COLORREF 
 
		
	
 
    cmp message, WM_PAINT
    je painting
    cmp message, WM_CLOSE
    je closing
    cmp message, WM_TIMER
    je timing
	.if level == 0
	cmp message, WM_MOUSEMOVE
	
	je doMouseMove
	.ENDIF
    jmp OtherInstances
	
closing:
	
	mov eax, score
	cmp eax, bestScore
	jle endSave

	invoke crt__itoa, score, addr scoreText + 6, 10 ; Convert integer to string

    mov     edx, eax    

	;create the file

        push    edx
        INVOKE  CreateFile,offset fileName,GENERIC_WRITE,FILE_SHARE_READ,
                NULL,CREATE_ALWAYS,FILE_ATTRIBUTE_NORMAL,NULL
        mov     hFile,eax
        pop     edx

;write the file

    INVOKE  WriteFile,eax,edx,8,offset nBytes,NULL

;close the file

    INVOKE  CloseHandle,hFile

	endSave:
	invoke ExitProcess, 0
	
	doMouseMove:
		mov eax, lParam
		;shr eax, 15
		mov mouseX, ax
		shr eax, 16
		mov mouseY, eax

	;ret

painting:

	invoke  BeginPaint, hWnd, addr paint
	mov hdc, eax
	

	;invoke BaseLevel, brushcolouring, brushcolouring2,  hdc, hWnd


	cmp level, 0
	je level0
	cmp level, 1
	je level1
	cmp level, 2
	je level2
	cmp level, 3
	je level3
	cmp level, 4
	je level4
	cmp level, 100
	je bonus
	cmp level, 101
	je options

	
	level0:
		invoke MainMenu, hdc
		jmp levelEnd
	options:
		invoke Options, hdc
		jmp levelEnd
	
	level1:
		invoke BaseLevel, brushcolouring, brushcolouring2,  hdc, hWnd
		invoke Level1, hdc, brushcolouring, hWnd
		jmp levelEnd

	level2:
	;inc level
		invoke BaseLevel, brushcolouring, brushcolouring2,  hdc, hWnd
		invoke Level2, hdc, brushcolouring, hWnd
		jmp levelEnd
	level3:
		invoke BaseLevel, brushcolouring, brushcolouring2,  hdc, hWnd
		invoke Level3, hdc, brushcolouring, hWnd
		jmp levelEnd
	level4:
		invoke BaseLevel, brushcolouring, brushcolouring2,  hdc, hWnd
		invoke Level4, hdc, brushcolouring, hWnd
		jmp levelEnd
	bonus:
		invoke Bonus, hdc, brushcolouring, hWnd
		jmp levelEnd

	levelEnd:



	; End game painting
	invoke EndPaint, hWnd,  addr paint

			
        ret
 
 
timing:
		; GetAsyncKeyState changes the eax value if pressed
    invoke GetAsyncKeyState, VK_LEFT
    cmp eax, 0
    jne moveleft
    invoke GetAsyncKeyState, VK_RIGHT
    cmp eax, 0
    jne moveright
	invoke GetAsyncKeyState, VK_UP
    cmp eax, 0
    jne moveup
	
		invoke GetAsyncKeyState, VK_TAB
		.if eax == 0
			mov flag3, 1
		.else
			mov flag3, 0
			jmp pausee
		.endif
		
	

	.if toUpdate == 1
		invoke GetAsyncKeyState, VK_TAB
		.if eax == 0
			
		.else
			.if flag3 == 1
				jmp pausee
			.endif
		.endif
		
		mov flag3, 0
	.endif

    checkupdown:
    invoke GetAsyncKeyState, VK_DOWN
    cmp eax, 0
    jne movedown

	
	

	cmp flag, 0 ; The player can only jump one time, So cmp this flag to check if he can jump again
	jnz @D
	.if flag2 == 0
		invoke GetAsyncKeyState, VK_UP
	.endif
	cmp eax, 0
	jne jump
		    
    jmp endmovement
	moveleft:

		mov speed, -1
		
		mov direction, 0

	;	mov eax, VEL_X
	;	
 ;       mov eax, PlayerX
;        sub eax, VEL_X

		sub PlayerX, 9
        ;mov PlayerX,    eax
		
        jmp checkupdown
	moveright:
		

		mov speed, 1

		mov direction, 1
		
	;	mov eax, VEL_X
		
       ; mov eax, PlayerX
    ;    add eax, VEL_X
        ADD PlayerX, 9  
		 
        jmp checkupdown

	moveup:
		mov speed, -30
		jmp checkupdown
	pausee:
		.if toUpdate == 0
		
			mov toUpdate, 1
			
		.else
		mov flag3, 1
			mov toUpdate, 0
			
		.endif
		jmp checkupdown
	movedown:

		mov speed, 30

		mov eax, PlayerY
		add eax, VEL_Y
		mov PlayerY, eax      
		jmp endmovement
	jump:
		mov flag, 1
		mov velocityY, -20
		jmp endmovement
	
	@D:
		invoke GetAsyncKeyState, VK_UP
		cmp eax, 0
		jNz endddd
		mov flag, 0
 endddd:

endmovement:
		
        invoke InvalidateRect, hWnd, NULL, TRUE
        ret
OtherInstances:
        invoke DefWindowProc, hWnd, message, wParam, lParam
        ret
ProjectWndProc  ENDP
 
; Player frames transfer (from timer)
TranferFrames PROC
	mov eax, animationCounter
	.if eax == 1
		mov animationCounter, 2
	.elseif
		mov animationCounter, 1
	.endif
	ret
TranferFrames ENDP

; Spikes frames transfer (from timer)
TranferFrames2 PROC
	mov eax, animationCounterSpikes
	.if eax == 1
		mov animationCounterSpikes, 2
	.elseif eax == 2
		mov animationCounterSpikes, 3
	.else
		mov animationCounterSpikes, 1
	.endif
	ret
TranferFrames2 ENDP


createSocket PROC
	ladbel:
	; Sockets
	  invoke WSAStartup, 101h, addr wsaData
        cmp eax, eax
        jz connect_to_server
        
     ;   xor eax, eax ; set eax to 0
      ;  invoke ExitProcess, eax; ExitProcess(0)

        connected_to_server:
            ;invoke MessageBox, NULL, addr szConnected, addr szConnected, NULL
            
            invoke Send_Ident
            
			invoke ReceiveData
			;invoke  CreateThread, NULL, NULL, addr ReceiveData, 1, NULL, NULL

            
            invoke closesocket, hClient

            jmp connect_to_server
        connect_to_server:
               ; invoke MessageBox, NULL, addr szRemoteHost, addr szRemoteHost, NULL
                invoke socket, AF_INET, SOCK_STREAM, IPPROTO_TCP ;create socket
                cmp eax, SOCKET_ERROR ; check if created successfully
                je connect_to_server; Failed. Try again
                mov hClient, eax
                invoke ConnectToServer
                cmp eax, 0
                je connected_to_server
                invoke closesocket, hClient
                jmp connect_to_server

				jmp ladbel
	ret
createSocket ENDP



main PROC
	LOCAL wndcls:WNDCLASSA ; Class struct for the window	
	LOCAL hWnd:HWND ;Handle to the window
	LOCAL msg:MSG


	invoke MessageBox, hWnd, addr connectPhoneText2, addr connectPhoneText, IDABORT

	.if eax == IDYES
		invoke  CreateThread, NULL, 0, addr createSocket, 0, 0, addr ThreadID
		mov onSockets, 1
	.else
		mov onSockets, 0
	.endif

;	invoke createSocket

	; Load images to variables
	invoke GetModuleHandle, NULL
	invoke LoadBitmap, eax, 101   
	mov Hbackground, eax 

	invoke GetModuleHandle, NULL
	invoke LoadBitmap, eax, 102  
	mov Mbackground, eax 

	invoke GetModuleHandle, NULL
	invoke LoadBitmap, eax, 103
	mov PlayButton, eax 

	invoke GetModuleHandle, NULL
	invoke LoadBitmap, eax, 104
	mov PlayText, eax 

	invoke GetModuleHandle, NULL
	invoke LoadBitmap, eax, 105
	mov OptionText, eax 

	invoke GetModuleHandle, NULL
	invoke LoadBitmap, eax, 106
	mov OptionButton, eax 

	invoke GetModuleHandle, NULL
	invoke LoadBitmap, eax, 107
	mov ExitText, eax 

	invoke GetModuleHandle, NULL
	invoke LoadBitmap, eax, 108
	mov ExitButton, eax 

	invoke GetModuleHandle, NULL
	invoke LoadBitmap, eax, 109
	mov Rocket, eax 
	

	mov level, 0
	invoke RtlZeroMemory, addr wndcls, SIZEOF wndcls ;Empty the window class
	mov eax, offset ClassName
	mov wndcls.lpszClassName, eax ;Set the class name

	invoke GetStockObject,  DC_BRUSH
	    
	mov wndcls.hbrBackground, (HBRUSH)(10) ;Set the background color as black   3, 
	
	mov eax, ProjectWndProc
	mov wndcls.lpfnWndProc, eax ;Set the procedure that handles the window messages
	invoke RegisterClassA, addr wndcls ;Register the class
	invoke CreateWindowExA, WS_EX_COMPOSITED, addr ClassName, addr windowTitle, WS_SYSMENU, 100, 100, WINDOW_WIDTH, WINDOW_HEIGHT, 0, 0, 0, 0 ;Create the window
	mov hWnd, eax ;Save the handle
	invoke ShowWindow, eax, SW_SHOW ;Show it
	invoke SetTimer, hWnd, MAIN_TIMER_ID, 22, NULL ;Set the repaint timer
	invoke SetTimer, hWnd, FRAMES_TIMER_ID, 500, TranferFrames
	invoke SetTimer, hWnd, SPIKES_TIMER_ID, 2000, TranferFrames2



	 invoke  CreateFile,ADDR fileName,GENERIC_READ,0,0,\
            OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,0            

    mov     hFile,eax

    invoke  GetFileSize,eax,0

    mov     FileSize,eax
    inc     eax

    invoke  GlobalAlloc,GMEM_FIXED,eax
    mov     hMem,eax

    add     eax,FileSize

    mov     BYTE PTR [eax],0   ; Set the last byte to NULL so that StdOut
                               ; can safely display the text in memory.

    invoke  ReadFile,hFile, hMem,FileSize - 1,ADDR BytesRead,0
	;invoke MessageBox, NULL, hMem, addr fileName, 0

	invoke crt_atoi, hMem, 10 ; String to int

	mov bestScore, eax

;	mov eax, ADDR hMem

;	;mov score, eax
	


    invoke  CloseHandle,hFile

	
    invoke  StdOut,hMem
	;mov score, eax

    invoke  GlobalFree,hMem

   ; invoke  ExitProcess,0



	;animationCounterSpikes
	msgLoop:
		; PeekMessage
		invoke GetMessage, addr msg, hWnd, 0, 0 ;Retrieve the messages from the window
		mov eax, 55
		invoke DispatchMessage, addr msg ;Dispatches a message to the window procedure
		jmp msgLoop
		invoke ExitProcess, 1
main ENDP
end main


; If in the future I will want the bullet to attack ALLwAYES the alian, this is the code
;		mov eax, PlayerY
;		mov ebx, EnemyY
;		.if eax > ebx
;			mov eax, PlayerY ; eax, end result eax / ebx
;			sub eax, EnemyY
;			mov ebx, 40
;			sub edx, edx          ;set edx to zero
;			div ebx
;			mov BulletVelo_Y, eax
;		.elseif
;			mov eax, EnemyY  ; eax, end result eax / ebx
;			sub eax, PlayerY
;			mov ebx, 40
;			sub edx, edx          ;set edx to zero
;			div ebx
;			neg eax
;			mov BulletVelo_Y, eax
;		.endif
;
;		mov ecx, VEL_X_ENEMY
;		imul ecx, 0
;
;		mov eax, EnemyX    ; eax, end result eax / ebx
;		add eax, ecx
;		sub eax, PlayerX
;		mov ebx, 40
;		sub edx, edx          ;set edx to zero
;		div ebx
;
;
;		mov score, eax

;		mov BulletVelo_X, eaxf