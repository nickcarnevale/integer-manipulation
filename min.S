# Nicholas Carnevale
# 10/14/2023
# Prog2 CSE202

.global min
min:
    # list in %rdi, n in %esi
    pushq %rbp           	# push bp
    movq %rsp, %rbp      	# set the stack pointer
    movq %rdi, -24(%rbp) 	# store list address in -24(%rbp)
    movl %esi, -28(%rbp) 	# store n in -28(%rbp)
    movl $0, -4(%rbp)    	# init i (loop counter) to 0
    movl -4(%rbp), %eax  	# load i into %eax
    leaq (%rax,%rax), %rdx 	# calculate the offset for array indexing (i * 2 bytes)
    movq -24(%rbp), %rax   	# load the address of the list
    addq %rdx, %rax       	# add the offset to the address of the list
    movzwl (%rax), %eax    	# load the value from the list into %eax (zero extend)
    movw %ax, -6(%rbp)    	# store the loaded value as the current minimum
    jmp .L2               	# start the loop
.L4:
    movl -4(%rbp), %eax   	# load i into %eax
    leaq (%rax,%rax), %rdx 	# calculate the offset for array indexing (i * 2 bytes)
    movq -24(%rbp), %rax   	# load the address of the list
    addq %rdx, %rax       	# add the offset to the address of the list
    movzwl (%rax), %eax    	# load the value from the list into %eax (zero extend)
    cmpw %ax, -6(%rbp)    	# compare the loaded value with the current minimum
    jle .L3               	# if less or equal, go to .L3
    movl -4(%rbp), %eax   	# load i into %eax
    leaq (%rax,%rax), %rdx 	# calculate the offset for array indexing (i * 2 bytes)
    movq -24(%rbp), %rax   	# load the address of the list
    addq %rdx, %rax       	# add the offset to the address of the list
    movzwl (%rax), %eax    	# load the value from the list into %eax (zero extend)
    movw %ax, -6(%rbp)    	# store the loaded value as the new minimum
.L3:
    addl $1, -4(%rbp)     	# increment i by 1
.L2:
    movl -4(%rbp), %eax   	# load i into %eax
    cmpl -28(%rbp), %eax  	# compare i with n
    jb .L4                	# if less, go to .L4
    movzwl -6(%rbp), %eax 	# load the final minimum value into %eax
    popq %rbp             	# restore the base pointer
    ret


# short min(short *list, unsigned n){
#     unsigned i = 0;
#     short min = list[i];
#     while (i < n){
#         if(list[i] < min)
#             min = list[i];
#         i++;
#     }
#     return min;
# }

