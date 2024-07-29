# Nicholas Carnevale
# 10/14/2023
# Prog2 CSE202

.global quadratic
quadratic:
    pushq %rbp                  # push bp
    movq %rsp, %rbp             # set stack pointer
    subq $48, %rsp              # allocate space on the stack
    movl %edi, -20(%rbp)        # store a in -20(%rbp)
    movl %esi, -24(%rbp)        # store b in -24(%rbp)
    movl %edx, -28(%rbp)        # store c in -28(%rbp)
    movq %rcx, -40(%rbp)        # store x1 in -40(%rbp)
    movq %r8, -48(%rbp)         # store x2 in -48(%rbp)
    movl -24(%rbp), %eax        # load b
    imull -24(%rbp), %eax       # multiply b by b
    movl %eax, %edx             # copy the result to edx
    movl -20(%rbp), %eax        # load a
    sall $2, %eax               # shift left by 2 bits (multiply by 4)
    imull -28(%rbp), %eax       # multiply by c
    subl %eax, %edx             # subtract the result from the previous calculation
    movl %edx, %eax             # copy the result to eax
    movl %eax, -4(%rbp)         # store the discriminant in -4(%rbp)
    cmpl $0, -4(%rbp)           # compare the discriminant with 0
    jns .L2                     # if it's non-negative, jump to .L2 (no negative roots)
    movl $-1, %eax              # set return value to -1
    jmp .L3                     # jump to .L3 (end of the function)
.L2:
    cmpl $0, -4(%rbp)           # compare the discriminant with 0 again
    jne .L4                     # if it's not zero, jump to .L4 (two distinct roots)
    movl -24(%rbp), %eax        # load b
    negl %eax                   # negate b
    movl -20(%rbp), %edx        # load a
    leal (%rdx,%rdx), %ecx      # compute 2 * a
    cltd                        # sign-extend %eax into %edx:%eax
    idivl %ecx                  # divide -b by 2 * a
    movl %eax, %edx             # copy the result to edx
    movq -40(%rbp), %rax        # load the address of x1
    movl %edx, (%rax)           # store x1
    movl $0, %eax               # set return value to 0
    jmp .L3                     # jump to .L3 (end of the function)
.L4:
    movl -4(%rbp), %eax         # load the discriminant
    movl %eax, %edi             # pass it as an argument to the r_sqrt function
    call r_sqrt                 # call the r_sqrt function
    movl %eax, -8(%rbp)         # store the result of r_sqrt in -8(%rbp)
    movl -24(%rbp), %eax        # load b
    negl %eax                   # negate b
    subl -8(%rbp), %eax         # subtract the result of r_sqrt from -b
    movl -20(%rbp), %edx        # load a
    leal (%rdx,%rdx), %esi      # compute 2 * a
    cltd                        # sign-extend %eax into %edx:%eax
    idivl %esi                  # divide the previous result by 2 * a
    movl %eax, %edx             # copy the result to edx
    movq -48(%rbp), %rax        # load the address of x2
    movl %edx, (%rax)           # store x2
    movl -8(%rbp), %eax         # load the result of r_sqrt
    subl -24(%rbp), %eax        # subtract it from -b
    movl -20(%rbp), %edx        # load a
    leal (%rdx,%rdx), %edi      # compute 2 * a
    cltd                        # sign-extend %eax into %edx:%eax
    idivl %edi                  # divide the previous result by 2 * a
    movl %eax, %edx             # copy the result to edx
    movq -40(%rbp), %rax        # load the address of x1
    movl %edx, (%rax)           # store x1
    movl $1, %eax               # set return value to 1
.L3:
    leave                       # restore the stack frame
    ret                         # return

r_sqrt:
    pushq %rbp                  # save bp
    movq %rsp, %rbp             # set the stack pointer
    subq $32, %rsp              # allocate space on the stack
    movl %edi, -20(%rbp)        # store x in -20(%rbp)
    cmpl $0, -20(%rbp)          # compare x with 0
    jns .L6                     # if it's non-negative, go to .L6 (positive or zero root)
    movl $-1, %eax              # set return value to -1
    jmp .L7                     # jump to .L7 (end of the function)
.L6:
    cmpl $1, -20(%rbp)          # compare x with 1
    jg .L8                      # if it's greater than 1, go to .L8 (more than one root)
    movl -20(%rbp), %eax        # load x
    jmp .L7                     # return
.L8:
    movl -20(%rbp), %eax        # load x
    sarl $2, %eax               # shift right by 2 bits (divide by 4)
    movl %eax, %edi             # pass the result as an argument to r_sqrt
    call r_sqrt                 # call r_sqrt recursively
    addl %eax, %eax             # double the result of the recursive call
    movl %eax, -4(%rbp)         # store the result in -4(%rbp)
    movl -4(%rbp), %eax         # load the result
    addl $1, %eax               # increment the result by 1
    movl %eax, -8(%rbp)         # store the incremented result in -8(%rbp)
    movl -8(%rbp), %eax         # load the incremented result
    imull -8(%rbp), %eax        # multiply it by itself
    cmpl %eax, -20(%rbp)        # compare the result with x
    jge .L9                     # if it's greater or equal, go to .L9 (end of the function)
    movl -4(%rbp), %eax         # load the result
    jmp .L7                     # jump to .L7 (end of the function)
.L9:
    movl -8(%rbp), %eax         # load the incremented result
.L7:
    leave                       # restore the stack frame
    ret                         # return



# find the solutions of a quadratic equation in C
# int quadratic(int a, int b, int c, int *x1, int *x2){
#    int d = (b * b) - 4 * a * c; //discriminant
#    if(d < 0)
#        return -1;
#    if(d == 0){
#        *x1 = -b / (2 * a);
#        return 0;
#    }
#    int rd = r_sqrt(d);
#    *x1 = (-b - rd) / (2 * a);
#    *x2 = (-b + rd) / (2 * a);
#    return 1;
# }

# calculate recursively the square root of an int (in C) 
# int r_sqrt(int x){
#    if(x < 0)
#        return -1;
#    if (x < 2)
#        return x;
#   /* recursive call */
#    int small_cand = r_sqrt(x >> 2) << 1;
#    int large_cand = small_cand + 1;
#    if (large_cand * large_cand > x)
#        return small_cand;
#    else
#        return large_cand;
# }
