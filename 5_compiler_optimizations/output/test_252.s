	.text
	.globl	f
f:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$104, %rsp
	movq	%rcx, %r11
	movq	%r8 , -40(%rbp)
	movq	%r9 , -48(%rbp)
	pushq	16(%rbp)
	popq	-56(%rbp)
	pushq	24(%rbp)
	popq	-64(%rbp)
	subq	$8, %rsp
	movq	%rsp, %r10
	subq	$8, %rsp
	movq	%rsp, %r9 
	subq	$8, %rsp
	movq	%rsp, %r8 
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
	movq	%rdi, (%r10)
	movq	%rsi, (%r9 )
	movq	%rdx, (%r8 )
	movq	%r11, %rax
	movq	-72(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	-40(%rbp), %rax
	movq	-80(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	-48(%rbp), %rax
	movq	-88(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	-56(%rbp), %rax
	movq	-96(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	-64(%rbp), %rax
	movq	-104(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	(%r10), %rsi
	movq	(%r9 ), %rdi
	addq	%rdi, %rsi
	movq	(%r8 ), %rdi
	addq	%rsi, %rdi
	movq	-72(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
	addq	%rsi, %rdi
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
	addq	%rsi, %rdi
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
	addq	%rsi, %rdi
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
	addq	%rsi, %rdi
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
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
	pushq	$-3
	pushq	$-4
	movq	$-5, %r9 
	movq	$5, %r8 
	movq	$4, %rcx
	movq	$3, %rdx
	movq	$2, %rsi
	movq	$1, %rdi
	callq	f
	addq	$16, %rsp
	movq	%rax, %rdi
	movq	%rdi, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	