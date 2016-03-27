include(macro_defs.m)
       .global month
month: .word Jan_m, Feb_m, Mar_m, Apr_m, May_m, Jun_m, Jul_m, Aug_m, Sep_m, Oct_m, Nov_m, Dec_m

Jan_m: .asciz "January"   !January
Feb_m: .asciz "February"  !February
Mar_m: .asciz "March"     !March
Apr_m: .asciz "April"     !April
May_m: .asciz "May"       !May
Jun_m: .asciz "June"      !June
Jul_m: .asciz "July"      !July
Aug_m: .asciz "August"    !August
Sep_m: .asciz "September" !September
Oct_m: .asciz "October"   !October
Nov_m: .asciz "November"  !November
Dec_m: .asciz "December"  !December

error: .asciz "Usage mm dd yyyy \n"
first: .asciz "%s %dst, %d\n"
second:.asciz "%s %dnd, %d\n"
third: .asciz "%s %drd, %d\n"
fourth:.asciz "%s %dth, %d\n"
     .align 4

begin_main

  cmp %i0, 4              !check if the user pasees day, month and year
  bne message             !branch to the error message
  nop

  call atoi               !change string to int
  ld [%i1+4], %o0	      !loading the month to register o0
  mov %o0, %l0            !moving o0 to l0

  call atoi               !change string to int
  ld [%i1+8], %o0         !loading the day to register o0
  mov %o0, %l1 	          !moving o0 to l1

  call atoi               !change string to int
  ld [%i1+12], %o0        !loading the year to register o0
  mov %o0, %l2            !moving o0 to l2

  cmp %l1, 1              !if is the 1st day
  bne day                 !branch to 2nd if is not the 1st day
  set first, %o0	       !set it to the first day of the month
  ba smonth					      !branch to smonth
  nop

 day:
  cmp %l1, 2              !if is the 2nd day
  bne day2                !branch to 3rd if is not the 1st day
  nop
  set second, %o0		      !set it to the second day of the month
  ba smonth               !set the month
  nop

 day2:
   cmp %l1, 3             !if is the 3rd day
   bne day21              !branch to 21st if is not the 3rd day
   nop
   set third, %o0         !set it to the third day of the month
   ba smonth              !set smonth
   nop

 day21:
  cmp %l1, 21             !if is the 21st day
  bne day31               !branch to 31st if is not the 21st day
  set first, %o0          !set it to the 21st day of the month
  ba smonth               !set smonth
  nop

 day31:
  cmp %l1, 31             !if is the 31st day
  bne days                !branch to others if is not the 31st day
  set first, %o0          !set it to the 31st day of the month
  ba smonth               !set smonth
  nop

days:
  set fourth, %o0         !set to day excepts 1st, 2nd, 3rd, 21st and 31st
  ba smonth               !set smonth
  nop

smonth:
  set month, %o1

  sub %l0, 1, %l0 			 !decreaing l0
  sll %l0, 2, %l0	       !get the offset address of the month
  add %o1, %l0 ,%o1      !adding to get the address of month

  ld [%o1], %o1	         !load the month from register
  mov %l1, %o2		       !move l1 to o2 to print the day
  mov %l2, %o3		       !move l2 to o3 to print the year
  call printf
  nop

message:
  set error, %o0         !setting error message
  !ld [%o1], %o0
  call printf
  nop

end:
end_main
