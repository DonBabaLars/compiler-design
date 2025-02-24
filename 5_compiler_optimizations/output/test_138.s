	.text
	.globl	program
program:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$8, %rsp
	movq	%rsp, %r9 
	subq	$8, %rsp
	movq	%rsp, %rdi
	movq	$9, %rax
	movq	%r9 , %rcx
	movq	%rax, (%rcx)
	movq	(%r9 ), %rdx
	movq	(%r9 ), %rsi
	addq	%rdx, %rsi
	movq	%rsi, (%rdi)
	movq	(%r9 ), %r8 
	movq	(%r9 ), %rdx
	movq	(%r9 ), %rsi
	imulq	%rdx, %rsi
	addq	%r8 , %rsi
	movq	(%rdi), %rdi
	movq	%rsi, %rax
	subq	%rdi, %rax
	movq	%rax, %rdi
	movq	%rdi, %rax
	movq	$2, %rcx
	shrq	%cl, %rax
	movq	%rax, %rdi
	movq	%rdi, %rax
	movq	$2, %rcx
	shlq	%cl, %rax
	movq	%rax, %rdi
	movq	%rdi, %rax
	movq	$2, %rcx
	sarq	%cl, %rax
	movq	%rax, %rdi
	movq	%rdi, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	