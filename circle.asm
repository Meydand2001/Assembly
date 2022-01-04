.word 0x100 20

lw $a0, $imm1, $zero, $zero, 0x100, 0					  # $a0 = MEM[0x100] = radius
mac $a0, $a0, $a0, $zero, 0, 0                  # $a0 = r^2
add $a1, $imm1, $zero, $zero, 128, 0            # $a1 = center point
add $t0, $imm1, $zero, $zero, -1, 0						  # $t0 = -1
sll $s0, $imm1, $imm2, $zero, 1, 16             # $s0 = 65536

CALC:
bge $zero, $t0, $s0, $imm2, 0, RIP				      # if $t0 = $s0 then RIP
add $t0, $t0, $imm1, $zero, 1, 0								# $t0 += 1
srl $t1, $t0, $imm1, $zero, 8, 0								# $t1 = $t0 : 256 rounded down
sll $t1, $t1, $imm1, $zero, 8, 0                # $t1 = $t1 * 256
sub $t1, $t0, $t1, $imm1, -128 , 0              # $t1 = $t0 mod 256 - 128 = x -128
srl $t2, $t0, $imm1, $zero, 8, 0								# $t2 = $t0 : 256 rounded down
sub $t2, $t2, $imm1, $zero, 128, 0              # $t2 = $t2 - 128
mac $t1, $t1, $t1, $zero, 0, 0									# $t1 = $t1^2 = (x-128)^2
mac $t2, $t2, $t2, $t1, 0, 0										# $t2 = (x-128)^2 +(y-128)^2
bgt $zero, $t2, $a0, $imm1, 0, CALC						  # if ((x-128)^2 +(y-128)^2 > r^2) jump to CALC

COLOR:
out $zero, $imm1, $zero, $t0, 20, 0							# montioraddr = $t0 = (x,y)
out $zero, $imm1, $zero, $imm2, 21, 255				  # montiordata = 255 = white
out $zero, $imm1, $zero, $imm2, 22, 1					  # montiorcmd = 1 = color pixel
beq $zero, $zero, $zero, $imm1, CALC, 0					# jump to CALC

RIP:
halt $zero, $zero, $zero, $zero, 0, 0						# rest in peace dear circle
