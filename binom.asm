.word 0x100 5
.word 0x101 2

lw $s0, $imm1, $zero, $zero, 0x100, 0							# $s0 = n
lw $s1, $imm1, $zero, $zero, 0x101, 0							# $s1 = k
add $v0, $zero, $zero, $zero, 0, 0									# $v0 = 0

BINOM:
add $sp, $sp, $imm1, $zero, -12, 0									# $sp -= 12
sw $s0, $sp, $imm1, $zero, 0, 0										# MEM[$sp + 0] = $s0
sw $s1, $sp, $imm1, $zero, 4, 0										# MEM[$sp + 4] = $s1
sw $ra, $sp, $imm1, $zero, 8, 0										# MEM[$sp + 8] = $ra
beq $zero, $s1, $zero, $imm1, CALC, 0							# if [k==0] jump to CALC
beq $zero, $s1, $s0, $imm1, CALC, 0							# if [k==n] jump to CALC
add $s0, $s0, $imm1, $zero, -1, 0									# $s0 = $s0 - 1
jal $ra, $zero, $zero, $imm1, BINOM, 0 							# jump to BINOM
add $v0, $imm1, $zero, $zero, 1, 0									# $v0 += 1
add $s1, $s1, $imm1, $zero, -1, 0									# $s1 = $s1 - 1
jal $ra, $zero, $zero, $imm1, BINOM, 0 							# jump to BINOM
add $v0, $imm1, $zero, $zero, 1, 0									# $v0 += 1

CALC:
lw $s0, $sp, $imm1, $zero, 0, 0										# $s0 = MEM[$sp + 0]
lw $s1, $sp, $imm1, $zero, 4, 0										# $s1 = MEM[$sp + 4]
lw $ra, $sp, $imm1, $zero, 8, 0										# $ra = MEM[$sp + 8]
add $sp, $sp, $imm1, $zero, 12, 0									# $sp += 12
beq $zero, $zero, $zero, $ra, 0, 0									# jump to $ra
halt $zero, $zero, $zero, $zero, 0, 0
