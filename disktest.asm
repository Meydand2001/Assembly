add $t0, $imm1, $zero, $zero, 7, 0								# $t0 = 7
add $t1, $imm1, $zero, $zero, 892, 0							# $t1 = 128*7
out $zero, $imm1, $zero, $imm2, 1, 1							# Enable Irq1
out $zero, $imm1, $zero, $imm2, 6, DECIDE				# Handler = DECIDE
add $t2, $zero, $zero, $zero, 0, 0								# $t2 = 0

SUFFER:
blt $zero, $t0, $zero, $imm1, DIEBITCH, 0 				# if $t0 < 0, jump to DIEBITCH
beq $zero, $zero, $zero, $imm1, SUFFER, 0					# Suffers for itenety until 

DECIDE:
beq $zero, $t2, $zero, $imm1, READ, 0						# if $t2 = 0 jump to READ
beq $zero, $t2, $imm2, $imm1, WRITE, 1					# if $t2 = 1 jump to WRITE

READ:
out $zero, $imm1, $zero, $t0, 15, 0								# sector number = $t0
out $zero, $imm1, $zero, $t1, 16, 0								# sector buffer = $t1
out $zero, $imm1, $zero, $imm2, 14, 1						# read sector 
add $t2, $imm1, $zero, $zero, 1, 0								# $t2 = 1
add $t0, $imm1, $zero, $zero, 1, 0								# $t0 += 1
reti $zero, $zero, $zero, $zero, 0, 0							# return

WRITE:
out $zero, $imm1, $zero, $t0, 15, 0								# sector number = $t0
out $zero, $imm1, $zero, $t1, 16, 0								# sector buffer = $t1
out $zero, $imm1, $zero, $imm2, 14, 2						# write to sector 
add $t2, $zero, $zero, $zero, 0, 0								# $t2 = 0
add $t0, $t0, $imm1, $zero, -1, 0								# $t0 -= 1
add $t1, $t1, $imm1, $zero, -128, 0							# $t1 -= 128
reti $zero, $zero, $zero, $zero, 0, 0							# return

DIEBITCH:
Halt $zero, $zero, $zero, $zero, 0, 0							# Literally die bitch