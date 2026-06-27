	;INCLUDE C:\ti\TivaWare_C_Series-2.1.4.178\examples\boards\my_board\startup_TM4C123.s

	AREA |.text|, CODE, READONLY
	;THUMB
	EXPORT __main
	ENTRY
	
__main

	;defining addresses here for practice

	;general base addresses
SYS_CONTROL	EQU 0x400FE000
AHB_PORTB	EQU 0x40059000
	
	;offsets
GPIOHBCTL 	EQU 0x06C
RCGCGPIO	EQU	0x608
GPIODIR		EQU	0x400
GPIOAFSEL	EQU	0x420
GPIODR2R	EQU	0x500
GPIODR4R	EQU 0x504
GPIODR8R	EQU 0x508
GPIOPUR		EQU	0x510
GPIOODR		EQU 0x50C
GPIODEN		EQU	0x51C
GPIODATAPB5	EQU	0x3FC;0X080
	
	
	;Note that GPIO can only be accessed through the AHB aperture
	;select AHB bus. GPIOHBCTL
	LDR r0, =SYS_CONTROL
	LDR r1,[r0, #GPIOHBCTL]
	ORR r1, r1, #(1<<1) ;Enable port B AHB instead.
	;BFC r1,#0,#6 ;use APB when 0
	;AND r1, r1, 0x0000.0000 ;use APB when 0
	STR r1,[r0, #GPIOHBCTL] 
	
	;Enable clock to GPIO port B. RCGCGPIO
	LDR r0, =SYS_CONTROL 
	LDR r1,[r0,#RCGCGPIO]
	ORR r1, r1, #(1<<1) ;enable port B clock(bit 5)
	STR r1,[r0,#RCGCGPIO]
	
	;set GPIO Port B pin 5 to output. GPIODIR
	LDR r0, =AHB_PORTB
	LDR r1,[r0,#GPIODIR]
	ORR r1, r1, #(1<<5);pin5
	STR r1,[r0,#GPIODIR]
	
	;Set GPIO mode to I/O (not alternate function). GPIOAFSEL
	LDR r0, =AHB_PORTB
	LDR r1,[r0,#GPIOAFSEL]
	BFC r1,#0,#8 ;clears fields. 0 = GPIO
	;AND r1, r1, 0x0000.0000 ;0 = GPIO
	STR r1,[r0,#GPIOAFSEL]
	
	;Set drive strength to 8mA. GPIODR8R
	LDR r0, =AHB_PORTB
	LDR r1,[r0,#GPIODR8R]
	ORR r1, r1, #(1<<5);pin5
	STR r1,[r0,#GPIODR8R]
	
	;Set tooutput. No pull up. Must be push/pull or open drain
	;set to pull up. GPIOPUR
	LDR r0, =AHB_PORTB
	LDR r1,[r0,#GPIOODR]
	ORR r1, r1, #(1<<5) ;pin5
	STR r1,[r0,#GPIOODR]

	;enable digital output. GPIODEN
	LDR r0, =AHB_PORTB
	LDR r1,[r0,#GPIODEN]
	ORR r1,r1, #(1<<5);pin 1 = digital output enable
	STR r1,[r0,#GPIODEN]
	
	;power pin PB5 to light up external LED
	;Write "high" to data register. GPIODATA
	LDR r0, =AHB_PORTB
	LDR r1,[r0,#GPIODATAPB5]
	MOV r1, #0xF0
	STR r1,[r0,#GPIODATAPB5]
	LDR r1,[r0,#GPIODATAPB5]
	
; Infinite loop. Equivalent to while();. Prevents program from stopping immediately
stop B stop	
	
	END