/*
!Create a SPARC assembly_r language program that finds the min_rimum of  y_r = 5x^3+27x^2-27x-43 in 
!the range -6 <= x <= 6, by  stepping through the range one by one in a loop and testing. 
!Use only_r integers for x_r, and do not factor the ex_rpression. 
!Use the printf() function to display_r to the screen the values of x_r, y_r and 
/* the current min_rimum on each iteration of y_rour loop. Also, */
/* put the value for the min_rimum into register %l0 at the end of y_rour program. */


fmt1: .asciz "X: %d"
fmt2: .asciz " Y: %d"
fmt3: .asciz " MIN: %d\n"
	.align 4

	.global main
main:
	save %sp, -96, %sp
	mov	-7, %l1		!mov -7 to -7
	ba start		!branch always to start
	nop
	clr	%l2		!clear y register

check:
	mov	-43, %l2	!mov -43 to y register

	mov	%l1, %o0	!mov -7 to %o0
	mov	%l1, %o1	!mov -7 to %o1
	call .mul		!-7*-7=-7^2
	nop
	
	mov	%o0, %l3	!mov %o0 to %l3
	mov	27, %o1		!mov 27 to %o1
	call .mul		!27*-7^2
	nop
	add	%o0, %l2, %l2	!%o0+y
	mov	%l3, %o0	!mov %l3 to %o0
	call .mul		!
	nop
	
	mov	%l1, %o1	!mov -7 value into %o1
	mov	5, %o1		!mov 5 to %o1
	call .mul		! 5-7^3
	nop
	add	%o0, %l2, %l2	!5-7^3+27^2-43
	
	mov	-27, %o0		!mov -27 to %o0
	mov	%l1, %o1	!mov l1 to %o1
	call .mul		!-27-7
	nop
	add	%o0, %l2, %l2	!5-7^3+27^2+27-7-43

	bge	loop	
	nop
	mov -6, %o0      !mov -6 to check the lower bound
	mov	%l2, %l0	!mov y to l0
	
loop:
	cmp	%l2, %l0	!comparing
	bge	print		!if is greater or equal to branch and print
	nop
	mov	%l2, %l0	

print:
	set	fmt1, %o0	!setting string for printing...
	mov	%l1, %o1	!printing -7....
	call printf		!printing...
	nop

	set	fmt2, %o0	!setting string for printing...
	mov	%l2, %o1	!printing y..
	call printf		!printing...
	nop

	set	fmt3, %o0	!setting string for printing...
	mov	%l0, %o1	!printing l0 ...
	call printf		!printing...
	nop

start:
	cmp %l1, 6    
	add %l1, 1, %l1     
	bl	check		!
	nop

mov	1, %g1			
ta	0
