	.text
	.globl	getminindex
getminindex:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$48, %rsp
	movq	%rsi, -16(%rbp)
	movq	%rdx, %rsi
	subq	$8, %rsp
	movq	%rsp, %r11
	subq	$8, %rsp
	movq	%rsp, -24(%rbp)
	subq	$8, %rsp
	movq	%rsp, %r10
	subq	$8, %rsp
	movq	%rsp, %r9 
	subq	$8, %rsp
	movq	%rsp, %rdx
	subq	$8, %rsp
	movq	%rsp, %r8 
	movq	%rdi, (%r11)
	movq	-16(%rbp), %rax
	movq	-24(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	%rsi, (%r10)
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	movq	%rdi, (%r9 )
	movq	(%r11), %rdi
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rbp)
	movq	%rdi, %rax
	movq	%rax, %rsi
	pushq	%r11
	pushq	%r10
	pushq	%r9 
	pushq	%r8 
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	%rsi, %rdi
	movq	-32(%rbp), %rsi
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
	movq	-32(%rbp), %rax
	imulq	$8, %rax
	addq	%rcx, %rax
	movq	%rax, %rdi
	movq	(%rdi), %rdi
	movq	%rdi, (%rdx)
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	movq	%rdi, (%r8 )
	jmp	_cond3610
	.text
_body3609:
	movq	(%r11), %rsi
	movq	(%r9 ), %rdi
	movq	%rsi, %rax
	movq	%rax, -40(%rbp)
	pushq	%r11
	pushq	%r10
	pushq	%r9 
	pushq	%r8 
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	%rdi, %rsi
	movq	-40(%rbp), %rdi
	callq	oat_assert_array_length
	popq	%rdx
	popq	%rsi
	popq	%rdi
	popq	%r8 
	popq	%r9 
	popq	%r10
	popq	%r11
	movq	%rsi, %rax
	addq	$0, %rax
	addq	$8, %rax
	movq	%rax, %rcx
	movq	%rdi, %rax
	imulq	$8, %rax
	addq	%rcx, %rax
	movq	%rax, %rdi
	movq	(%rdi), %rsi
	movq	(%rdx), %rdi
	cmpq	%rdi, %rsi
	setl	%dil
	andq	$1, %rdi
	cmpq	$0, %rdi
	jne	_then3630
	jmp	_else3629
	.text
_cond3610:
	movq	(%r9 ), %rdi
	movq	(%r10), %rsi
	cmpq	%rsi, %rdi
	setl	%dil
	andq	$1, %rdi
	cmpq	$0, %rdi
	jne	_body3609
	jmp	_post3608
	.text
_else3629:
	jmp	_merge3628
	.text
_merge3628:
	movq	(%r9 ), %rdi
	addq	$1, %rdi
	movq	%rdi, (%r9 )
	jmp	_cond3610
	.text
_post3608:
	movq	(%r8 ), %rdi
	movq	%rdi, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
_then3630:
	movq	(%r11), %rsi
	movq	(%r9 ), %rdi
	movq	%rsi, %rax
	movq	%rax, -48(%rbp)
	pushq	%r11
	pushq	%r10
	pushq	%r9 
	pushq	%r8 
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	%rdi, %rsi
	movq	-48(%rbp), %rdi
	callq	oat_assert_array_length
	popq	%rdx
	popq	%rsi
	popq	%rdi
	popq	%r8 
	popq	%r9 
	popq	%r10
	popq	%r11
	movq	%rsi, %rax
	addq	$0, %rax
	addq	$8, %rax
	movq	%rax, %rcx
	movq	%rdi, %rax
	imulq	$8, %rax
	addq	%rcx, %rax
	movq	%rax, %rdi
	movq	(%rdi), %rdi
	movq	%rdi, (%rdx)
	movq	(%r9 ), %rdi
	movq	%rdi, (%r8 )
	jmp	_merge3628
	.text
	.globl	selectionsort
