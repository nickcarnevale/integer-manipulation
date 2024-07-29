# Nicholas Carnevale
# 10/14/2023
# Prog2 CSE202

.global product
product:
    # a in %rdi, b in %rsi, c in %rdx, size in %ecx
	pushq	%rbp				# push bp
	movq	%rsp, %rbp			# set stack pointer
	movq	%rdi, -24(%rbp)		# store a in -24(%rbp)
	movq	%rsi, -32(%rbp)		# store b in -32(%rbp)
	movq	%rdx, -40(%rbp)		# store c in -40(%rbp)
	movl	%ecx, -44(%rbp)		# store size in -44(%rbp)
	movl	$0, -4(%rbp)		# init i to 0
	jmp	.L2						# start the loop
.L3:
	movl	-4(%rbp), %eax		# load i into %eax
	leaq	(,%rax,4), %rdx		# calculate the offset for array indexing (i * 4 bytes)
	movq	-24(%rbp), %rax		# load the address of array a
	addq	%rdx, %rax			# add the offset to the address of a
	movss	(%rax), %xmm1		# load the value from array a into xmm1
	movl	-4(%rbp), %eax		# load i back into %eax 
	leaq	(,%rax,4), %rdx		# calculate the offset for array indexing (i * 4 bytes)
	movq	-32(%rbp), %rax		# load the address of array b
	addq	%rdx, %rax			# add the offset to the address of b
	movss	(%rax), %xmm0		# load the value from array b into xmm0
	movl	-4(%rbp), %eax		# load i back into %eax 
	leaq	(,%rax,4), %rdx		# calculate the offset for array indexing (i * 4 bytes)
	movq	-40(%rbp), %rax		# load the address of array c
	addq	%rdx, %rax			# add the offset to the address of c
	mulss	%xmm1, %xmm0		# multiply the values in xmm1 and xmm0
	movss	%xmm0, (%rax)		# store the result in array c
	addl	$1, -4(%rbp)		# increment i by 1
.L2:
	movl	-4(%rbp), %eax		# load i back into %eax 
	cmpl	-44(%rbp), %eax		# compare i with size
	jb	.L3						# if i < size, go to .L3
	popq	%rbp				# restore the base pointer
	ret							# return


# Product of two vectors in C
# void product(float *a, float *b, float *c, unsigned size){
#    for(unsigned i=0; i<size; i++){
#        c[i] = a[i] * b[i];
#    }
# }
