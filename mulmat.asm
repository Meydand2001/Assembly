.word 0x100 1
.word 0x101 0
.word 0x102 0
.word 0x103 0
.word 0x104 0
.word 0x105 1
.word 0x106 0
.word 0x107 0
.word 0x108 0
.word 0x109 0
.word 0x10A 1
.word 0x10B 0
.word 0x10C 0
.word 0x10D 0
.word 0x10E 0
.word 0x10F 1
.word 0x110 16
.word 0x111 1
.word 0x112 2
.word 0x113 3
.word 0x114 4
.word 0x115 5
.word 0x116 6
.word 0x117 7
.word 0x118 8
.word 0x119 9
.word 0x11A 10
.word 0x11B 11
.word 0x11C 12
.word 0x11D 13
.word 0x11E 14 
.word 0x11F 15

add $a0, $imm1, $zero, $zero, 0x100, 0				# $a0 = 0x100
add $a1, $imm1, $zero, $zero, 0x110, 0				# $a1 = 0x110
add $a2, $imm1, $zero, $zero, 0x120, 0				# $a2 = 0x120
add $s2, $zero, $zero, $zero, 0, 0						# $s2 = 0 (Result matrix Index from 0 to 15)
add $v0, $zero, $zero, $zero, 0, 0						# $v0 = 0 (Result value)
add $t0, $zero, $zero, $zero, 0, 0						# $t0 = 0 (Result matrix row Index from 0 to 4)
add $t1, $zero, $zero, $zero, 0, 0						# $t1 = 0 
add $t2, $zero, $zero, $zero, 0, 0						# $t2 = 0 (Result matrix column Index from 0 to 4)

CINDEX:
add $t2, $s2, $zero, $zero, 0, 0							# $t2 = $s2
blt $zero, $t2, $imm1, $imm2, 0x4, OPT				# if ($t2 < 4): jump to OPT
sub $t2, $t2, $imm1, $zero, 0x4, 0						# $t2 = $t2 - 4
add $t0, $t0, $imm1, $zero, 0x4, 0 						# $t0 += 4
beq $zero, $zero, $zero, $imm2, 0, CINDEX		# jump to CINDEX

OPT:
add $s0, $t0, $zero, $zero, 0, 0							# $s0 = $t0 (Row = Index/4 rounded down * 4, {0,4,8,12})
add $s1, $t2, $zero, $zero, 0, 0							# $s1 = $t2 (Column = Index mod 4, {0,1,2,3})

CCELL:
lw $t0, $a0, $s0, $zero, 0, 0								# $t0 = MEM[$a0+$s0] (first matrix value)
lw $t1, $a1, $s1, $zero, 0, 0								# $t1 = MEM[$a1+$s1] (second matrix value)
mac $v0, $t0, $t1, $v0, 0, 0									# $v0 += $t0 * $t1
add $s0, $s0, $imm1, $zero, 0x1, 0 					# $s0 += 1
add $s1, $s1, $imm1, $zero, 0x4, 0 					# $s1 += 4
add $t2, $t2, $imm1, $zero, 0x1, 0						# $t2 += 1 (counting 4 times)
bgt $zero, $t2, $imm1, $imm2, 0x4, CCELL		# if ($t2 < 4): jump to CCELL
sw $v0, $a2, $s2, $zero, 0, 0								# MEM[$a2+$s2] = $v0 
add $v0, $zero, $zero, $zero, 0, 0						# $v0 = 0
add $t0, $zero, $zero, $zero, 0, 0						# $t0 = 0
add $s2, $s2, $imm1, $zero, 0x1, 0 					# $s2 += 1
blt $zero, $s2, $imm1, $imm2, 0x10, CINDEX	# if ($s2 < 16): jump to CINDEX