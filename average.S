# Nicholas Carnevale
# 10/14/2023
# Prog2 CSE202

.global average
average:
    # a in %rdi, b in %rsi, *cptr in %rdx
    movl %edi, %eax     # move a to %eax
    addl %esi, %eax     # add b to %eax, calculating the sum  
    cmpq %rdi, %rax     # compare the sum in %eax with a 
    jae .L3             # jump to .L3 if sum >= a (overflow condition)
    movq $1, (%rdx)     # if the jump condition is not met (no overflow), set *cptr to 1
    jmp .L2             # jump to .L2 to skip setting *cptr to 0
.L3:
    movq $0, (%rdx)     # if there's overflow (sum >= a), set *cptr to 0
.L2:
    shrq $1, %rax       # shift right by 1 (divide by 2) to calculate the average
    ret                 # return


# average of two unsigned integers
# unsigned average(unsigned a, unsigned b, char* cptr){
#    int sum = a + b;
#    if(sum < a)
#       *cptr = 1;
#    else
#       *cptr = 0;
#    return sum/2;
# }
