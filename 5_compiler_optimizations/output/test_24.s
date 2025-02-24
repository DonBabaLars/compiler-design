	.text
	.globl	bar
bar:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rcx, %r11
	pushq	24(%rbp)
	popq	-16(%rbp)
	addq	%rsi, %rdi
	addq	%rdx, %rdi
	addq	%r11, %rdi
	addq	%r8 , %rdi
	addq	%r9 , %rdi
	addq	16(%rbp), %rdi
	addq	-16(%rbp), %rdi
	movq	%rdi, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	foo
foo:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rdi
	pushq	%rdi
	movq	%rdi, %r9 
	movq	%rdi, %r8 
	movq	%rdi, %rcx
	movq	%rdi, %rdx
	movq	%rdi, %rsi
	callq	bar
	addq	$16, %rsp
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
	movq	$3, %rdi
	callq	foo
	movq	%rax, %rdi
	movq	%rdi, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	