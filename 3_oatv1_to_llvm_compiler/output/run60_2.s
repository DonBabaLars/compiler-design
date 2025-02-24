	.data
	.globl	i
i:
	.quad	3
	.text
	.globl	program
program:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$64, %rsp
	movq	%rdi, %rax
	movq	%rax, -8(%rbp)
	movq	%rsi, %rax
	movq	%rax, -16(%rbp)
	pushq	$0
	movq	%rsp, -24(%rbp)
	movq	-8(%rbp), %rcx
	movq	-24(%rbp), %rax
	movq	%rcx, (%rax)
	pushq	$0
	movq	%rsp, -40(%rbp)
	movq	-16(%rbp), %rcx
	movq	-40(%rbp), %rax
	movq	%rcx, (%rax)
	movq	$42, %rax
	movq	%rax, i(%rip)
	leaq	i(%rip), %rax
	movq	(%rax), %rcx
	movq	%rcx, -64(%rbp)
	movq	-64(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	