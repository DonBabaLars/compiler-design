	.text
	.globl	program
program:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$8, %rsp
	subq	$8, %rsp
	movq	%rsp, %rsi
	subq	$8, %rsp
	movq	%rsp, -8(%rbp)
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
	jmp	_cond7277
	.text
_body7276:
	movq	(%rdi), %r11
	movq	(%rsi), %r10
	movq	%r11, %rax
	movq	%rax, %r9 
	pushq	%r11
	pushq	%r10
	pushq	%r9 
	pushq	%r8 
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	%r10, %rsi
	movq	%r9 , %rdi
	callq	oat_assert_array_length
	popq	%rdx
	popq	%rsi
	popq	%rdi
	popq	%r8 
	popq	%r9 
	popq	%r10
	popq	%r11
	movq	%r11, %rax
	addq	$0, %rax
	addq	$8, %rax
	movq	%rax, %rcx
	movq	%r10, %rax
	imulq	$8, %rax
	addq	%rcx, %rax
	movq	%rax, %r9 
	movq	$0, %rax
	movq	%r9 , %rcx
	movq	%rax, (%rcx)
	movq	(%rsi), %r9 
	addq	$1, %r9 
	movq	%r9 , (%rsi)
	jmp	_cond7277
	.text
_cond7277:
	movq	(%rsi), %r9 
	movq	(%rdx), %r10
	cmpq	%r10, %r9 
	setl	%r9b
	andq	$1, %r9 
	cmpq	$0, %r9 
	jne	_body7276
	jmp	_post7275
	.text
_post7275:
	movq	%r8 , %rax
	movq	-8(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	-8(%rbp), %rax
	movq	(%rax), %rax
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