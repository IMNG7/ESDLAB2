;Timer 1 and Timer 2 are utilized here for
; counting up till 65535 and overflowing 
; for delay
	org 0000h
	SJMP MAIN
ISR:		;Interrupt Service Routine for Toggling
	org 000Bh
	SETB p1.2			;Setting pint 1.2 for ISR Measurement
	cpl p1.1			;Toggling pin 1.1
	clr p1.2			;Setting pint 1.2 for ISR Measurement
	RETI
MAIN:				
	mov A,#07			; Keeping it 7 for running it 7 times
	mov TMOD,#10h	; Setting timer 1 in 16-bit Mode
	mov IE,#82h
DELAY:	
	mov TL1,#0A0h	; Moving A0 to lower bit
	dec A
	mov TH1,#015h	; Moving 15 to Higher bit for getting
							;required delay with timerl=5536
	SETB TR1	;Starting Timer 1
LOOP: 
	JNB TF1,LOOP	; Checking till timer overglows and tf sets itself
	CLR TR1		
	CLR TF1		;Clear Timer 1 flags
	JNZ DELAY
	mov TMOD,#01h	;; Setting timer 0 in 16-bit Mode
	mov TL0,#00D7h
	mov TH0,#5Fh
	SETB TR0
LOOP2: 
	JNB TF0,LOOP2
	CLR TR0		;Clear Timer 0 flags
	CLR TF0		;;required delay with timerl=24535
	SJMP MAIN
