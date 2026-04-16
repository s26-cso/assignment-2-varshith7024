.section .rodata
fmt_first: .string "%d"
fmt_space: .string " %d"
nl:        .string "\n"
.text
.global main

/*
# push value in t0
sw t0, 0(s6)
addi s6, s6, 4
# pop
addi s6, s6, -4
lw t0, 0(s6)
*/

# a0 argc
# a1 argv

main:
    addi sp, sp, -80
    sd ra, 0(sp)
    sd s0, 8(sp) # base pointer
    sd s1, 16(sp) # n
    sd s2, 24(sp) # argv
    sd s3, 32(sp) # i
    sd s4, 40(sp) # result array
    sd s5, 48(sp) # stack base
    sd s6, 56(sp) # stack top pointer
    sd s7, 64(sp) # for printf

    mv t0, a0
    mv s2, a1

    addi t0, t0, -1 
    blez t0, exit

    mv s1, t0
    slli a0, s1, 2
    call malloc

    mv s0, a0
    li s3, 1

    mv t0, a0

    j loop

loop:
    bgt s3, s1, loop_done

    slli t1, s3, 3 # i in bytes
    add t1, s2, t1 # argv offset
    ld t2, 0(t1) # argv[i]

    mv a0, t2
    call atoi

    addi t3, s3, -1
    slli t3, t3, 2
    add t3, s0, t3 # array offset
    sw a0, 0(t3)

    addi s3, s3, 1
    j loop    

loop_done:
    # now generate results array
    slli a0, s1, 2
    call malloc
    mv s4, a0

    # fill with -1
    li a1, -1
    slli a2, s1, 2
    call memset

    # create stack
    slli a0, s1, 2
    call malloc
    mv s5, a0
    
    mv t0, s1
    addi t0, t0, -1
    mv s3, t0

    mv s6, s5
    j reverse_loop_1

reverse_loop_1:
    blt s3, x0, print
    bne s6, s5, inner_loop
    j reverse_loop_2

inner_loop:
    # find arr[stack.top()]
    beq s6, s5, reverse_loop_2
    lw t1, -4(s6) 
    slli t2, t1, 2 
    add t2, s0, t2
    lw t3, 0(t2)

    # find arr[i]
    slli t4, s3, 2
    add t2, s0, t4
    lw t5, 0(t2)

    bge t5, t3, pop_stack
    j write_result

pop_stack: 
    addi s6, s6, -4
    j inner_loop

write_result:
    beq s6, s5, reverse_loop_2

    slli t0, s3, 2
    add t0, s4, t0
    
    lw t1, -4(s6)
    sw t1, 0(t0)
    j reverse_loop_2

reverse_loop_2:
    sw s3, 0(s6)
    addi s6, s6, 4
    addi s3, s3, -1
    j reverse_loop_1

print:
    li s7, 0
    j print_loop

print_loop:
    bge s7, s1, exit

    slli t1, s7, 2
    add t1, s4, t1
    lw t2, 0(t1)

    beqz s7, print_first

    mv a1, t2
    la a0, fmt_space
    call printf
    j next_print

print_first:
    mv a1, t2
    la a0, fmt_first
    call printf
    j next_print

next_print:
    addi s7, s7, 1
    j print_loop

exit:
    la a0, nl
    call printf

    ld ra, 0(sp)
    ld s0, 8(sp)
    ld s1, 16(sp) 
    ld s2, 24(sp) 
    ld s3, 32(sp)
    ld s4, 40(sp)
    ld s5, 48(sp)
    ld s6, 56(sp)
    ld s7, 64(sp)
    addi sp, sp, 80
    ret
