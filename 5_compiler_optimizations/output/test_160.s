	.text
	.globl	program
program:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	subq	$8, %rsp
	movq	%rsp, %rsi
	subq	$8, %rsp
	movq	%rsp, %r9 
	subq	$8, %rsp
	movq	%rsp, -8(%rbp)
	pushq	%r9 
	pushq	%rsi
	movq	$3, %rdi
	callq	oat_alloc_array
	popq	%rsi
	popq	%r9 
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
	jmp	_cond1788
	.text
_body1787:
	movq	(%rdi), %r11
	movq	(%rsi), %r10
	movq	%r11, %rax
	movq	%rax, -16(%rbp)
	pushq	%r11
	pushq	%r10
	pushq	%r9 
	pushq	%r8 
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	%r10, %rsi
	movq	-16(%rbp), %rdi
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
	movq	%rax, %r10
	movq	$110, %rax
	movq	%r10, %rcx
	movq	%rax, (%rcx)
	movq	(%rsi), %r10
	addq	$1, %r10
	movq	%r10, (%rsi)
	jmp	_cond1788
	.text
_cond1788:
	movq	(%rsi), %r10
	movq	(%rdx), %r11
	cmpq	%r11, %r10
	setl	%r10b
	andq	$1, %r10
	cmpq	$0, %r10
	jne	_body1787
	jmp	_post1786
	.text
_post1786:
	movq	%r8 , (%r9 )
	movq	(%r9 ), %rdi
	callq	string_of_array
	movq	%rax, %rdi
	movq	%rdi, %rax
	movq	-8(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	-8(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	pushq	%rdi
	callq	print_string
	popq	%rdi
	movq	$0, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	