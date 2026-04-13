.data
filename: .asciz "input.txt"
char: .space 1
yes: .asciz "Yes\n"
no: .asciz "No\n"

.text
.global main

# open file
# get file size (to init right pointer)
# loop while left < right
# read left
# read right
# comp
# left++, right--

main:
    addi sp, sp, -48
    sd ra, 0(sp)
    sd s0, 8(sp) # file descriptor
    sd s1, 16(sp) # left
    sd s2, 24(sp) # right
    sd s3, 32(sp) # file size

    li a7, 56 # openat syscall
    li a0, -100 # AT_FDCWD - relative to cwd
    la a1, filename
    li a2, 0 # read only flag
    li a3, 0 # mode not needed here
    ecall
    
    mv s0, a0
    
    # get file size
    li a1, 0 # offset
    li a2, 2 # go to end
    li a7, 62 # lseek syscall
    ecall

    mv s3, a0

    # set file pointer back to start
    mv a0, s0
    li a1, 0
    li a2, 0
    li a7, 62
    ecall

    addi s3, s3, -1 # n - 1
    mv s2, s3 
    mv s1, x0
    j loop

loop:
    bge s1, s2, success

    #  go to left
    mv a0, s0
    mv a1, s1
    li a2, 0
    li a7, 62
    ecall

    mv a0, s0
    la a1, char
    li a2, 1
    li a7, 63
    ecall
    la t2, char
    lb t0, 0(t2)

    # go to right
    mv a0, s0
    mv a1, s2
    li a2, 0
    li a7, 62
    ecall

    mv a0, s0
    la a1, char
    li a2, 1
    li a7, 63
    ecall
    la t2, char
    lb t1, 0(t2)

    addi s1, s1, 1
    addi s2, s2, -1

    bne t0, t1, fail

    j loop

success:
    la a0, yes
    call printf
    j exit

fail:
    la a0, no
    call printf
    j exit

exit:
    ld ra, 0(sp)
    ld s0, 8(sp) # file descriptor
    ld s1, 16(sp) # left
    ld s2, 24(sp) # right
    ld s3, 32(sp) # file size

    addi sp, sp, 48
    li a0, 0
    ret
