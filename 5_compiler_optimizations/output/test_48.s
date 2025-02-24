	.data
	.globl	glist
glist:
	.quad	1
	.quad	2
	.quad	3
	.quad	4
	.quad	5
	.text
	.globl	search
search:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$8, %rsp
	movq	%rsp, %rdx
	movq	$0, %rax
	movq	%rdx, %rcx
	movq	%rax, (%rcx)
	jmp	loop
	.text
check:
	movq	%rsi, %rax
	addq	$0, %rax
	movq	%rax, %rcx
	movq	%r8 , %rax
	imulq	$8, %rax
	addq	%rcx, %rax
	movq	%rax, %r9 
	movq	(%r9 ), %r9 
	cmpq	%r9 , %rdi
	sete	%r9b
	andq	$1, %r9 
	addq	$1, %r8 
	movq	%r8 , (%rdx)
	cmpq	$0, %r9 
	jne	true
	jmp	loop
	.text
false:
	movq	$0, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
loop:
	movq	(%rdx), %r8 
	cmpq	$5, %r8 
	sete	%r9b
	andq	$1, %r9 
	cmpq	$0, %r9 
	jne	false
	jmp	check
	.text
true:
	movq	$1, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	main
main:
	pushq	%rbp
	movq	%rsp, %rbp
	leaq	glist(%rip), %rsi
	movq	$3, %rdi
	callq	search
	movq	%rax, %rdi
	movq	%rdi, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	