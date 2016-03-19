 
fmt:	.asciz		"v[%d]: %d\n"
fmt1:	.asciz		"*******SORTED ARRAY*****\n"
fmt2:	.asciz		"*****UNSORTED ARRAY*****\n"
/* registers for the array and variables*/





!local variables 
 v_size = -160
.global	main
	.align	4
main:	save	%sp, -256, %sp
	set fmt2, %o0		!move what to print to the output register
	call printf			!printing...
	nop

L1:
		call rand				!generate random numbers
		nop							!no op
		and	%o0,0xFF,%o0	!OUTPUT register AND the hex OxFF
		sll	%l1, 2, %o1	!i*4 = 4 40
		add	%fp, %o1, %o1	!compute the address
		st %o0,[%o1+v_size]	!store into the array
		add %l1, 1, %l1	!increment i by 1 ++i
		cmp	%l1, 40				!compare i < 40
		bl L1							!if is lessthan size
		nop								!no op
		mov	40, %l0			!mov 40 to gap register
		srl	%l0, 1, %l0
		clr		%l1

print:
		set fmt, %o0			!setting to print...
		mov	%l1, %o1			!mov i to print
		sll	%l1,2,%o2		!i*4 = 4 40
		add	%fp, %o2, %o2	!compute the address
		ld [%o2+v_size], %o2!loading array value to print
		call printf				!printing...
		add %l1, 1, %l1	!increment i by 1 ++i
		cmp	%l1, 40				!compare i < 40
		bl print					!if is lessthan size
		nop								!no op
		mov	40, %l0			!mov 40 to gap register
		srl	%l0, 1, %l0
		
end:
	set fmt1, %o0		!mov to the output register
	call printf			!printing...
	nop

start:
		cmp	%l0, 0			!comparing if is greathan 0
		ble,a	sorted			!if gap > 0
		clr	%l1					!clear i
		mov	%l0, %l1	!mov i to gap

for2:
	cmp	%l1, 40					!comparing if o <= size
	bge	for							!branch to for
	nop									!no op
	sub	%l1, %l0, %l2	!j=i-gap

for3:
	cmp	%l2,0					!comparing....
	bl LL2							!branch to LL2
	nop									!no op

	sll	%l2, 2, %o0		!j*2
	add	%fp, %o0, %o0		!compute the address
	ld	[%o0+v_size],%o2!storing the arrays
	add	%l2, %l0, %o1!j+gap
	sll	%o1, 2, %o1			!
	add	%fp,%o1,%o1			!computing...
	ld [%o1+v_size], %o3!storing NSMutableArray *array = [NSMutableArray array];
	cmp	%o2, %o3				!40[j]>40[j+gap]
	ble	LL2							!40[j]>40[j+gap]
	nop									!no op
	st %o3,[%o0+v_size]	!40[j]=40[j+gap]
	st %o2,[%o1+v_size]	!40[j+gap]=temp

LL3:
		ba for3						!branch again
		sub	%l2, %l0, %l2	!j-=gap

LL2:
	ba for2							!bramch again
	add	%l1, 1, %l1

for:
	ba start				!branch again to start
	srl	%l0, 1, %l0

sorted:
	set fmt, %o0				!sstting....
	mov	%l1,%o1				!printing...
	sll	%l1, 2, %o2		!computing address
	add	%fp,%o2,%o2			!adding offset to fp
	ld [%o2+v_size],%o2	!loading array
	call printf				!printing....
	add	%l1, 1, %l1
	cmp	%l1,40
	bl sorted
	nop

mov	1, %g1
	ta	 0
