	.text
	.globl	foo
foo:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$8, %rsp
	subq	$8, %rsp
	movq	%rsp, %r11
	subq	$8, %rsp
	movq	%rsp, %r8 
	subq	$8, %rsp
	movq	%rsp, -8(%rbp)
	subq	$8, %rsp
	movq	%rsp, %r10
	subq	$8, %rsp
	movq	%rsp, %r9 
	movq	%rdi, (%r11)
	movq	%rsi, (%r8 )
	movq	%rdx, %rax
	movq	-8(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	(%r11), %rsi
	movq	(%r8 ), %rdi
	addq	%rsi, %rdi
	movq	%rdi, (%r10)
	movq	(%r8 ), %rdi
	movq	-8(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
	addq	%rsi, %rdi
	movq	%rdi, (%r9 )
	movq	(%r10), %rsi
	movq	(%r9 ), %rdi
	addq	%rsi, %rdi
	movq	%rdi, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	program
program:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$144, %rsp
	subq	$8, %rsp
	movq	%rsp, -8(%rbp)
	subq	$8, %rsp
	movq	%rsp, -16(%rbp)
	subq	$8, %rsp
	movq	%rsp, %r8 
	subq	$8, %rsp
	movq	%rsp, %rdx
	subq	$8, %rsp
	movq	%rsp, %rsi
	subq	$8, %rsp
	movq	%rsp, %rdi
	subq	$8, %rsp
	movq	%rsp, -24(%rbp)
	subq	$8, %rsp
	movq	%rsp, -32(%rbp)
	subq	$8, %rsp
	movq	%rsp, -40(%rbp)
	subq	$8, %rsp
	movq	%rsp, -48(%rbp)
	subq	$8, %rsp
	movq	%rsp, -56(%rbp)
	subq	$8, %rsp
	movq	%rsp, -64(%rbp)
	subq	$8, %rsp
	movq	%rsp, -72(%rbp)
	subq	$8, %rsp
	movq	%rsp, -80(%rbp)
	subq	$8, %rsp
	movq	%rsp, -88(%rbp)
	subq	$8, %rsp
	movq	%rsp, -96(%rbp)
	subq	$8, %rsp
	movq	%rsp, -104(%rbp)
	subq	$8, %rsp
	movq	%rsp, -112(%rbp)
	subq	$8, %rsp
	movq	%rsp, -120(%rbp)
	movq	$0, %rax
	movq	-8(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	$0, %rax
	movq	-16(%rbp), %rcx
	movq	%rax, (%rcx)
	jmp	_cond2634
	.text
_body2633:
	movq	$0, %rax
	movq	%r8 , %rcx
	movq	%rax, (%rcx)
	movq	(%r8 ), %r9 
	movq	-16(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r10
	addq	%r10, %r9 
	movq	%r9 , (%rdx)
	movq	(%rdx), %r9 
	movq	-16(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r10
	addq	%r10, %r9 
	movq	%r9 , (%rsi)
	movq	(%rsi), %r9 
	movq	-16(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r10
	addq	%r10, %r9 
	movq	%r9 , (%rdi)
	movq	%rdi, %rax
	movq	(%rax), %rax
	movq	%rax, -128(%rbp)
	movq	(%rsi), %r9 
	movq	(%rdx), %r10
	movq	(%r8 ), %r11
	pushq	%r11
	pushq	%r10
	pushq	%r8 
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	%r9 , %rdx
	movq	%r10, %rsi
	movq	%r11, %rdi
	callq	foo
	popq	%rdx
	popq	%rsi
	popq	%rdi
	popq	%r8 
	popq	%r10
	popq	%r11
	movq	%rax, %r9 
	addq	-128(%rbp), %r9 
	movq	%r9 , (%rdi)
	movq	(%rdi), %r10
	movq	-16(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r9 
	addq	%r10, %r9 
	movq	%r9 , %rax
	movq	-24(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r10
	movq	-16(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r9 
	addq	%r10, %r9 
	movq	%r9 , %rax
	movq	-32(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	-32(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r10
	movq	-16(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r9 
	addq	%r10, %r9 
	movq	%r9 , %rax
	movq	-40(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	-40(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r10
	movq	-16(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r9 
	addq	%r10, %r9 
	movq	%r9 , %rax
	movq	-48(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	-48(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r10
	movq	-16(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r9 
	addq	%r10, %r9 
	movq	%r9 , %rax
	movq	-56(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	-56(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r10
	movq	-48(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r9 
	movq	-40(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r11
	movq	-32(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -136(%rbp)
	pushq	%r11
	pushq	%r10
	pushq	%r8 
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	%r9 , %rdx
	movq	%r11, %rsi
	movq	-136(%rbp), %rdi
	callq	foo
	popq	%rdx
	popq	%rsi
	popq	%rdi
	popq	%r8 
	popq	%r10
	popq	%r11
	movq	%rax, %r9 
	addq	%r10, %r9 
	movq	%r9 , %rax
	movq	-56(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	-56(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r9 
	movq	-16(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r10
	addq	%r10, %r9 
	movq	%r9 , %rax
	movq	-64(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	-64(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r9 
	movq	-16(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r10
	addq	%r10, %r9 
	movq	%r9 , %rax
	movq	-72(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	-72(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r9 
	movq	-16(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r10
	addq	%r10, %r9 
	movq	%r9 , %rax
	movq	-80(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r9 
	movq	-16(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r10
	addq	%r10, %r9 
	movq	%r9 , %rax
	movq	-88(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r10
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r9 
	movq	-72(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r11
	movq	-64(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -144(%rbp)
	pushq	%r11
	pushq	%r10
	pushq	%r8 
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	%r9 , %rdx
	movq	%r11, %rsi
	movq	-144(%rbp), %rdi
	callq	foo
	popq	%rdx
	popq	%rsi
	popq	%rdi
	popq	%r8 
	popq	%r10
	popq	%r11
	movq	%rax, %r9 
	addq	%r10, %r9 
	movq	%r9 , %rax
	movq	-88(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r9 
	movq	-16(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r10
	addq	%r10, %r9 
	movq	%r9 , %rax
	movq	-96(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r9 
	movq	-16(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r10
	addq	%r10, %r9 
	movq	%r9 , %rax
	movq	-104(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r9 
	movq	-16(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r10
	addq	%r10, %r9 
	movq	%r9 , %rax
	movq	-112(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	-112(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r9 
	movq	-16(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r10
	addq	%r10, %r9 
	movq	%r9 , %rax
	movq	-120(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	-8(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r9 
	movq	-120(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r10
	addq	%r10, %r9 
	movq	%r9 , %rax
	movq	-8(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	-16(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r9 
	addq	$1, %r9 
	movq	%r9 , %rax
	movq	-16(%rbp), %rcx
	movq	%rax, (%rcx)
	jmp	_cond2634
	.text
_cond2634:
	movq	-16(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r9 
	cmpq	$10000000, %r9 
	setl	%r9b
	andq	$1, %r9 
	cmpq	$0, %r9 
	jne	_body2633
	jmp	_post2632
	.text
_post2632:
	movq	-8(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	pushq	%rdi
	callq	print_int
	popq	%rdi
	movq	$0, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	