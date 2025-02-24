	.text
	.globl	f
f:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rcx, %r11
	pushq	24(%rbp)
	popq	-16(%rbp)
	subq	$8, %rsp
	movq	%rsp, %r9 
	subq	$8, %rsp
	movq	%rsp, %r8 
	subq	$8, %rsp
	movq	%rsp, %r11
	movq	%rdi, (%r9 )
	movq	%rsi, (%r8 )
	movq	%rdx, (%r11)
	movq	(%r9 ), %rsi
	movq	(%r8 ), %rdi
	addq	%rdi, %rsi
	movq	(%r11), %rdi
	addq	%rsi, %rdi
	movq	%rdi, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	program
program:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	$-3
	pushq	$-4
	movq	$-5, %r9 
	movq	$5, %r8 
	movq	$4, %rcx
	movq	$3, %rdx
	movq	$2, %rsi
	movq	$1, %rdi
	callq	f
	addq	$16, %rsp
	movq	%rax, %rdi
	movq	%rdi, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	