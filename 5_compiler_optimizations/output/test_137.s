	.text
	.globl	program
program:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$8, %rsp
	movq	%rsp, %rsi
	pushq	%rsi
	movq	$3, %rdi
	callq	oat_alloc_array
	popq	%rsi
	movq	%rax, %rdi
	movq	%rdi, %rax
	movq	%rax, %r8 
	subq	$8, %rsp
	movq	%rsp, %rdx
	movq	$3, %rax
	movq	%rdx, %rcx
	movq	%rax, (%rcx)
	subq	$8, %rsp
	movq	%rsp, %rdi
	movq	%r8 , (%rdi)
	movq	$0, %rax
	movq	%rsi, %rcx
	movq	%rax, (%rcx)
	jmp	_cond254
	.text
_body253:
	movq	(%rdi), %r10
	movq	(%rsi), %r9 
	movq	%r10, %rax
	movq	%rax, %r8 
	pushq	%r10
	pushq	%r9 
	pushq	%r8 
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	%r9 , %rsi
	movq	%r8 , %rdi
	callq	oat_assert_array_length
	popq	%rdx
	popq	%rsi
	popq	%rdi
	popq	%r8 
	popq	%r9 
	popq	%r10
	movq	%r10, %rax
	addq	$0, %rax
	addq	$8, %rax
	movq	%rax, %rcx
	movq	%r9 , %rax
	imulq	$8, %rax
	addq	%rcx, %rax
	movq	%rax, %r8 
	movq	$0, %rax
	movq	%r8 , %rcx
	movq	%rax, (%rcx)
	movq	(%rsi), %r8 
	addq	$1, %r8 
	movq	%r8 , (%rsi)
	jmp	_cond254
	.text
_cond254:
	movq	(%rsi), %r8 
	movq	(%rdx), %r9 
	cmpq	%r9 , %r8 
	setl	%r8b
	andq	$1, %r8 
	cmpq	$0, %r8 
	jne	_body253
	jmp	_post252
	.text
_post252:
	movq	$0, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	