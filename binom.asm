.word 0x100 5
.word 0x101 2

lw $s0, $imm1, $zero, $zero, 0x100, 0							            # $s0 = n
lw $s1, $imm1, $zero, $zero, 0x101, 0							            # $s1 = k
add $v0, $zero, $zero, $zero, 0, 0								            # $v0 = 0 (result) 
sll $sp, $imm1, $imm2, $zero, 1, 11		                        # set $sp = 1 << 11 = 2048
add $ra, $imm1, $zero, $zero, RIP, 0                          # $ra = RIP (first return address is set to DIEBITCH to finish the program)

BINOM:
add $sp, $sp, $imm1, $zero, -3, 0									            # $sp -= 3 (opens rooms in the stack)
sw $s0, $sp, $imm1, $zero, 0, 0										            # MEM[$sp + 0] = $s0 (stores the value of n)
sw $s1, $sp, $imm1, $zero, 1, 0										            # MEM[$sp + 1] = $s1 (stores the value of k)
sw $ra, $sp, $imm1, $zero, 2, 0										            # MEM[$sp + 2] = $ra (stores return address)
beq $zero, $s1, $zero, $imm1, CALC, 0							            # if [k==0] jump to CALC
beq $zero, $s1, $s0, $imm1, CALC, 0							              # if [k==n] jump to CALC
add $s0, $s0, $imm1, $zero, -1, 0									            # $s0 = $s0 - 1 (set n-1 to calc n-1Ck)
jal $ra, $zero, $zero, $imm1, BINOM, 0 						            # jump to BINOM
add $s1, $s1, $imm1, $zero, -1, 0									            # $s1 = $s1 - 1 (set k-1 to calc n-1Ck-1)
jal $ra, $zero, $zero, $imm1, BINOM, 0 						            # jump to BINOM

RELEASE:
lw $s0, $sp, $imm1, $zero, 0, 0										            # $s0 = MEM[$sp + 0] (releases the value of n)
lw $s1, $sp, $imm1, $zero, 1, 0										            # $s1 = MEM[$sp + 1] (releases the value of k)
lw $ra, $sp, $imm1, $zero, 2, 0										            # $ra = MEM[$sp + 2] (releases return address)
add $sp, $sp, $imm1, $zero, 3, 0									            # $sp += 3
beq $zero, $zero, $zero, $ra, 0, 0								            # jump to $ra

CALC:
add $v0, $v0, $imm1, $zero, 1, 0									            # $v0 += 1 (nC0 or nCn = 1)
beq $zero, $zero, $zero, $imm1, RELEASE, 0				            # jump to RELEASE

RIP:
sw $v0, $imm1, $zero, $zero, 0x102, 0                         # MEM[0x102] = $v0 (stores the result)
halt $zero, $zero, $zero, $zero, 0, result
