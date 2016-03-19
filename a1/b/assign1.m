/*
!Create a SPARC assembly_r language program that finds the min_rimum of  y_r = 5x^3+27x^2-27x-43 in 
!the range -6 <= x <= 6, by  stepping through the range one by one in a loop and testing. 
!Use only_r integers for x_r, and do not factor the ex_rpression. 
!Use the printf() function to display_r to the screen the values of x_r, y_r and 
/* the current min_rimum on each iteration of y_rour loop. Also, */
/* put the value for the min_rimum into register %l0 at the end of y_rour program. */


fmt1:   .asciz          "X: %d"
fmt2:   .asciz          " Y: %d"
fmt3:   .asciz          " MIN: %d\n"
		.align 4
/*marcos */
define(x1, -27)		
define(x2, 27)	
define(x3, 5)

define(c, -6)		
define(x, -7)		

define(min, l0)		
define(x_r, l1)		
define(y_r, l2)

	.global main
main:
	save %sp, -96, %sp
	ba start		!branch always to start
	mov	x, %x_r		!mov -7 to x
	clr	%y_r		!clear y register

check:
	mov	-43, %y_r	!mov -43 to y register

	mov	%x_r, %o0	!mov x to %o0
	call .mul		!x*x=x^2
	mov	%x_r, %o1	!mov x to %o1
	mov	%o0, %l3	!mov %o0 to %l3
	call .mul		!27*x^2
	mov	x2, %o1		!mov x2 to %o1
	add	%o0, %y_r, %y_r	!%o0+y
	
	mov	%l3, %o0	!mov %l3 to %o0
	call .mul		!
	mov	%x_r, %o1	!mov x value into %o1
	call .mul		! 5x^3
	mov	x3, %o1		!mov 5 to %o1
	add	%o0, %y_r, %y_r	!5x^3+27^2-43
	
	mov	x1, %o0		!mov -27 to %o0
	call .mul		!-27x
	mov	%x_r, %o1	!mov x_r to %o1
	add	%o0, %y_r, %y_r	!5x^3+27^2+27x-43

	bge	loop	
	nop
	mov c, %o0      !mov -6 to check the lower bound
	mov	%y_r, %min	!mov y to min
	
loop:
	cmp	%y_r, %min	!comparing
	bge	print		!if is greater or equal to branch and print
	nop
	mov	%y_r, %min	

print:
	set	fmt1, %o0	!setting string for printing...
	call printf		!printing...
	mov	%x_r, %o1	!printing x....

	set	fmt2, %o0	!setting string for printing...
	call printf		!printing...
	mov	%y_r, %o1	!printing y..

	set	fmt3, %o0	!setting string for printing...
	call printf		!printing...
	mov	%min, %o1	!printing min ...

start:
	cmp %x_r, 6        
	bl	check		!
	add %x_r, 1, %x_r 

mov	1, %g1			
ta	0
