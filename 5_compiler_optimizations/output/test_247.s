	.text
	.globl	min_heapify
min_heapify:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	subq	$8, %rsp
	movq	%rsp, %r11
	subq	$8, %rsp
	movq	%rsp, %r10
	subq	$8, %rsp
	movq	%rsp, %r8 
	subq	$8, %rsp
	movq	%rsp, %r9 
	subq	$8, %rsp
	movq	%rsp, -8(%rbp)
	subq	$8, %rsp
	movq	%rsp, -16(%rbp)
	subq	$8, %rsp
	movq	%rsp, -24(%rbp)
	movq	%rdi, (%r11)
	movq	%rsi, (%r10)
	movq	%rdx, (%r8 )
	movq	(%r10), %rdi
	imulq	$2, %rdi
	movq	%rdi, (%r9 )
	movq	(%r10), %rdi
	addq	$1, %rdi
	movq	%rdi, %rax
	movq	-8(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	$0, %rax
	movq	-16(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	(%r10), %rdi
	movq	%rdi, %rax
	movq	-24(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	(%r9 ), %rsi
	movq	(%r8 ), %rdi
	cmpq	%rdi, %rsi
	setl	%dil
	andq	$1, %rdi
	cmpq	$0, %rdi
	jne	_then8534
	jmp	_else8533
	.text
_else8530:
	jmp	_merge8529
	.text
_else8533:
	jmp	_merge8532
	.text
_else8554:
	jmp	_merge8553
	.text
_else8557:
	jmp	_merge8556
	.text
_else8593:
	jmp	_merge8592
	.text
_merge8529:
	jmp	_merge8532
	.text
_merge8532:
	movq	-8(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
	movq	(%r8 ), %rdi
	cmpq	%rdi, %rsi
	setl	%dil
	andq	$1, %rdi
	cmpq	$0, %rdi
	jne	_then8558
	jmp	_else8557
	.text
_merge8553:
	jmp	_merge8556
	.text
_merge8556:
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
	movq	(%r10), %rdi
	cmpq	%rdi, %rsi
	setne	%dil
	andq	$1, %rdi
	cmpq	$0, %rdi
	jne	_then8594
	jmp	_else8593
	.text
_merge8592:
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
_then8531:
	movq	(%r9 ), %rdi
	movq	%rdi, %rax
	movq	-24(%rbp), %rcx
	movq	%rax, (%rcx)
	jmp	_merge8529
	.text
_then8534:
	movq	(%r11), %rsi
	movq	(%r9 ), %rdi
	movq	%rsi, %rax
	movq	%rax, %rdx
	pushq	%r11
	pushq	%r10
	pushq	%r9 
	pushq	%r8 
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	%rdi, %rsi
	movq	%rdx, %rdi
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
	movq	(%r11), %rsi
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rbp)
	movq	%rsi, %rax
	movq	%rax, %rdx
	pushq	%r11
	pushq	%r10
	pushq	%r9 
	pushq	%r8 
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	-32(%rbp), %rsi
	movq	%rdx, %rdi
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
	movq	-32(%rbp), %rax
	imulq	$8, %rax
	addq	%rcx, %rax
	movq	%rax, %rsi
	movq	(%rsi), %rsi
	cmpq	%rsi, %rdi
	setg	%dil
	andq	$1, %rdi
	cmpq	$0, %rdi
	jne	_then8531
	jmp	_else8530
	.text
_then8555:
	movq	-8(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	movq	%rdi, %rax
	movq	-24(%rbp), %rcx
	movq	%rax, (%rcx)
	jmp	_merge8553
	.text
_then8558:
	movq	(%r11), %rdi
	movq	-8(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rdx
	movq	%rdi, %rax
	movq	%rax, %rsi
	pushq	%r11
	pushq	%r10
	pushq	%r8 
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	%rsi, %rdi
	movq	%rdx, %rsi
	callq	oat_assert_array_length
	popq	%rdx
	popq	%rsi
	popq	%rdi
	popq	%r8 
	popq	%r10
	popq	%r11
	movq	%rdi, %rax
	addq	$0, %rax
	addq	$8, %rax
	movq	%rax, %rcx
	movq	%rdx, %rax
	imulq	$8, %rax
	addq	%rcx, %rax
	movq	%rax, %rdi
	movq	(%rdi), %rsi
	movq	(%r11), %rdi
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r9 
	movq	%rdi, %rax
	movq	%rax, %rdx
	pushq	%r11
	pushq	%r10
	pushq	%r9 
	pushq	%r8 
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	%r9 , %rsi
	movq	%rdx, %rdi
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
	movq	%r9 , %rax
	imulq	$8, %rax
	addq	%rcx, %rax
	movq	%rax, %rdi
	movq	(%rdi), %rdi
	cmpq	%rdi, %rsi
	setg	%dil
	andq	$1, %rdi
	cmpq	$0, %rdi
	jne	_then8555
	jmp	_else8554
	.text
_then8594:
	movq	(%r11), %rsi
	movq	(%r10), %rdi
	movq	%rsi, %rax
	movq	%rax, %rdx
	pushq	%r11
	pushq	%r10
	pushq	%r8 
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	%rdi, %rsi
	movq	%rdx, %rdi
	callq	oat_assert_array_length
	popq	%rdx
	popq	%rsi
	popq	%rdi
	popq	%r8 
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
	movq	-16(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	(%r11), %rsi
	movq	(%r10), %rdi
	movq	%rsi, %rax
	movq	%rax, %rdx
	pushq	%r11
	pushq	%r8 
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	%rdi, %rsi
	movq	%rdx, %rdi
	callq	oat_assert_array_length
	popq	%rdx
	popq	%rsi
	popq	%rdi
	popq	%r8 
	popq	%r11
	movq	%rsi, %rax
	addq	$0, %rax
	addq	$8, %rax
	movq	%rax, %rcx
	movq	%rdi, %rax
	imulq	$8, %rax
	addq	%rcx, %rax
	movq	%rax, %rsi
	movq	(%r11), %rdi
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r9 
	movq	%rdi, %rax
	movq	%rax, %rdx
	pushq	%r11
	pushq	%r9 
	pushq	%r8 
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	%r9 , %rsi
	movq	%rdx, %rdi
	callq	oat_assert_array_length
	popq	%rdx
	popq	%rsi
	popq	%rdi
	popq	%r8 
	popq	%r9 
	popq	%r11
	movq	%rdi, %rax
	addq	$0, %rax
	addq	$8, %rax
	movq	%rax, %rcx
	movq	%r9 , %rax
	imulq	$8, %rax
	addq	%rcx, %rax
	movq	%rax, %rdi
	movq	(%rdi), %rdi
	movq	%rdi, (%rsi)
	movq	(%r11), %rdi
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rdx
	movq	%rdi, %rax
	movq	%rax, %rsi
	pushq	%r11
	pushq	%r8 
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	%rsi, %rdi
	movq	%rdx, %rsi
	callq	oat_assert_array_length
	popq	%rdx
	popq	%rsi
	popq	%rdi
	popq	%r8 
	popq	%r11
	movq	%rdi, %rax
	addq	$0, %rax
	addq	$8, %rax
	movq	%rax, %rcx
	movq	%rdx, %rax
	imulq	$8, %rax
	addq	%rcx, %rax
	movq	%rax, %rdi
	movq	-16(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
	movq	%rsi, (%rdi)
	movq	(%r8 ), %rdi
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rdx
	movq	(%r11), %rsi
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	pushq	%rdi
	movq	%rsi, %rdi
	movq	%rdx, %rsi
	popq	%rdx
	callq	min_heapify
	popq	%rdx
	popq	%rsi
	popq	%rdi
	jmp	_merge8592
	.text
	.globl	make_min_heap
make_min_heap:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$8, %rsp
	movq	%rsp, %r9 
	subq	$8, %rsp
	movq	%rsp, %rdx
	subq	$8, %rsp
	movq	%rsp, %r8 
	movq	%rdi, (%r9 )
	movq	%rsi, (%rdx)
	movq	(%rdx), %rdi
	movq	%rdi, (%r8 )
	jmp	_cond8481
	.text
_body8480:
	movq	(%rdx), %rdi
	movq	(%r8 ), %rsi
	movq	(%r9 ), %r10
	pushq	%r10
	pushq	%r9 
	pushq	%r8 
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	%rdi, %rdx
	movq	%r10, %rdi
	callq	min_heapify
	popq	%rdx
	popq	%rsi
	popq	%rdi
	popq	%r8 
	popq	%r9 
	popq	%r10
	movq	(%r8 ), %rdi
	subq	$1, %rdi
	movq	%rdi, (%r8 )
	jmp	_cond8481
	.text
_cond8481:
	movq	(%r8 ), %rdi
	cmpq	$1, %rdi
	setge	%dil
	andq	$1, %rdi
	cmpq	$0, %rdi
	jne	_body8480
	jmp	_post8479
	.text
_post8479:
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	program
program:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$8, %rsp
	subq	$8, %rsp
	movq	%rsp, %r9 
	subq	$8, %rsp
	movq	%rsp, %r8 
	subq	$8, %rsp
	movq	%rsp, %rdi
	subq	$8, %rsp
	movq	%rsp, %rdx
	pushq	%r9 
	pushq	%r8 
	pushq	%rdi
	pushq	%rdx
	movq	$11, %rdi
	callq	oat_alloc_array
	popq	%rdx
	popq	%rdi
	popq	%r8 
	popq	%r9 
	movq	%rax, %rsi
	movq	%rsi, %rax
	movq	%rax, %rsi
	movq	%rsi, %rax
	addq	$0, %rax
	addq	$8, %rax
	addq	$0, %rax
	movq	%rax, %r10
	movq	$0, %rax
	movq	%r10, %rcx
	movq	%rax, (%rcx)
	movq	%rsi, %rax
	addq	$0, %rax
	addq	$8, %rax
	addq	$8, %rax
	movq	%rax, %r10
	movq	$9, %rax
	movq	%r10, %rcx
	movq	%rax, (%rcx)
	movq	%rsi, %rax
	addq	$0, %rax
	addq	$8, %rax
	addq	$16, %rax
	movq	%rax, %r10
	movq	$1, %rax
	movq	%r10, %rcx
	movq	%rax, (%rcx)
	movq	%rsi, %rax
	addq	$0, %rax
	addq	$8, %rax
	addq	$24, %rax
	movq	%rax, %r10
	movq	$2, %rax
	movq	%r10, %rcx
	movq	%rax, (%rcx)
	movq	%rsi, %rax
	addq	$0, %rax
	addq	$8, %rax
	addq	$32, %rax
	movq	%rax, %r10
	movq	$8, %rax
	movq	%r10, %rcx
	movq	%rax, (%rcx)
	movq	%rsi, %rax
	addq	$0, %rax
	addq	$8, %rax
	addq	$40, %rax
	movq	%rax, %r10
	movq	$10, %rax
	movq	%r10, %rcx
	movq	%rax, (%rcx)
	movq	%rsi, %rax
	addq	$0, %rax
	addq	$8, %rax
	addq	$48, %rax
	movq	%rax, %r10
	movq	$7, %rax
	movq	%r10, %rcx
	movq	%rax, (%rcx)
	movq	%rsi, %rax
	addq	$0, %rax
	addq	$8, %rax
	addq	$56, %rax
	movq	%rax, %r10
	movq	$3, %rax
	movq	%r10, %rcx
	movq	%rax, (%rcx)
	movq	%rsi, %rax
	addq	$0, %rax
	addq	$8, %rax
	addq	$64, %rax
	movq	%rax, %r10
	movq	$6, %rax
	movq	%r10, %rcx
	movq	%rax, (%rcx)
	movq	%rsi, %rax
	addq	$0, %rax
	addq	$8, %rax
	addq	$72, %rax
	movq	%rax, %r10
	movq	$4, %rax
	movq	%r10, %rcx
	movq	%rax, (%rcx)
	movq	%rsi, %rax
	addq	$0, %rax
	addq	$8, %rax
	addq	$80, %rax
	movq	%rax, %r10
	movq	$5, %rax
	movq	%r10, %rcx
	movq	%rax, (%rcx)
	movq	%rsi, (%r9 )
	pushq	%r9 
	pushq	%r8 
	pushq	%rdi
	pushq	%rdx
	movq	$11, %rdi
	callq	oat_alloc_array
	popq	%rdx
	popq	%rdi
	popq	%r8 
	popq	%r9 
	movq	%rax, %rsi
	movq	%rsi, %rax
	movq	%rax, %rsi
	movq	%rsi, %rax
	addq	$0, %rax
	addq	$8, %rax
	addq	$0, %rax
	movq	%rax, %r10
	movq	$0, %rax
	movq	%r10, %rcx
	movq	%rax, (%rcx)
	movq	%rsi, %rax
	addq	$0, %rax
	addq	$8, %rax
	addq	$8, %rax
	movq	%rax, %r10
	movq	$1, %rax
	movq	%r10, %rcx
	movq	%rax, (%rcx)
	movq	%rsi, %rax
	addq	$0, %rax
	addq	$8, %rax
	addq	$16, %rax
	movq	%rax, %r10
	movq	$4, %rax
	movq	%r10, %rcx
	movq	%rax, (%rcx)
	movq	%rsi, %rax
	addq	$0, %rax
	addq	$8, %rax
	addq	$24, %rax
	movq	%rax, %r10
	movq	$2, %rax
	movq	%r10, %rcx
	movq	%rax, (%rcx)
	movq	%rsi, %rax
	addq	$0, %rax
	addq	$8, %rax
	addq	$32, %rax
	movq	%rax, %r10
	movq	$8, %rax
	movq	%r10, %rcx
	movq	%rax, (%rcx)
	movq	%rsi, %rax
	addq	$0, %rax
	addq	$8, %rax
	addq	$40, %rax
	movq	%rax, %r10
	movq	$5, %rax
	movq	%r10, %rcx
	movq	%rax, (%rcx)
	movq	%rsi, %rax
	addq	$0, %rax
	addq	$8, %rax
	addq	$48, %rax
	movq	%rax, %r10
	movq	$7, %rax
	movq	%r10, %rcx
	movq	%rax, (%rcx)
	movq	%rsi, %rax
	addq	$0, %rax
	addq	$8, %rax
	addq	$56, %rax
	movq	%rax, %r10
	movq	$3, %rax
	movq	%r10, %rcx
	movq	%rax, (%rcx)
	movq	%rsi, %rax
	addq	$0, %rax
	addq	$8, %rax
	addq	$64, %rax
	movq	%rax, %r10
	movq	$6, %rax
	movq	%r10, %rcx
	movq	%rax, (%rcx)
	movq	%rsi, %rax
	addq	$0, %rax
	addq	$8, %rax
	addq	$72, %rax
	movq	%rax, %r10
	movq	$9, %rax
	movq	%r10, %rcx
	movq	%rax, (%rcx)
	movq	%rsi, %rax
	addq	$0, %rax
	addq	$8, %rax
	addq	$80, %rax
	movq	%rax, %r10
	movq	$10, %rax
	movq	%r10, %rcx
	movq	%rax, (%rcx)
	movq	%rsi, (%r8 )
	movq	(%r9 ), %rsi
	pushq	%r9 
	pushq	%r8 
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	%rsi, %rdi
	movq	$10, %rsi
	callq	make_min_heap
	popq	%rdx
	popq	%rsi
	popq	%rdi
	popq	%r8 
	popq	%r9 
	movq	$0, %rax
	movq	%rdi, %rcx
	movq	%rax, (%rcx)
	movq	$0, %rax
	movq	%rdx, %rcx
	movq	%rax, (%rcx)
	jmp	_cond8446
	.text
_body8445:
	movq	(%r9 ), %r11
	movq	(%rdx), %r10
	movq	%r11, %rax
	movq	%rax, %rsi
	pushq	%r11
	pushq	%r10
	pushq	%r9 
	pushq	%r8 
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	%rsi, %rdi
	movq	%r10, %rsi
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
	movq	%rax, %rsi
	movq	(%rsi), %rsi
	movq	(%r8 ), %r11
	movq	(%rdx), %r10
	movq	%r11, %rax
	movq	%rax, -8(%rbp)
	pushq	%r11
	pushq	%r10
	pushq	%r9 
	pushq	%r8 
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	%r10, %rsi
	movq	-8(%rbp), %rdi
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
	movq	(%r10), %r10
	cmpq	%r10, %rsi
	setne	%sil
	andq	$1, %rsi
	cmpq	$0, %rsi
	jne	_then8463
	jmp	_else8462
	.text
_cond8446:
	movq	(%rdx), %rsi
	cmpq	$11, %rsi
	setl	%sil
	andq	$1, %rsi
	cmpq	$0, %rsi
	jne	_body8445
	jmp	_post8444
	.text
_else8462:
	jmp	_merge8461
	.text
_merge8461:
	movq	(%rdx), %rsi
	addq	$1, %rsi
	movq	%rsi, (%rdx)
	jmp	_cond8446
	.text
_post8444:
	movq	(%rdi), %rdi
	movq	%rdi, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
_then8463:
	movq	$1, %rax
	movq	%rdi, %rcx
	movq	%rax, (%rcx)
	jmp	_merge8461