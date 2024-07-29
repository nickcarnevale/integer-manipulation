# Nicholas Carnevale
# 10/14/2023
# Prog2 CSE202

.global sum
sum:
    # pointer to list in %rdi
    pushq %rbp           	# push bp
    movq %rsp, %rbp      	# set stack pointer
    movq %rdi, -24(%rbp) 	# store the pointer to list in -24(%rbp)
    movq $0, -8(%rbp)    	# init sum to 0
    movq -24(%rbp), %rax 	# copy list pointer to -16(%rbp) to preserve the original pointer
    movq %rax, -16(%rbp)
    jmp .L2              	# start loop
.L3:
    movq -16(%rbp), %rax 	# load the current pointer to list from -16(%rbp) into %rax
    movq 8(%rax), %rax   	# load the value at the current pointer (8 bytes offset) and add it to the sum
    addq %rax, -8(%rbp)
    movq -16(%rbp), %rax 	# move to the next element in the list by updating the pointer (16 bytes offset)
    movq 16(%rax), %rax
    movq %rax, -16(%rbp)
.L2:
    cmpq $0, -16(%rbp)   	# compare the current pointer (in -16(%rbp)) with 0 to check if we reached the end of the list
    jne .L3              	# if the pointer is not 0 (i.e., we haven't reached the end), continue the loop (.L3)
    movq -8(%rbp), %rax  	# load the final sum value from -8(%rbp) into %rax
    popq %rbp            	# clean up the stack frame and return
    ret


# sum of the elements of a linkedlist in C
# long sum(struct ll *list){
#    long total = 0;
#    struct ll *ptr = list;
#    while(ptr){
#        total += ptr->value;
#        ptr = ptr->next;
#    }
#    return total;
# }
