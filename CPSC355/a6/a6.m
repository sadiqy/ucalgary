include(macro_defs.m)

fmt:	.asciz "|     Degrees       |       Radians       |     sin     |    cos    |\n"
fmt2:	.asciz "|   %E   |   %E   |"
fmt3:	.asciz "|   %f   |   %f   |\n"

define(BUFSIZE, 8)
define(fd, l0)
      .section ".data"
      .align 8
L1:
      .double	0r0.0
L2:
      .double 0r0.0
      .section ".text"
      .align 8
angle:  .double 0r0.0, 0r90.0	 		                  !range from 0-90
pihalf:	.double 0r1.57079632679489661923            !pi/2
mint:	  .double 0r0.0000000001			                !min
sign:	  .double 0r-1.0					                    !sign
one:	  .double 0r1.0					                      !one
two:	  .double 0r2.0                               !two
three:  .double 0r3.0                               !three

error1:
        .asciz "error loading file\n"
error2:
        .asciz "invalid angle %E\n"
        .align 4

err1:
  set	error1, %o0                                     !setting....
  call printf 	                                    !printing...
  nop

  ba done		 		                                    !branch again to the end and do nothing
  nop

err2:
	set	error2, %o0                                     !setting....
  call printf			                                    !printing...
  nop
  ba read			                                        !branch again to the read
  nop

!local variables..
local_var
var(buf, 1, BUFSIZE)
var(n, 4)
begin_main
  cmp	%i0, 2		                                    !if arg <= 0
  bne	err1  			                                  !branch if == o
  ld	[%i1+4], %o0                                  !loading...

  clr	%o1
  clr	%o2
  mov	5, %g1			                                 !open...
  ta	0

  bcc	openok			                                 !open...
  nop

  ba err1	 		                                    !error
  nop

openok:
	mov	%o0, %fd			                               !fd...
  set	fmt, %o0			                               !setting...
  call printf	                                     !printing...
  nop

read:
	mov	%fd, %o0			                              !fd...
  add	%fp, buf, %o1
  mov	BUFSIZE, %o2
  mov	3,%g1			                                  !read...
  ta	0

  cmp	%o0, 0
  be q
  nop

  ldd	[%fp-8], %f0	                              !loading...
  set	angle, %o0                                  !setting..
  ldd	[%o0], %f2	                                !loading...
  fcmpd	%f0, %f2		                            	!if angle is in range
  nop

  fbl	err2			                                   !if angle < 0
  nop

  set	angle+8, %o0		                              !setting...
  ldd	[%o0], %f2		                                !loading...
  fcmpd	%f0, %f2	                               		!if angle is in range
  nop

  fbg	err2		                      	               !if angle > 90
  nop

  set	pihalf, %o0		                                 !setting....
  ldd	[%o0], %f4	                                   !loading pi
  fdivd	%f4, %f2, %f2		                             !pi/180
  fmuld	%f0,%f2,%f2		                               !f0, f2
  fmovs	%f2,%f4			                                 !sin...
  fmovs	%f3,%f5			                                 !sin ...
  fmovs	%f2,%f6			                                 !cos
  fmovs	%f3,%f7			                                 !cos
  fmovs	%f2,%f16			                               !sin
  fmovs	%f3,%f17			                               !sin

sin:
  set	one, %o3	                                     !setting...
  ldd	[%o3], %f30                                    !loading...
s:
  mov	3, %o0
  mov	1, %o2

sinw:
	st %o0, [%fp+n]		                                 !storing...
  ld [%fp+n], %f8                                    !loading...
  fitod	%f8, %f8			                               !converting to double
  fmovs	%f8, %f10
  fmovs	%f9, %f11
  fsubd	%f10, %f30, %f10

sinf:
	fmuld	%f8,%f10,%f8
  fsubd	%f10,%f30,%f10	                             !n-1
  fcmpd	%f10,%f30
  nop

  fbg	sinf			                                     !if n>1
  nop

  fmovs	%f6, %f10		                                 !x^n
  fmovs	%f7, %f11		                                 !x^n
  fmovs	%f6, %f12		                                 !x^n
  fmovs	%f7, %f13		                                 !x^n
  mov		%o0, %o1		                                 !moving....

