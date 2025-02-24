	.text
	.globl	program
program:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$8, %rsp
	movq	%rsp, %rsi
	subq	$8, %rsp
	movq	%rsp, %rdi
	movq	$17, %rax
	movq	%rsi, %rcx
	movq	%rax, (%rcx)
	movq	$18, %rax
	movq	%rdi, %rcx
	movq	%rax, (%rcx)
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	addq	%rsi, %rdi
	movq	%rdi, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	