	.data
	.globl	c
c:
	.quad	_global_struct7166
	.data
	.globl	_global_struct7166
_global_struct7166:
	.quad	10
	.quad	20
	.quad	30
	.quad	rot
	.text
	.globl	rot
rot:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$8, %rsp
	movq	%rsp, %rsi
	subq	$8, %rsp
	movq	%rsp, %rdx
	movq	%rdi, (%rsi)
	pushq	%rsi
	pushq	%rdx
	movq	$32, %rdi
	callq	oat_malloc
	popq	%rdx
	popq	%rsi
	movq	%rax, %rdi
	movq	%rdi, %rax
	movq	%rax, %rdi
	movq	(%rsi), %r8 
	movq	%r8 , %rax
	addq	$0, %rax
	addq	$8, %rax
	movq	%rax, %r8 
	movq	(%r8 ), %r8 
	movq	%rdi, %rax
	addq	$0, %rax
	addq	$0, %rax
	movq	%rax, %r9 
	movq	%r8 , (%r9 )
	movq	(%rsi), %r8 
	movq	%r8 , %rax
	addq	$0, %rax
	addq	$16, %rax
	movq	%rax, %r8 
	movq	(%r8 ), %r8 
	movq	%rdi, %rax
	addq	$0, %rax
	addq	$8, %rax
	movq	%rax, %r9 
	movq	%r8 , (%r9 )
	movq	(%rsi), %r8 
	movq	%r8 , %rax
	addq	$0, %rax
	addq	$0, %rax
	movq	%rax, %r8 
	movq	(%r8 ), %r8 
	movq	%rdi, %rax
	addq	$0, %rax
	addq	$16, %rax
	movq	%rax, %r9 
	movq	%r8 , (%r9 )
	movq	(%rsi), %rsi
	movq	%rsi, %rax
	addq	$0, %rax
	addq	$24, %rax
	movq	%rax, %rsi
	movq	(%rsi), %rsi
	movq	%rdi, %rax
	addq	$0, %rax
	addq	$24, %rax
	movq	%rax, %r8 
	movq	%rsi, (%r8 )
	movq	%rdi, (%rdx)
	movq	(%rdx), %rdi
	movq	%rdi, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	program
program:
	pushq	%rbp
	movq	%rsp, %rbp
	leaq	c(%rip), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	movq	%rdi, %rax
	addq	$0, %rax
	addq	$24, %rax
	movq	%rax, %rdi
	movq	(%rdi), %rdi
	leaq	c(%rip), %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
	pushq	%r15
	movq	%rdi, %r15
	pushq	%rsi
	movq	%rsi, %rdi
	callq	*%r15
	popq	%rsi
	popq	%r15
	movq	%rax, %rdi
	movq	%rdi, %rax
	addq	$0, %rax
	addq	$0, %rax
	movq	%rax, %rdi
	movq	(%rdi), %rdi
	movq	%rdi, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	