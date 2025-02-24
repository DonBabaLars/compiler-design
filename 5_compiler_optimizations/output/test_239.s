	.text
	.globl	program
program:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$8, %rsp
	movq	%rsp, %rdi
	movq	$99, %rax
	movq	%rdi, %rcx
	movq	%rax, (%rcx)
	movq	(%rdi), %rdi
	movq	%rdi, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	