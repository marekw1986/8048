; First test program for 8048/8049
; Uses delay loop to blink LED

.org 0x0

; Reset vector: jump to the main loop
reset:
	jmp entry
	
.org 0x10

; Main loop
entry:
	mov A, #255
	outl P1, A
	call delay
	mov A, #0
	outl P1, A
	call delay
	jmp entry

delay:
	mov R0, #255
delay_outer:
	mov R1, #255
delay_inner:
	nop
	nop
	nop
	nop
	djnz R1, delay_inner
	djnz R0, delay_outer
	ret
