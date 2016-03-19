include(macro_defs.m)
fmt:	.asciz		"v[%d]: %d\n"
fmt1:	.asciz		"*******SORTED ARRAY*****\n"
fmt2:	.asciz		"*****UNSORTED ARRAY*****\n"
/*define registers for the array and variables*/
define(gap_r,l0)
define(i_r,l1)
define(j_r,l2)
define(v,40)

local_var
var(v_size,4,4*40)
begin_main
	set fmt2, %o0		!move what to print to the output register
	call printf			!printing...
	nop

L1:
		call rand				!generate random numbers
		nop							!no op
		and	%o0,0xFF,%o0	!OUTPUT register AND the hex OxFF
		sll	%i_r, 2, %o1	!i*4 = 4 v
		add	%fp, %o1, %o1	!compute the address
		st %o0,[%o1+v_size]	!store into the array
		add %i_r, 1, %i_r	!increment i by 1 ++i
		cmp	%i_r, v				!compare i < v
		bl L1							!if is lessthan size
		nop								!no op
		mov	v, %gap_r			!mov v to gap register
		srl	%gap_r, 1, %gap_r
		clr		%i_r

print:
		set fmt, %o0			!setting to print...
		mov	%i_r, %o1			!mov i to print
		sll	%i_r,2,%o2		!i*4 = 4 v
		add	%fp, %o2, %o2	!compute the address
		ld [%o2+v_size], %o2!loading array value to print
		call printf				!printing...
		add %i_r, 1, %i_r	!increment i by 1 ++i
		cmp	%i_r, v				!compare i < v
		bl print					!if is lessthan size
		nop								!no op
		mov	v, %gap_r			!mov v to gap register
		srl	%gap_r, 1, %gap_r
		
end:
	set fmt1, %o0		!mov to the output register
	call printf			!printing...
	nop

start:
		cmp	%gap_r, 0			!comparing if is greathan 0
		ble,a	sorted			!if gap > 0
		clr	%i_r					!clear i
		mov	%gap_r, %i_r	!mov i to gap

for2:
	cmp	%i_r, v					!comparing if o <= size
	bge	for							!branch to for
	nop									!no op
	sub	%i_r, %gap_r, %j_r	!j=i-gap

for3:
	cmp	%j_r,0					!comparing....
	bl LL2							!branch to LL2
	nop									!no op

	sll	%j_r, 2, %o0		!j*2
	add	%fp, %o0, %o0		!compute the address
	ld	[%o0+v_size],%o2!storing the arrays
	add	%j_r, %gap_r, %o1!j+gap
	sll	%o1, 2, %o1			!
	add	%fp,%o1,%o1			!computing...
	ld [%o1+v_size], %o3!storing NSMutableArray *array = [NSMutableArray array];
	cmp	%o2, %o3				!v[j]>v[j+gap]
	ble	LL2							!v[j]>v[j+gap]
	nop									!no op
	st %o3,[%o0+v_size]	!v[j]=v[j+gap]
	st %o2,[%o1+v_size]	!v[j+gap]=temp

LL3:
		ba for3						!branch again
		sub	%j_r, %gap_r, %j_r	!j-=gap

LL2:
	ba for2							!bramch again
	add	%i_r, 1, %i_r

for:
	ba start				!branch again to start
	srl	%gap_r, 1, %gap_r

sorted:
	set fmt, %o0				!sstting....
	mov	%i_r,%o1				!printing...
	sll	%i_r, 2, %o2		!computing address
	add	%fp,%o2,%o2			!adding offset to fp
	ld [%o2+v_size],%o2	!loading array
	call printf				!printing....
	add	%i_r, 1, %i_r
	cmp	%i_r,v
	bl sorted
	nop

end_main