sine:
	fmuld	%f10, %f12, %f10	                           !x^n
  sub	%o1, 1, %o1                             			 !n-1

  cmp	%o1, 1
  bg sine			                                        !if > 0
  nop

  fdivd	%f10, %f8, %f8                              	!x^n/n
  set	mint, %o3	                                      !setting min
  ldd	[%o3], %f10		                                  !loading...
  fcmpd	%f8, %f10
  nop

  fbl	cos	                			                       !min < n
  nop

  cmp	%o2, 0			                                     !if != 0
  be,a	sina			                                     !branch to sina
  add %o2, 1, %o2                                      !++
  sub	%o2, 1, %o2	                                     !--

  set	sign, %o3		                                     !setting...
  ldd	[%o3], %f10	                                   	 !loading...

  fmuld	%f10, %f8, %f8	                               !*-1

sina:
  faddd	%f16, %f8, %f16                                !add
  add	%o0, 2, %o0                                      !add 2
  ba sinw                                              !branch again
  nop

cos:
	set	one, %o3	                            		        !setting one
  ldd	[%o3], %f30		                                    !loading...
  ldd	[%o3], %f14		                                    !loading...

c:
	mov	2, %o0
  mov	1, %o2

cosw:
  st %o0, [%fp+n]		                                    !storing....
  ld [%fp+n], %f8		                                    !loading...
  fitod	%f8, %f8                                        !converting to double
  fmovs	%f8, %f10
  fmovs	%f9, %f11
  fsubd	%f10, %f30, %f10

cosf:
  fmuld	%f8, %f10, %f8	                                 !n
  fsubd	%f10, %f30, %f10	                               !n-1
  fcmpd	%f10, %f30		                                   !n
  nop

  fbg	cosf			                                         !if n>1
  nop

  fmovs	%f6, %f10		                                     !x^n
  fmovs	%f7, %f11		                                     !x^n
  fmovs	%f6, %f12		                                     !x^n
  fmovs	%f7, %f13		                                     !x^n
  mov	%o0, %o1			                                     !n

cose:
	fmuld	%f10, %f12, %f10                                 !x*x
  sub	%o1, 1, %o1				                                 !n-1
  cmp	%o1, 1
  bg cose			                                           !if n > 0
  nop

  fdivd	%f10, %f8, %f8	                                 !x^n/n
  set	mint, %o3		                                       !setting..
  ldd	[%o3], %f10                                     	 !loading...
  fcmpd	%f8, %f10
  nop

  fbl	p
  nop

  cmp	%o2, 0
  be,a cosa
  add	%o2, 1, %o2			                                   !++
  sub	%o2, 1, %o2			                                   !--
  set	sign, %o3	                                         !setting...
  ldd	[%o3], %f10		                                     !loading...
  fmuld	%f10, %f8, %f8

cosa:
	faddd	%f14, %f8, %f14
  add	%o0, 2, %o0
  ba cosw
  nop

p:
  set	L1, %o0		                                     	     !setting...
  std	%f0, [%o0]		                                       !storing

  set	L2, %o1			                                         !setting....
  std	%f2, [%o1]		                                       !storing..
  ldd	[%o0], %o2	                                         !loading...
  ldd	[%o1], %o4          		                             !loading...

  mov	%o2, %o1
  mov	%o3, %o2
  mov	%o4, %o3
  mov	%o5, %o4

  set	fmt2, %o0	                                           !setting..
  call printf			                                         !printing...
  nop

  set	L1, %o0			                                         !setting...
  std	%f16, [%o0]		                                       !storing...
  set	L2, %o1			                                         !setting...
  std	%f14, [%o1]		                                       !storing...
  ldd	[%o0], %o2	                                         !loading..
  ldd	[%o1], %o4		                                       !loading...

  mov	%o2, %o1
  mov	%o3, %o2
  mov	%o4, %o3
  mov	%o5, %o4
  set	fmt3, %o0		                                         !setting..
  call	printf			                                       !printing...
  nop

  ba read
  nop

q:
	mov	%l0, %o0
  mov	6, %g1
  ta 0
done:
end_main
