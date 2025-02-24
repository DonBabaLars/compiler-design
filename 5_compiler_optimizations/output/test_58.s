	.text
	.globl	program
program:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$8, %rsp
	movq	%rsp, %rdi
	subq	$8, %rsp
	movq	%rsp, %rsi
	movq	$0, %rax
	movq	%rdi, %rcx
	movq	%rax, (%rcx)
	movq	$0, %rax
	movq	%rsi, %rcx
	movq	%rax, (%rcx)
	jmp	_cond15
	.text
_body14:
	movq	(%rdi), %rdx
	movq	(%rsi), %r8 
	addq	%rdx, %r8 
	movq	(%rsi), %rdx
	imulq	%r8 , %rdx
	movq	%rdx, (%rdi)
	movq	(%rsi), %rdx
	addq	$1, %rdx
	movq	%rdx, (%rsi)
	jmp	_cond15
	.text
_cond15:
	movq	(%rsi), %rdx
	cmpq	$10, %rdx
	setl	%dl
	andq	$1, %rdx
	cmpq	$0, %rdx
	jne	_body14
	jmp	_post13
	.text
_post13:
	movq	(%rdi), %rdi
	movq	%rdi, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	