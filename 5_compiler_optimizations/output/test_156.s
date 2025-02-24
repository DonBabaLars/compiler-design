	.text
	.globl	f
f:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$8, %rsp
	movq	%rsp, %rdx
	movq	%rdi, (%rdx)
	movq	(%rdx), %rdx
	movq	%rdx, %rax
	movq	%rax, %rdi
	pushq	%rdi
	pushq	%rdx
	movq	$1, %rsi
	callq	oat_assert_array_length
	popq	%rdx
	popq	%rdi
	movq	%rdx, %rax
	addq	$0, %rax
	addq	$8, %rax
	addq	$8, %rax
	movq	%rax, %rdi
	movq	(%rdi), %rdx
	movq	%rdx, %rax
	movq	%rax, %rdi
	pushq	%rdi
	pushq	%rdx
	movq	$1, %rsi
	callq	oat_assert_array_length
	popq	%rdx
	popq	%rdi
	movq	%rdx, %rax
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
	.globl	g
g:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$72, %rsp
	subq	$8, %rsp
	movq	%rsp, -8(%rbp)
	subq	$8, %rsp
	movq	%rsp, %rdx
	subq	$8, %rsp
	movq	%rsp, -16(%rbp)
	subq	$8, %rsp
	movq	%rsp, %r10
	movq	%rdi, %rax
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
	movq	%rsp, -24(%rbp)
	movq	%r9 , %rax
	movq	-24(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	$0, %rax
	movq	%rdx, %rcx
	movq	%rax, (%rcx)
	jmp	_cond1571
	.text
_body1570:
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r8 
	movq	(%rdx), %rdi
	movq	%r8 , %rax
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
	movq	%r8 , %rax
	addq	$0, %rax
	addq	$8, %rax
	movq	%rax, %rcx
	movq	%rdi, %rax
	imulq	$8, %rax
	addq	%rcx, %rax
	movq	%rax, -32(%rbp)
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
	movq	%rsp, -40(%rbp)
	movq	%r8 , %rax
	movq	-40(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	$0, %rax
	movq	-16(%rbp), %rcx
	movq	%rax, (%rcx)
	jmp	_cond1588
	.text
_body1587:
	movq	-40(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r11
	movq	-16(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -48(%rbp)
	movq	%r11, %rax
	movq	%rax, -56(%rbp)
	pushq	%r11
	pushq	%r10
	pushq	%r9 
	pushq	%r8 
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	-48(%rbp), %rsi
	movq	-56(%rbp), %rdi
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
	movq	-48(%rbp), %rax
	imulq	$8, %rax
	addq	%rcx, %rax
	movq	%rax, -64(%rbp)
	movq	-8(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r11
	movq	%r11, %rax
	movq	-64(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	-16(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r11
	addq	$1, %r11
	movq	%r11, %rax
	movq	-16(%rbp), %rcx
	movq	%rax, (%rcx)
	jmp	_cond1588
	.text
_cond1571:
	movq	(%rdx), %rdi
	movq	(%rsi), %r8 
	cmpq	%r8 , %rdi
	setl	%dil
	andq	$1, %rdi
	cmpq	$0, %rdi
	jne	_body1570
	jmp	_post1569
	.text
_cond1588:
	movq	-16(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -72(%rbp)
	movq	(%rdi), %r11
	movq	-72(%rbp), %rax
	cmpq	%r11, %rax
	setl	%r11b
	andq	$1, %r11
	cmpq	$0, %r11
	jne	_body1587
	jmp	_post1586
	.text
_post1569:
	movq	%r9 , (%r10)
	movq	(%r10), %rdx
	movq	%rdx, %rax
	movq	%rax, %rdi
	pushq	%rdi
	pushq	%rdx
	movq	$1, %rsi
	callq	oat_assert_array_length
	popq	%rdx
	popq	%rdi
	movq	%rdx, %rax
	addq	$0, %rax
	addq	$8, %rax
	addq	$8, %rax
	movq	%rax, %rdx
	movq	(%rdx), %rdx
	movq	%rdx, %rax
	movq	%rax, %rdi
	pushq	%rdi
	pushq	%rdx
	movq	$1, %rsi
	callq	oat_assert_array_length
	popq	%rdx
	popq	%rdi
	movq	%rdx, %rax
	addq	$0, %rax
	addq	$8, %rax
	addq	$8, %rax
	movq	%rax, %rdx
	movq	(%rdx), %rdx
	movq	%rdx, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
_post1586:
	movq	%r8 , %rax
	movq	-32(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	(%rdx), %rdi
	addq	$1, %rdi
	movq	%rdi, (%rdx)
	jmp	_cond1571
	.text
	.globl	program
program:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$232, %rsp
	subq	$8, %rsp
	movq	%rsp, -8(%rbp)
	subq	$8, %rsp
	movq	%rsp, -16(%rbp)
	subq	$8, %rsp
	movq	%rsp, %rdx
	subq	$8, %rsp
	movq	%rsp, -24(%rbp)
	subq	$8, %rsp
	movq	%rsp, -32(%rbp)
	subq	$8, %rsp
	movq	%rsp, %rdi
	subq	$8, %rsp
	movq	%rsp, -40(%rbp)
	subq	$8, %rsp
	movq	%rsp, -48(%rbp)
	subq	$8, %rsp
	movq	%rsp, %rsi
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	$3, %rdi
	callq	oat_alloc_array
	popq	%rdx
	popq	%rsi
	popq	%rdi
	movq	%rax, %r8 
	movq	%r8 , %rax
	movq	%rax, %r10
	subq	$8, %rsp
	movq	%rsp, %r8 
	movq	$3, %rax
	movq	%r8 , %rcx
	movq	%rax, (%rcx)
	subq	$8, %rsp
	movq	%rsp, -56(%rbp)
	movq	%r10, %rax
	movq	-56(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	$0, %rax
	movq	-8(%rbp), %rcx
	movq	%rax, (%rcx)
	jmp	_cond1393
	.text
_body1392:
	movq	-56(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r9 
	movq	-8(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -64(%rbp)
	movq	%r9 , %rax
	movq	%rax, %r11
	pushq	%r11
	pushq	%r10
	pushq	%r9 
	pushq	%r8 
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	-64(%rbp), %rsi
	movq	%r11, %rdi
	callq	oat_assert_array_length
	popq	%rdx
	popq	%rsi
	popq	%rdi
	popq	%r8 
	popq	%r9 
	popq	%r10
	popq	%r11
	movq	%r9 , %rax
	addq	$0, %rax
	addq	$8, %rax
	movq	%rax, %rcx
	movq	-64(%rbp), %rax
	imulq	$8, %rax
	addq	%rcx, %rax
	movq	%rax, -72(%rbp)
	pushq	%r10
	pushq	%r8 
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	$3, %rdi
	callq	oat_alloc_array
	popq	%rdx
	popq	%rsi
	popq	%rdi
	popq	%r8 
	popq	%r10
	movq	%rax, %r9 
	movq	%r9 , %rax
	movq	%rax, %r9 
	subq	$8, %rsp
	movq	%rsp, -80(%rbp)
	movq	$3, %rax
	movq	-80(%rbp), %rcx
	movq	%rax, (%rcx)
	subq	$8, %rsp
	movq	%rsp, -88(%rbp)
	movq	%r9 , %rax
	movq	-88(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	$0, %rax
	movq	-16(%rbp), %rcx
	movq	%rax, (%rcx)
	jmp	_cond1410
	.text
_body1409:
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r11
	movq	-16(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	%r11, %rax
	movq	%rax, -104(%rbp)
	pushq	%r11
	pushq	%r10
	pushq	%r9 
	pushq	%r8 
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	-96(%rbp), %rsi
	movq	-104(%rbp), %rdi
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
	movq	-96(%rbp), %rax
	imulq	$8, %rax
	addq	%rcx, %rax
	movq	%rax, -112(%rbp)
	movq	-16(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r11
	movq	%r11, %rax
	movq	-112(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	-16(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r11
	addq	$1, %r11
	movq	%r11, %rax
	movq	-16(%rbp), %rcx
	movq	%rax, (%rcx)
	jmp	_cond1410
	.text
_body1441:
	movq	-216(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r9 
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r11
	movq	%r9 , %rax
	movq	%rax, %r10
	pushq	%r11
	pushq	%r10
	pushq	%r9 
	pushq	%r8 
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	%r11, %rsi
	movq	%r10, %rdi
	callq	oat_assert_array_length
	popq	%rdx
	popq	%rsi
	popq	%rdi
	popq	%r8 
	popq	%r9 
	popq	%r10
	popq	%r11
	movq	%r9 , %rax
	addq	$0, %rax
	addq	$8, %rax
	movq	%rax, %rcx
	movq	%r11, %rax
	imulq	$8, %rax
	addq	%rcx, %rax
	movq	%rax, -120(%rbp)
	pushq	%r8 
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	$5, %rdi
	callq	oat_alloc_array
	popq	%rdx
	popq	%rsi
	popq	%rdi
	popq	%r8 
	movq	%rax, %r9 
	movq	%r9 , %rax
	movq	%rax, %r9 
	subq	$8, %rsp
	movq	%rsp, -128(%rbp)
	movq	$5, %rax
	movq	-128(%rbp), %rcx
	movq	%rax, (%rcx)
	subq	$8, %rsp
	movq	%rsp, -136(%rbp)
	movq	%r9 , %rax
	movq	-136(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	$0, %rax
	movq	-32(%rbp), %rcx
	movq	%rax, (%rcx)
	jmp	_cond1459
	.text
_body1458:
	movq	-136(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r10
	movq	-32(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -144(%rbp)
	movq	%r10, %rax
	movq	%rax, %r11
	pushq	%r11
	pushq	%r10
	pushq	%r9 
	pushq	%r8 
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	-144(%rbp), %rsi
	movq	%r11, %rdi
	callq	oat_assert_array_length
	popq	%rdx
	popq	%rsi
	popq	%rdi
	popq	%r8 
	popq	%r9 
	popq	%r10
	popq	%r11
	movq	%r10, %rax
	addq	$0, %rax
	addq	$8, %rax
	movq	%rax, %rcx
	movq	-144(%rbp), %rax
	imulq	$8, %rax
	addq	%rcx, %rax
	movq	%rax, %r11
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -152(%rbp)
	movq	-32(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r10
	imulq	-152(%rbp), %r10
	movq	%r10, (%r11)
	movq	-32(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r10
	addq	$1, %r10
	movq	%r10, %rax
	movq	-32(%rbp), %rcx
	movq	%rax, (%rcx)
	jmp	_cond1459
	.text
_body1492:
	movq	-232(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r9 
	movq	-40(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r11
	movq	%r9 , %rax
	movq	%rax, %r10
	pushq	%r11
	pushq	%r10
	pushq	%r9 
	pushq	%r8 
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	%r11, %rsi
	movq	%r10, %rdi
	callq	oat_assert_array_length
	popq	%rdx
	popq	%rsi
	popq	%rdi
	popq	%r8 
	popq	%r9 
	popq	%r10
	popq	%r11
	movq	%r9 , %rax
	addq	$0, %rax
	addq	$8, %rax
	movq	%rax, %rcx
	movq	%r11, %rax
	imulq	$8, %rax
	addq	%rcx, %rax
	movq	%rax, -160(%rbp)
	pushq	%r8 
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	$3, %rdi
	callq	oat_alloc_array
	popq	%rdx
	popq	%rsi
	popq	%rdi
	popq	%r8 
	movq	%rax, %r9 
	movq	%r9 , %rax
	movq	%rax, %r9 
	subq	$8, %rsp
	movq	%rsp, -168(%rbp)
	movq	$3, %rax
	movq	-168(%rbp), %rcx
	movq	%rax, (%rcx)
	subq	$8, %rsp
	movq	%rsp, -176(%rbp)
	movq	%r9 , %rax
	movq	-176(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	$0, %rax
	movq	-48(%rbp), %rcx
	movq	%rax, (%rcx)
	jmp	_cond1510
	.text
_body1509:
	movq	-176(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r10
	movq	-48(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -184(%rbp)
	movq	%r10, %rax
	movq	%rax, %r11
	pushq	%r11
	pushq	%r10
	pushq	%r9 
	pushq	%r8 
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	-184(%rbp), %rsi
	movq	%r11, %rdi
	callq	oat_assert_array_length
	popq	%rdx
	popq	%rsi
	popq	%rdi
	popq	%r8 
	popq	%r9 
	popq	%r10
	popq	%r11
	movq	%r10, %rax
	addq	$0, %rax
	addq	$8, %rax
	movq	%rax, %rcx
	movq	-184(%rbp), %rax
	imulq	$8, %rax
	addq	%rcx, %rax
	movq	%rax, %r11
	movq	-40(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -192(%rbp)
	movq	-48(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r10
	imulq	-192(%rbp), %r10
	movq	%r10, (%r11)
	movq	-48(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r10
	addq	$1, %r10
	movq	%r10, %rax
	movq	-48(%rbp), %rcx
	movq	%rax, (%rcx)
	jmp	_cond1510
	.text
_cond1393:
	movq	-8(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r11
	movq	(%r8 ), %r9 
	cmpq	%r9 , %r11
	setl	%r9b
	andq	$1, %r9 
	cmpq	$0, %r9 
	jne	_body1392
	jmp	_post1391
	.text
_cond1410:
	movq	-16(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -200(%rbp)
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r11
	movq	-200(%rbp), %rax
	cmpq	%r11, %rax
	setl	%r11b
	andq	$1, %r11
	cmpq	$0, %r11
	jne	_body1409
	jmp	_post1408
	.text
_cond1442:
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r10
	movq	-208(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r9 
	cmpq	%r9 , %r10
	setl	%r9b
	andq	$1, %r9 
	cmpq	$0, %r9 
	jne	_body1441
	jmp	_post1440
	.text
_cond1459:
	movq	-32(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r11
	movq	-128(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r10
	cmpq	%r10, %r11
	setl	%r10b
	andq	$1, %r10
	cmpq	$0, %r10
	jne	_body1458
	jmp	_post1457
	.text
_cond1493:
	movq	-40(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r10
	movq	-224(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r9 
	cmpq	%r9 , %r10
	setl	%r9b
	andq	$1, %r9 
	cmpq	$0, %r9 
	jne	_body1492
	jmp	_post1491
	.text
_cond1510:
	movq	-48(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r11
	movq	-168(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r10
	cmpq	%r10, %r11
	setl	%r10b
	andq	$1, %r10
	cmpq	$0, %r10
	jne	_body1509
	jmp	_post1508
	.text
_post1391:
	movq	%r10, (%rdx)
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	$4, %rdi
	callq	oat_alloc_array
	popq	%rdx
	popq	%rsi
	popq	%rdi
	movq	%rax, %r8 
	movq	%r8 , %rax
	movq	%rax, %r8 
	subq	$8, %rsp
	movq	%rsp, -208(%rbp)
	movq	$4, %rax
	movq	-208(%rbp), %rcx
	movq	%rax, (%rcx)
	subq	$8, %rsp
	movq	%rsp, -216(%rbp)
	movq	%r8 , %rax
	movq	-216(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	$0, %rax
	movq	-24(%rbp), %rcx
	movq	%rax, (%rcx)
	jmp	_cond1442
	.text
_post1408:
	movq	%r9 , %rax
	movq	-72(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	-8(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r9 
	addq	$1, %r9 
	movq	%r9 , %rax
	movq	-8(%rbp), %rcx
	movq	%rax, (%rcx)
	jmp	_cond1393
	.text
_post1440:
	movq	%r8 , (%rdi)
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	$3, %rdi
	callq	oat_alloc_array
	popq	%rdx
	popq	%rsi
	popq	%rdi
	movq	%rax, %r8 
	movq	%r8 , %rax
	movq	%rax, %r8 
	subq	$8, %rsp
	movq	%rsp, -224(%rbp)
	movq	$3, %rax
	movq	-224(%rbp), %rcx
	movq	%rax, (%rcx)
	subq	$8, %rsp
	movq	%rsp, -232(%rbp)
	movq	%r8 , %rax
	movq	-232(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	$0, %rax
	movq	-40(%rbp), %rcx
	movq	%rax, (%rcx)
	jmp	_cond1493
	.text
_post1457:
	movq	%r9 , %rax
	movq	-120(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r9 
	addq	$1, %r9 
	movq	%r9 , %rax
	movq	-24(%rbp), %rcx
	movq	%rax, (%rcx)
	jmp	_cond1442
	.text
_post1491:
	movq	%r8 , (%rsi)
	movq	(%rdi), %rdi
	movq	%rdi, %rax
	movq	%rax, %r8 
	pushq	%r8 
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	$3, %rsi
	movq	%r8 , %rdi
	callq	oat_assert_array_length
	popq	%rdx
	popq	%rsi
	popq	%rdi
	popq	%r8 
	movq	%rdi, %rax
	addq	$0, %rax
	addq	$8, %rax
	addq	$24, %rax
	movq	%rax, %rdi
	movq	(%rdi), %r8 
	movq	%r8 , %rax
	movq	%rax, %rdi
	pushq	%r8 
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	$4, %rsi
	callq	oat_assert_array_length
	popq	%rdx
	popq	%rsi
	popq	%rdi
	popq	%r8 
	movq	%r8 , %rax
	addq	$0, %rax
	addq	$8, %rax
	addq	$32, %rax
	movq	%rax, %rdi
	movq	(%rdi), %r8 
	movq	(%rdx), %rdi
	movq	%rdi, %rax
	movq	%rax, %rdx
	pushq	%r8 
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	$1, %rsi
	movq	%rdx, %rdi
	callq	oat_assert_array_length
	popq	%rdx
	popq	%rsi
	popq	%rdi
	popq	%r8 
	movq	%rdi, %rax
	addq	$0, %rax
	addq	$8, %rax
	addq	$8, %rax
	movq	%rax, %rdi
	movq	(%rdi), %rdx
	movq	%rdx, %rax
	movq	%rax, %rdi
	pushq	%r8 
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	$2, %rsi
	callq	oat_assert_array_length
	popq	%rdx
	popq	%rsi
	popq	%rdi
	popq	%r8 
	movq	%rdx, %rax
	addq	$0, %rax
	addq	$8, %rax
	addq	$16, %rax
	movq	%rax, %rdi
	movq	(%rdi), %rdi
	movq	%r8 , %rdx
	addq	%rdi, %rdx
	movq	(%rsi), %rdi
	pushq	%rdx
	callq	f
	popq	%rdx
	movq	%rax, %rdi
	movq	%rdx, %rsi
	addq	%rdi, %rsi
	pushq	%rsi
	movq	$4, %rdi
	callq	g
	popq	%rsi
	movq	%rax, %rdi
	addq	%rsi, %rdi
	movq	%rdi, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
_post1508:
	movq	%r9 , %rax
	movq	-160(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	-40(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r9 
	addq	$1, %r9 
	movq	%r9 , %rax
	movq	-40(%rbp), %rcx
	movq	%rax, (%rcx)
	jmp	_cond1493