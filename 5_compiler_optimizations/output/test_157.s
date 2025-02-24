	.text
	.globl	program
program:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$96, %rsp
	subq	$8, %rsp
	movq	%rsp, -8(%rbp)
	subq	$8, %rsp
	movq	%rsp, -16(%rbp)
	subq	$8, %rsp
	movq	%rsp, -24(%rbp)
	subq	$8, %rsp
	movq	%rsp, %r10
	subq	$8, %rsp
	movq	%rsp, %rdx
	movq	$10, %rax
	movq	-8(%rbp), %rcx
	movq	%rax, (%rcx)
	pushq	%r10
	pushq	%rdx
	movq	$3, %rdi
	callq	oat_alloc_array
	popq	%rdx
	popq	%r10
	movq	%rax, %rdi
	movq	%rdi, %rax
	movq	%rax, %r9 
	subq	$8, %rsp
	movq	%rsp, %rsi
	movq	$3, %rax
	movq	%rsi, %rcx
	movq	%rax, (%rcx)
	subq	$8, %rsp
	movq	%rsp, -32(%rbp)
	movq	%r9 , %rax
	movq	-32(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	$0, %rax
	movq	-16(%rbp), %rcx
	movq	%rax, (%rcx)
	jmp	_cond1649
	.text
_body1648:
	movq	-32(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	movq	-16(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r11
	movq	%rdi, %rax
	movq	%rax, %r8 
	pushq	%r11
	pushq	%r10
	pushq	%r9 
	pushq	%r8 
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	%r11, %rsi
	movq	%r8 , %rdi
	callq	oat_assert_array_length
	popq	%rdx
	popq	%rsi
	popq	%rdi
	popq	%r8 
	popq	%r9 
	popq	%r10
	popq	%r11
	movq	%rdi, %rax
	addq	$0, %rax
	addq	$8, %rax
	movq	%rax, %rcx
	movq	%r11, %rax
	imulq	$8, %rax
	addq	%rcx, %rax
	movq	%rax, -40(%rbp)
	pushq	%r10
	pushq	%r9 
	pushq	%rsi
	pushq	%rdx
	movq	$3, %rdi
	callq	oat_alloc_array
	popq	%rdx
	popq	%rsi
	popq	%r9 
	popq	%r10
	movq	%rax, %rdi
	movq	%rdi, %rax
	movq	%rax, %r8 
	subq	$8, %rsp
	movq	%rsp, %rdi
	movq	$3, %rax
	movq	%rdi, %rcx
	movq	%rax, (%rcx)
	subq	$8, %rsp
	movq	%rsp, -48(%rbp)
	movq	%r8 , %rax
	movq	-48(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	$0, %rax
	movq	-24(%rbp), %rcx
	movq	%rax, (%rcx)
	jmp	_cond1666
	.text
_body1665:
	movq	-48(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r11
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -56(%rbp)
	movq	%r11, %rax
	movq	%rax, -64(%rbp)
	pushq	%r11
	pushq	%r10
	pushq	%r9 
	pushq	%r8 
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	-56(%rbp), %rsi
	movq	-64(%rbp), %rdi
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
	movq	-56(%rbp), %rax
	imulq	$8, %rax
	addq	%rcx, %rax
	movq	%rax, -72(%rbp)
	movq	-8(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r11
	movq	-16(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	addq	-80(%rbp), %r11
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	addq	-88(%rbp), %r11
	movq	%r11, %rax
	movq	-72(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r11
	addq	$1, %r11
	movq	%r11, %rax
	movq	-24(%rbp), %rcx
	movq	%rax, (%rcx)
	jmp	_cond1666
	.text
_cond1649:
	movq	-16(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r8 
	movq	(%rsi), %rdi
	cmpq	%rdi, %r8 
	setl	%dil
	andq	$1, %rdi
	cmpq	$0, %rdi
	jne	_body1648
	jmp	_post1647
	.text
_cond1666:
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%rdi), %r11
	movq	-96(%rbp), %rax
	cmpq	%r11, %rax
	setl	%r11b
	andq	$1, %r11
	cmpq	$0, %r11
	jne	_body1665
	jmp	_post1664
	.text
_post1647:
	movq	%r9 , (%r10)
	movq	(%r10), %rdi
	movq	%rdi, (%rdx)
	movq	(%rdx), %rdi
	movq	%rdi, %rax
	movq	%rax, %rsi
	pushq	%rdi
	pushq	%rsi
	movq	%rsi, %rdi
	movq	$2, %rsi
	callq	oat_assert_array_length
	popq	%rsi
	popq	%rdi
	movq	%rdi, %rax
	addq	$0, %rax
	addq	$8, %rax
	addq	$16, %rax
	movq	%rax, %rdi
	movq	(%rdi), %rsi
	movq	%rsi, %rax
	movq	%rax, %rdi
	pushq	%rdi
	pushq	%rsi
	movq	$1, %rsi
	callq	oat_assert_array_length
	popq	%rsi
	popq	%rdi
	movq	%rsi, %rax
	addq	$0, %rax
	addq	$8, %rax
	addq	$8, %rax
	movq	%rax, %rdi
	movq	(%rdi), %rdi
	movq	%rdi, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
_post1664:
	movq	%r8 , %rax
	movq	-40(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	-16(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	addq	$1, %rdi
	movq	%rdi, %rax
	movq	-16(%rbp), %rcx
	movq	%rax, (%rcx)
	jmp	_cond1649