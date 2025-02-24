	.text
	.globl	program
program:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$8, %rsp
	movq	%rsp, %rdx
	subq	$8, %rsp
	movq	%rsp, %rsi
	pushq	%rsi
	pushq	%rdx
	movq	$2, %rdi
	callq	oat_alloc_array
	popq	%rdx
	popq	%rsi
	movq	%rax, %rdi
	movq	%rdi, %rax
	movq	%rax, %r8 
	movq	%r8 , %rax
	addq	$0, %rax
	addq	$8, %rax
	addq	$0, %rax
	movq	%rax, %rdi
	movq	$1, %rax
	movq	%rdi, %rcx
	movq	%rax, (%rcx)
	movq	%r8 , %rax
	addq	$0, %rax
	addq	$8, %rax
	addq	$8, %rax
	movq	%rax, %rdi
	movq	$0, %rax
	movq	%rdi, %rcx
	movq	%rax, (%rcx)
	movq	%r8 , (%rdx)
	movq	$0, %rax
	movq	%rsi, %rcx
	movq	%rax, (%rcx)
	movq	(%rdx), %rdi
	movq	%rdi, %rax
	movq	%rax, %rdx
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	$0, %rsi
	movq	%rdx, %rdi
	callq	oat_assert_array_length
	popq	%rdx
	popq	%rsi
	popq	%rdi
	movq	%rdi, %rax
	addq	$0, %rax
	addq	$8, %rax
	addq	$0, %rax
	movq	%rax, %rdx
	movq	(%rdx), %rdi
	cmpq	$0, %rdi
	jne	_then25
	jmp	_else24
	.text
_else24:
	jmp	_merge23
	.text
_merge23:
	movq	(%rsi), %rdx
	movq	%rdx, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
_then25:
	movq	$1, %rax
	movq	%rsi, %rcx
	movq	%rax, (%rcx)
	jmp	_merge23