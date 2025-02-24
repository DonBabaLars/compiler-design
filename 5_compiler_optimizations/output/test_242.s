	.data
	.globl	i
i:
	.quad	9
	.text
	.globl	program
program:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$8, %rsp
	movq	%rsp, %rdi
	leaq	i(%rip), %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
	movq	%rsi, (%rdi)
	movq	(%rdi), %rdi
	movq	%rdi, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	