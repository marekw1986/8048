; Test program for 8048/8049
; Uses timer to blink LED

.equ cycle_count, 120

; Timer flag is stored at data memory location 32
.equ timer_flag, 32
; Timer flag is stored at data memory location 33
.equ port_value, 33

.org 0x0

; Reset vector: jump to the main loop
reset:
	jmp entry
	
.org 0x07
	jmp timer_event
	
.org 0x10

; Initialize
entry:
	mov R1, #timer_flag
	mov @R1, #0x00
	mov R1, #port_value
	mov @R1, #0xFF
	mov R4, #cycle_count
	strt t
	en tcnti

	mov A, #0xF0	; Set P2.4..7 as inputs
	outl P2, A		; Set P2.4..7 as inputs
; Main loop
main_loop:
	mov R1, #timer_flag
	mov A, @R1
	xrl A, #0xFF
	jnz main_loop
	in A, P2		; Read PORT2
	swap A			; Swap nibbles
	anl A, #0x03	; Mask out everything except bits 0 and 1
	; Compare with previous state of imput switches
	; TODO
	; Check new status
	mov R3, A			; Save initial value of accumulator - it will be changed
	xrl A, #0x00		; Exclusive or - it will produce 0x00 if the same
	jz main_loop
	mov A, R3			; Retrieve initial value
	xrl A, #0x01
	jz main_loop
	mov A, R3
	xrl A, #0x02
	jz main_loop
	mov A, R3
	xrl A, #0x03
	;jz main_blink
	; Save status
main_blink:
	mov R1, #port_value
	mov A, @R1
	xrl A, #0xFF
	outl P1, A
	mov @R1, A
	mov R1, #timer_flag
	mov @R1, #0x00
	jmp main_loop
	
timer_event:
	djnz R4, timer_event_done
	mov R4, #cycle_count
	mov R0, #timer_flag
	mov @R0, #0xFF
timer_event_done:
	retr

.org 0x600
	.db 84,119,111,32,114,111,97,100,115,32,100,105,118,101,114,103,101,100,32,105,110,32,97,32,121,101,108,108,111,119,32,119,111,111,100,32,65,110,100,32,115,111,114,114,121,32,73,32,99,111,117,108,100,32,110,111,116,32,116,114,97,118,101,108,32,98,111,116,104,32,65,110,100,32,98,101,32,111,110,101,32,116,114,97,118,101,108,101,114,44,32,108,111,110,103,32,73,32,115,116,111,111,100,32,65,110,100,32,108,111,111,107,101,100,32,100,111,119,110,32,111,110,101,32,97,115,32,102,97,114,32,97,115,32,73,32,99,111,117,108,100,32,84,111,32,119,104,101,114,101,32,105,116,32,98,101,110,116,32,105,110,32,116,104,101,32,117,110,100,101,114,103,114,111,119,116,104
	.db 0x00

.org 0x700
	.db 0x54, 0x65, 0x73, 0x74, 0x6F, 0x77, 0x79, 0x20, 0x74, 0x65, 0x6B, 0x73, 0x74
	.db 0x00
