 
fmt1:	.asciz	"\nInitial circle values:\n"
fmt2:	.asciz	"\nChanged circle values:\n"
fmt:	.asciz	"Circle %s origin = (%d, %d) radius = %d\n"
fmt3:	.asciz	"first"
fmt4:	.asciz	"second"
		.align 4


/* structure of point_x and point_y */
!define structure point

point_x = 0
point_y = 4
 
	!align_of_point, 4 bytes
	!size_of_point, 8 bytes
/* structure of circle, point_origin and radius */
!define structure circle

circle_origin = 0
circle_radius = 8
 
	!align_of_circle, 4 bytes
	!size_of_circle, 12 bytes

!local variables 
 c = -12
.global	newCircle
	.align	4
newCircle:	save	%sp, -104, %sp

  ld [%i7+8], %l0											!loading size
	cmp	%l0, 12							!comparing size
	bne	return                           !branch if is equal
  ld [%fp+64], %o0										!loading file pointer
  st %g0, [%fp+c+circle_origin+point_x]!storing x
  ld [%fp+c+circle_origin+point_x], %o1!loading x
  st %o1, [%o0+circle_origin+point_x]	!storing x

  st %g0,[%fp+c+circle_origin+point_y]!storing y
  ld [%fp+c+circle_origin+point_y], %o1!loading y
  st %o1, [%o0+circle_origin+point_y]	!storing y

  mov	1, %l0												  !move 1 to be radius
  st %l0,[%fp+c+circle_radius]				!storing radius
  ld [%fp+c+circle_radius],%o1				!loading radius
  st %o1, [%o0+circle_radius]

return:	jmpl %i7+12, %g0							!return c
	restore
  !st %l4, [%o0+circle_radius]
ret
	restore 
	.type	newCircle, #function
	.size	newCircle, . - newCircle


.global	move
	.align	4
move:	save	%sp, -96, %sp

  ld [%i0+circle_origin+point_x], %l0  !loading x
  add %l0, %i1, %l0                    !origin += deltaX
  st %l0, [%i0+circle_origin+point_x]  !storing deltaX
  !ld [%i0+circle_origin+point_x], %l0

  ld [%i0+circle_origin+point_y], %l0  !loading y
  add %l0, %i2, %l0                    !origin += deltaY
  st %l0, [%i0+circle_origin+point_y]  !storing deltaX
ret
	restore 
	.type	move, #function
	.size	move, . - move


.global	expand
	.align	4
expand:	save	%sp, -96, %sp

	ld [%i0+circle_radius], %l0						!loading radius
	smul %l0,%i1,%l0											!radius *= factor
	st %l0,[%i0+circle_radius]					  !storing radius
ret
	restore 
	.type	expand, #function
	.size	expand, . - expand


.global	equal
	.align	4
equal:	save	%sp, -96, %sp

	mov	0, %l0											  !false
	ld	[%i0+circle_origin+point_x],%l1		!loading x
	ld	[%i1+circle_origin+point_x],%l2		!loading x1

  ld [%i0+circle_origin+point_y],%l1		!loading y1
  ld [%i1+circle_origin+point_y],%l2		!loading y2

  ld [%i0+circle_radius], %l1						!loading radius
  ld [%i1+circle_radius], %l2						!loading radius2

	cmp	%l1, %l2												  !!c1->origin.x == c2->origin.x)
	bne	done
	nop

	cmp	%l1,%l2												    !c1->origin.y == c2->origin.y)
	bne	done
	nop

	cmp	%l1,%l2												    !c1->origin.radius == c2->origin.raduis)
	bne	done
	nop

	mov		1,%l0
  !st %g1, [%fp+4]												!storing
  !ld [%fp+64], %o0
done:
  mov	%l0, %i0                            !return true
ret
	restore 
	.type	equal, #function
	.size	equal, . - equal


.global	printCircle
	.align	4
printCircle:	save	%sp, -96, %sp

	set	fmt, %o0												   !setting...
	ld		[%i1+circle_origin+point_x],%o2	 !loading x
	ld		[%i1+circle_origin+point_y],%o3	 !loading y
	ld		[%i1+circle_radius],%o4					 !loading radius
	call	printf												   !printing...
	mov		%i0,%o1
ret
	restore 
	.type	printCircle, #function
	.size	printCircle, . - printCircle


!local variables 
 first = -12
 second = -24

.global	main
	.align	4
main:	save	%sp, -120, %sp
	add	%fp, first, %o0										!first address
	call	newCircle											  !calling function newcircle
	st %o0, [%sp+64]										  !storing first address

	.word	12									!size of circle
	add	%fp,second,%o0										!second address
	call newCircle											  !calling newcircle
  st %o0,[%sp+64]										    !storing second address

	.word	12									!size of circle
	set	fmt1, %o0	   										  !setting....
	call printf	   											  !printing...
	nop

	set	fmt3, %o0												  !setting....
	call	printCircle											!calling function printCircle

  add	%fp, first, %o1										!first
	set	fmt4,%o0												  !setting...
	call	printCircle											!calling function printCircle

	add	%fp, second, %o1									!second
	add	%fp, first, %o0										!first
	call equal												    !calling function equal
	add	%fp, second, %o1								  !second

	cmp	%o0, 1
	bne	print
	nop

	add	%fp, first, %o0										!first
	mov	3, %o1												    !moving 3 to o1
	call move  												    !calling function move
	mov	-5, %o2    												!moving -5 to 02
	add	%fp, second, %o0									!second
	call	expand										  		!calling function expand
	mov	7, %o1												    !

print:
  set	fmt2, %o0										     !setting.........
	call printf												   !printing......
	nop

	set	fmt3, %o0												!setting.....
	call printCircle										!calling function...
	add	%fp,first,%o1										!first
	set	fmt4,%o0												!setting...
	call printCircle										!calling function
	add	%fp,second,%o1									!second
mov	1, %g1
	ta	 0