selectionsort:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	subq	$8, %rsp
	movq	%rsp, %r10
	subq	$8, %rsp
	movq	%rsp, %rdx
	subq	$8, %rsp
	movq	%rsp, -8(%rbp)
	subq	$8, %rsp
	movq	%rsp, %r8 
	subq	$8, %rsp
	movq	%rsp, %r9 
	movq	%rdi, (%r10)
	movq	%rsi, (%rdx)
	movq	$0, %rax
	movq	-8(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	$0, %rax
	movq	%r8 , %rcx
	movq	%rax, (%rcx)
	movq	$0, %rax
	movq	%r9 , %rcx
	movq	%rax, (%rcx)
	jmp	_cond3547
	.text
_body3546:
	movq	(%rdx), %rdi
	movq	(%r9 ), %rsi
	movq	(%r10), %r11
	pushq	%r11
	pushq	%r10
	pushq	%r9 
	pushq	%r8 
	pushq	%rsi
	pushq	%rdx
	movq	%rdi, %rdx
	movq	%r11, %rdi
	callq	getminindex
	popq	%rdx
	popq	%rsi
	popq	%r8 
	popq	%r9 
	popq	%r10
	popq	%r11
	movq	%rax, %rdi
	movq	%rdi, (%r8 )
	movq	(%r10), %rsi
	movq	(%r9 ), %rdi
	movq	%rsi, %rax
	movq	%rax, %r11
	pushq	%r11
	pushq	%r10
	pushq	%r9 
	pushq	%r8 
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	%rdi, %rsi
	movq	%r11, %rdi
	callq	oat_assert_array_length
	popq	%rdx
	popq	%rsi
	popq	%rdi
	popq	%r8 
	popq	%r9 
	popq	%r10
	popq	%r11
	movq	%rsi, %rax
	addq	$0, %rax
	addq	$8, %rax
	movq	%rax, %rcx
	movq	%rdi, %rax
	imulq	$8, %rax
	addq	%rcx, %rax
	movq	%rax, %rdi
	movq	(%rdi), %rdi
	movq	%rdi, %rax
	movq	-8(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	(%r10), %rsi
	movq	(%r9 ), %rdi
	movq	%rsi, %rax
	movq	%rax, %r11
	pushq	%r11
	pushq	%r10
	pushq	%r9 
	pushq	%r8 
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	%rdi, %rsi
	movq	%r11, %rdi
	callq	oat_assert_array_length
	popq	%rdx
	popq	%rsi
	popq	%rdi
	popq	%r8 
	popq	%r9 
	popq	%r10
	popq	%r11
	movq	%rsi, %rax
	addq	$0, %rax
	addq	$8, %rax
	movq	%rax, %rcx
	movq	%rdi, %rax
	imulq	$8, %rax
	addq	%rcx, %rax
	movq	%rax, %rdi
	movq	(%r10), %r11
	movq	(%r8 ), %rsi
	movq	%r11, %rax
	movq	%rax, -16(%rbp)
	pushq	%r11
	pushq	%r10
	pushq	%r9 
	pushq	%r8 
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
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
	movq	%rsi, %rax
	imulq	$8, %rax
	addq	%rcx, %rax
	movq	%rax, %rsi
	movq	(%rsi), %rsi
	movq	%rsi, (%rdi)
	movq	(%r10), %rsi
	movq	(%r8 ), %rdi
	movq	%rsi, %rax
	movq	%rax, %r11
	pushq	%r11
	pushq	%r10
	pushq	%r9 
	pushq	%r8 
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	%rdi, %rsi
	movq	%r11, %rdi
	callq	oat_assert_array_length
	popq	%rdx
	popq	%rsi
	popq	%rdi
	popq	%r8 
	popq	%r9 
	popq	%r10
	popq	%r11
	movq	%rsi, %rax
	addq	$0, %rax
	addq	$8, %rax
	movq	%rax, %rcx
	movq	%rdi, %rax
	imulq	$8, %rax
	addq	%rcx, %rax
	movq	%rax, %rdi
	movq	-8(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
	movq	%rsi, (%rdi)
	movq	(%r9 ), %rdi
	addq	$1, %rdi
	movq	%rdi, (%r9 )
	jmp	_cond3547
	.text
_cond3547:
	movq	(%r9 ), %rsi
	movq	(%rdx), %rdi
	cmpq	%rdi, %rsi
	setl	%dil
	andq	$1, %rdi
	cmpq	$0, %rdi
	jne	_body3546
	jmp	_post3545
	.text
_post3545:
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	program
program:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$8, %rsp
	movq	%rsp, %rdx
	subq	$8, %rsp
	movq	%rsp, %rdi
	pushq	%rdi
	pushq	%rdx
	movq	$8, %rdi
	callq	oat_alloc_array
	popq	%rdx
	popq	%rdi
	movq	%rax, %rsi
	movq	%rsi, %rax
	movq	%rax, %rsi
	movq	%rsi, %rax
	addq	$0, %rax
	addq	$8, %rax
	addq	$0, %rax
	movq	%rax, %r8 
	movq	$5, %rax
	movq	%r8 , %rcx
	movq	%rax, (%rcx)
	movq	%rsi, %rax
	addq	$0, %rax
	addq	$8, %rax
	addq	$8, %rax
	movq	%rax, %r8 
	movq	$200, %rax
	movq	%r8 , %rcx
	movq	%rax, (%rcx)
	movq	%rsi, %rax
	addq	$0, %rax
	addq	$8, %rax
	addq	$16, %rax
	movq	%rax, %r8 
	movq	$1, %rax
	movq	%r8 , %rcx
	movq	%rax, (%rcx)
	movq	%rsi, %rax
	addq	$0, %rax
	addq	$8, %rax
	addq	$24, %rax
	movq	%rax, %r8 
	movq	$65, %rax
	movq	%r8 , %rcx
	movq	%rax, (%rcx)
	movq	%rsi, %rax
	addq	$0, %rax
	addq	$8, %rax
	addq	$32, %rax
	movq	%rax, %r8 
	movq	$30, %rax
	movq	%r8 , %rcx
	movq	%rax, (%rcx)
	movq	%rsi, %rax
	addq	$0, %rax
	addq	$8, %rax
	addq	$40, %rax
	movq	%rax, %r8 
	movq	$99, %rax
	movq	%r8 , %rcx
	movq	%rax, (%rcx)
	movq	%rsi, %rax
	addq	$0, %rax
	addq	$8, %rax
	addq	$48, %rax
	movq	%rax, %r8 
	movq	$2, %rax
	movq	%r8 , %rcx
	movq	%rax, (%rcx)
	movq	%rsi, %rax
	addq	$0, %rax
	addq	$8, %rax
	addq	$56, %rax
	movq	%rax, %r8 
	movq	$0, %rax
	movq	%r8 , %rcx
	movq	%rax, (%rcx)
	movq	%rsi, (%rdx)
	movq	(%rdx), %rsi
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	%rsi, %rdi
	movq	$8, %rsi
	callq	selectionsort
	popq	%rdx
	popq	%rsi
	popq	%rdi
	movq	$0, %rax
	movq	%rdi, %rcx
	movq	%rax, (%rcx)
	jmp	_cond3519
	.text
_body3518:
	movq	(%rdx), %r9 
	movq	(%rdi), %r8 
	movq	%r9 , %rax
	movq	%rax, %rsi
	pushq	%r9 
	pushq	%r8 
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	%rsi, %rdi
	movq	%r8 , %rsi
	callq	oat_assert_array_length
	popq	%rdx
	popq	%rsi
	popq	%rdi
	popq	%r8 
	popq	%r9 
	movq	%r9 , %rax
	addq	$0, %rax
	addq	$8, %rax
	movq	%rax, %rcx
	movq	%r8 , %rax
	imulq	$8, %rax
	addq	%rcx, %rax
	movq	%rax, %rsi
	movq	(%rsi), %rsi
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	%rsi, %rdi
	callq	print_int
	popq	%rdx
	popq	%rsi
	popq	%rdi
	movq	(%rdi), %rsi
	addq	$1, %rsi
	movq	%rsi, (%rdi)
	jmp	_cond3519
	.text
_cond3519:
	movq	(%rdi), %rsi
	cmpq	$8, %rsi
	setl	%sil
	andq	$1, %rsi
	cmpq	$0, %rsi
	jne	_body3518
	jmp	_post3517
	.text
_post3517:
	movq	$0, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	