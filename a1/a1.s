.global main

fmty:   .asciz          "The value of y is %d\n"
fmtx:   .asciz          "The value of x is %d\n"
fmtm:   .asciz          "The value of the min is %d\n"

		! Constant of the polynomial
		! Coefficient to x in the polynomial
	! Coefficient to x^2 in the polynomial
		! Coefficient to x^3 in the polynomial

		! Lower limit of the domain
		! Starting point for program
		! Upper limit of the domain

		! Variable to hold the minimum value
		! Variable to hold the x value being tested 
		! Variable to hold the y value for different x values


main:
	save	%sp, -96, %sp

	ba	top		! Always start at the loop
	mov	-7, %l1		! Move first value of x into variable x
	clr	%l2		! Set value of y to 0

calc:
	
	/* Add constant to y variable */
	
	mov	-43,%l2	! Add 39 to the y variable

	/* Compute the -18x^2 portion of the polynomial */

	mov	%l1, %o0	! Move value of x to %o0
	call	.mul		! Calculate value of x^2, store in %o0
	mov	%l1, %o1	! Move value of x to %o1
	mov	%o0, %l3	! Store value of x^2 in %l3 for x^3 calculation
	call	.mul		! Calculate value of 27*x^2, store in %o0
	mov	27, %o1	! Move value of 27 (-18) into %o1
	add	%o0, %l2, %l2	! Add value of -18x^2 in %o0 to y variable
	
	/* Compute 2x^3 part of the polynomial */

	
	mov	%l3, %o0	! Move stored x^2 value into %o0 from %l3
	call	.mul		! Calculate the value of x^3, store in %o0
	mov	%l1, %o1	! Move x value into %o1
	call	.mul		! Calculate the value of 27*x^3, store in %o0
	mov	5, %o1	! Move value of 5 (2) into %o1
	add	%o0, %l2, %l2	! Add the value of 2x^3 to y variable

	/* Compute 10x part of the polynomial */
	
	mov	-27, %o0	! Move value of -27 (10) into %o0
	call	.mul		! Calculate the value of -27*x, store into %o0
	mov	%l1, %o1	! Move value of x into %o1
	add	%o0, %l2, %l2	! Add value of 10x to the y variable


	/*Check if this is the first calculation */
	bge	cmpy		! If this isn't the first calculation, go to cmpy
	mov     -6, %o0          ! Move lower limit into %oO
	mov	%l2, %l0	! If this is the first calclation, replace l0 with y
	
cmpy:
	cmp	%l2, %l0	! Compare y value to the current l0 value
	bge	print		! If y is greater than l0, go to print
	nop
	mov	%l2, %l0	! If y is less than l0 value, replace l0 with y value

print:

	set	fmtx, %o0	! Put the x string into %o0
	call	printf		! Print the value of x string to the screen
	mov	%l1, %o1	! Put the x value into %o1

	set	fmty, %o0	! Put the y string into %o0
	call	printf		! Print the value of y string to the screen
	mov	%l2, %o1	! Put the y value into %o1

	set	fmtm, %o0	! Put the minimum string into %o0
	call	printf		! Print the value of mimimum string to the screen
	mov	%l0, %o1	! Put the mimimum value into %o1

top:
	cmp     %l1, 6         ! Compare x value to upper limit of 11
	bl	calc		! If x <= l1 then do the calculation for the new x value
	inc     %l1            ! Increment x by 1

mov	1, %g1			! Exit request
ta	0			! Trap to system
