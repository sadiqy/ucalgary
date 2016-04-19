/*
Link C File to assembly file
(a+b)*(c-d)
a+b*c-d
(a+b)*c-d.
%m4 a5a.m > a5a.s

%as a5a.s -o a5a.o

%gcc a5aMain.c  a5a.o -o a5a */
include(macro_defs.m)
		  .section ".text"
star:	.byte "*"
      .align 4
period:	.asciz "%c"

begin_fn(find)
start:
      set	ch,%o1					!setting &ch to %o1
      set	period,%o0			!setting period into %o0
      call scanf					!calling scanf function
      nop	  							!delay slot

      set ch, %o0         !setting &ch to %o0
      ld [%o0], %l0       !loading ch

      cmp	%l0, " "				!checking if ch==' '
      be start					  !branch if not equal to..
      nop

      set	ch, %o0				  !setting...
      ld [%o0], %l0 		  !loading ...ch
      cmp	%l0, -1					!if is the end of file
      bne	end					    !branch if equal EOF
      nop

      call exit					  !calling exit....
      nop
end:
end_fn(find)

local_var							    !local variable...
var(op_s, 1)
begin_fn(expression)
	call term					      !calling term function...
	nop

exp:
	sethi %hi(ch), %o0		    		  !setting ch...
	ldub [%o0+%lo(ch)], %l0		      !loading ch...

  cmp	%l0, "+"					  !if ch=='+'
	be first					      !branch to first
	nop

	cmp	%l0, "-"					  !if ch=='-'
	be first     						!branch to first
	nop

	ba done                  !branch again
	nop

first:
	stb	%l0, [%fp+op_s]			!storing ch ..
	call find				      	!calling find function
	nop

	call term		      			!calling term function
	nop

	ldub [%fp+op_s], %o1		!op_s value is in %o1
	set	period, %o0		  		!loading period to print
	call	printf				  	!printing...
	nop

	ba exp					        !branch again to exp
	nop
done:
end_fn(expression)

begin_fn(term)
	call factor					   !calling factor function
	nop

fst:
	sethi	%hi(ch), %o0		!setting &ch
	ldub [%o0+%lo(ch)],%l0		!loading ch

	cmp %l0,"*"				  	!if ch=="*"
	bne	snd						    !if not equal
	nop

	call	find					  !calling find function
	nop

	call	factor					!calling factor function
	nop

	set	star,%o0				 !setting.. "*"
	call	printf				 !printing..
	nop

	ba fst						   !branch again to fst
	nop
snd:
end_fn(term)

begin_fn(factor)
	sethi	%hi(ch),%o0		!setting &ch
	ldub	[%o0+%lo(ch)],%l0		!loading...

	cmp	%l0,"("	   			!if ch=='('
	bne	tth						  !if not equal
	nop

	call find					   !calling find function
	nop

	call expression			 !calling expression function
	nop

	ba fr						     !branch again else
	nop

tth:
	sethi	%hi(ch),%o0				!setting &ch
	ldub [%o0+%lo(ch)],%o1	!ch

	set	period, %o0
	call printf					   !printing...
	nop

fr:
	call	find			     		!calling find function
	nop
end_fn(factor)
