; Test program for 8048/8049
; Uses timer to blink LED

; Register usage
; R0 - unused
; R1 - unused
; R2 - text pointer
; R3 - general purpose
; R4 - timer cycle count
; R5 - previous state of switches
; R6 - general purpose
; R7 - unused

.equ cycle_count, 60

; Flag 1 is used as timer flag

.org 0x0

; Reset vector: jump to the main loop
reset:
	jmp entry
	
.org 0x07
	jmp timer_event
	
.org 0x10

; Initialize
entry:
	mov R2, #0x00				; We use R2 as text pointer
	mov R4, #cycle_count
	mov A, #0xFF
	outl P1, A
	mov A, #0xF0				; Set P2.4..7 as inputs
	outl P2, A					; Set P2.4..7 as inputs
	strt t
	en tcnti
; Main loop
main_loop:
	jf1 main_loop
	in A, P2					; Read PORT2
	swap A						; Swap nibbles
	anl A, #0x03				; Mask out everything except bits 0 and 1
	; Compare with previous state of imput switches
	mov R3, A					; Save initial value of accumulator - it will be changed during comparison
	xrl A, R5					; Compare with previous state
	jz main_check_clk			; It is identical as before - just continue
	mov A, R3					; Retrieve original value
	mov R5, A					; Save original value in R5
	mov R2, #0x00				; Zero out text pointer
	mov A, #0xFF				; Turn off LEDS
	outl P1, A
	mov R4, #cycle_count		; Reset cycle count
	jmp main_end				; After input changed we do nothing initially
main_check_clk:
	in A, P1					; Read current LED port value
	mov R6, A					; Save it in R6
	anl A, #0x80				; Check value of most significant bit
	jnz main_check_input_0		; It is NOT zero, so proceed with updating value
	mov A, R6					; Otherwise just SET clock bit
	orl A, #0x80
	mov @R0, A					; Save modified value
	outl P1, A					; Update LEDs
	jmp main_end				; We do nothing in this cycle after that
main_check_input_0:
	; Check new status
	mov A, R3					; Retrieve initial value of A
	xrl A, #0x00				; Exclusive or - it will produce 0x00 if the same
	jnz main_check_input_1
	call get_text_1
	jmp main_outchar
main_check_input_1:
	mov A, R3					; Retrieve initial value
	xrl A, #0x01
	jnz main_check_input_2
	call get_text_1
	jmp main_outchar
main_check_input_2:
	mov A, R3
	xrl A, #0x02
	jnz main_check_input_3
	call get_text_1
	jmp main_outchar
main_check_input_3:
	mov A, R3
	xrl A, #0x03
	;jz main_blink
	call get_text_4
	; Save status
main_outchar:
	; We already have character in A
	xrl A, #0xFF				; Negate it bitwise
	anl A, #0x7F				; CLEAR most significant bit
	outl P1, A
main_end:
	cpl F1
	jmp main_loop
	
timer_event:
	djnz R4, timer_event_done
	mov R4, #cycle_count
	clr F1
timer_event_done:
	retr
	
.org 0x400
get_text_1:
	mov A, text_1-get_text_1	; Calculate beginning of text
	add A, R2					; Calculate shift
	movp A, @A					; Get character
	inc R2						; Increment R2
	jnz get_text_1_ret			; A is non zero - just return
	mov R2, #0x00				; A is zero - go to beginning
get_text_1_ret:
	ret
text_1:
	.include "text1.asm"
	.db 0x00

.org 0x500
get_text_2:
	mov A, text_2-get_text_2	; Calculate beginning of text
	add A, R2					; Calculate shift
	movp A, @A					; Get character
	inc R2						; Increment R2
	jnz get_text_2_ret			; A is non zero - just return
	mov R2, #0x00				; A is zero - go to beginning
get_text_2_ret:
	ret
text_2:
	.include "text4.asm"
	.db 0x00

.org 0x600
get_text_3:
	mov A, text_3-get_text_3	; Calculate beginning of text
	add A, R2					; Calculate shift
	movp A, @A					; Get character
	inc R2						; Increment R2
	jnz get_text_3_ret			; A is non zero - just return
	mov R2, #0x00				; A is zero - go to beginning
get_text_3_ret:
	ret
text_3:
	.include "text3.asm"
	.db 0x00

.org 0x700
get_text_4:
	mov A, text_4-get_text_4	; Calculate beginning of text
	add A, R2					; Calculate shift
	movp A, @A					; Get character
	inc R2						; Increment R2
	jnz get_text_4_ret			; It is non zero - just return
	mov R2, #0x00				; It is zero - go to beginning
get_text_4_ret:
	ret
text_4:
	.include "text4.asm"
	.db 0x00
