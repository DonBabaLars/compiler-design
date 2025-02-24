	.data
	.globl	i
i:
	.quad	11
	.text
	.globl	f
f:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$8, %rsp
	movq	%rsp, %rdx
	movq	$12, %rax
	movq	%rdx, %rcx
	movq	%rax, (%rcx)
	movq	(%rdx), %rdx
	movq	%rdx, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	g
g:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$8, %rsp
	movq	%rsp, %rdx
	movq	$10, %rax
	movq	%rdx, %rcx
	movq	%rax, (%rcx)
	movq	(%rdx), %rdx
	movq	%rdx, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	program
program:
	pushq	%rbp
	movq	%rsp, %rbp
	callq	f
	movq	%rax, %rsi
	pushq	%rsi
	callq	g
	popq	%rsi
	movq	%rax, %rdi
	addq	%rdi, %rsi
	leaq	i(%rip), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	addq	%rsi, %rdi
	movq	%rdi, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	