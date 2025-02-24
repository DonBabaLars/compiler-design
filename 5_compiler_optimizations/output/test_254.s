	.text
	.globl	f
f:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	movq	%rcx, %r11
	movq	%r8 , -16(%rbp)
	movq	%r9 , %r8 
	movq	16(%rbp), %r9 
	pushq	24(%rbp)
	popq	16(%rbp)
	subq	$8, %rsp
	movq	%rsp, %r8 
	subq	$8, %rsp
	movq	%rsp, %r9 
	subq	$8, %rsp
	movq	%rsp, 16(%rbp)
	subq	$8, %rsp
	movq	%rsp, -24(%rbp)
	subq	$8, %rsp
	movq	%rsp, -32(%rbp)
	movq	%rdi, (%r8 )
	movq	%rsi, (%r9 )
	movq	%rdx, %rax
	movq	16(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	%r11, %rax
	movq	-24(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	-16(%rbp), %rax
	movq	-32(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	(%r8 ), %rsi
	movq	(%r9 ), %rdi
	addq	%rdi, %rsi
	movq	16(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	addq	%rsi, %rdi
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
	addq	%rsi, %rdi
	movq	-32(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
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