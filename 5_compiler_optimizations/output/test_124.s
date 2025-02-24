	.text
	.globl	gcd_rec
gcd_rec:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$8, %rsp
	movq	%rsp, %r8 
	movq	%rdi, (%r8 )
	cmpq	$0, %rsi
	setne	%dl
	andq	$1, %rdx
	cmpq	$0, %rdx
	jne	neq0
	jmp	eq0
	.text
eq0:
	movq	%rdi, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
neq0:
	movq	(%r8 ), %rdi
	movq	%rdi, %rdx
	subq	%rsi, %rdx
	movq	%rdx, (%r8 )
	cmpq	%rsi, %rdx
	setg	%dil
	andq	$1, %rdi
	cmpq	$0, %rdi
	jne	neq0
	jmp	recurse
	.text
recurse:
	pushq	%rsi
	pushq	%rdx
	movq	%rsi, %rdi
	movq	%rdx, %rsi
	callq	gcd_rec
	popq	%rdx
	popq	%rsi
	movq	%rax, %rdi
	movq	%rdi, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	main
main:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	$34, %rsi
	movq	$424, %rdi
	callq	gcd_rec
	movq	%rax, %rdi
	movq	%rdi, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	