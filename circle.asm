.word 0x100 20

add $a0, $imm1, $zero, $zero, 0x100, 0					# $a0 = 0x100
add $t0, $imm1, $zero, $zero, -1, 0						# $t0 = -1

CALC:
bgt $zero, $t0, $imm1, $imm2, 65535, RIP				# if $t0 
add $t0, $t0, $imm1, $zero, 1, 0								# $t0 += 1
srl $t1, $t0, $imm1, $zero, 8, 0								# $t1 = $t0 mod 256 = x
mac $t2, $t1, $imm1, $t0, -8, 0								# $t2 = $t0 - 8*$t1 = y
mac $t1, $t1, $t1, $zero, 0, 0									# $t1 = $t1^2 = x^2
mac $t2, $t2, $t2, $t1, 0, 0										# $t2 = x^2 +y^2
bgt $zero, $t2, $a0, $imm1, 0, CALC						# if (x^2 +y^2 >r) jump to CALC

COLOR:
out $zero, $imm1, $zero, $t0, 20, 0							# montioraddr = $t0 =(x,y)
out $zero, $imm1, $zero, $imm2, 21, 255				# montiordata = 255 = white
out $zero, $imm1, $zero, $imm2, 22, 1					# montiorcmd = 1 = color pixel
reti $zero, $zero, $zero, $zero, 0, 0						# return

RIP:
halt $zero, $zero, $zero, $zero, 0, 0						# rest in peace dear circle