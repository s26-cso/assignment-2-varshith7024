# struct Node
# int val = 4
# pointer left = 4
# pointer right = 4

# offsets
.equ val, 0 # 8 bytes as structs must be aligned with largest field so val + padding
.equ left, 8
.equ right, 16
.equ SIZE, 24 

.text
.global make_node
.global insert
.global get
.global getAtMost

make_node:
    addi sp, sp, -16 # has to be aligned
    sd ra, 8(sp)

    mv t1, a0

    li a0, SIZE
    call malloc

    mv t0, a0
    sw t1, val(t0)
    sd x0, left(t0)
    sd x0, right(t0)    

    mv a0, t0

    ld ra, 8(sp)
    addi sp, sp, 16
    ret

insert:
    # setup
    addi sp, sp, -32
    sd ra, 24(sp)
    sd s0, 16(sp)
    sd s1, 8(sp)

    # preserve og root
    mv s1, a0
    j insert_loop

insert_loop:
    # set new root
    mv s0, a0

    lw t0, val(a0)
    bge a1, t0, insert_right
    j insert_left

insert_right:
    ld t1, right(a0)
    bne t1, x0, traverse_right

    # create struct & insert
    mv a0, a1
    call make_node
    mv t0, a0
    mv a0, s0
    sd t0, right(a0)

    j insert_exit

insert_left:
    ld t1, left(a0)
    bne t1, x0, traverse_left

    # create struct & insert
    mv a0, a1
    call make_node
    mv t0, a0
    mv a0, s0
    sd t0, left(a0)

    j insert_exit

traverse_right:
    ld a0, right(a0)
    j insert_loop

traverse_left:
    ld a0, left(a0)
    j insert_loop

insert_exit:
    mv a0, s1
    ld ra, 24(sp)
    ld s0, 16(sp)
    ld s1, 8(sp)
    addi sp, sp, 32
    ret  

get:
    addi sp, sp, -16
    sd ra, 8(sp)

    j get_loop

get_loop:
    beq a0, x0, get_exit

    lw t0, val(a0)

    beq a1, t0, get_exit
    bge a1, t0, get_right
    j get_left

get_right:
    ld a0, right(a0)
    j get_loop

get_left:
    ld a0, left(a0)
    j get_loop

get_exit:
    ld ra, 8(sp)
    addi sp, sp, 16
    ret

# a0 - val
# a1 - root
# a2 - best possible value so far
getAtMost: 
    addi sp, sp, -16
    sd ra, 8(sp)
    li a2, -1

    j gam_loop

gam_loop:
    beq a1, x0, gam_exit

    lw t0, val(a1) 
    bgt t0, a0, gam_left
    blt t0, a0, gam_right
    # only equal remaining
    mv a2, t0
    j gam_exit

gam_left:
    ld a1, left(a1)
    j gam_loop

gam_right:
    mv a2, t0
    ld a1, right(a1)
    j gam_loop

gam_exit:
    mv a0, a2
    ld ra, 8(sp)
    addi sp, sp, 16
    ret
