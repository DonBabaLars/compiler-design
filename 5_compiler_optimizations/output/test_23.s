	.text
	.globl	bar
bar:
	pushq	%rbp
	movq	%rsp, %rbp
	addq	%rsi, %rdi
	movq	%rdi, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	foo
foo:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, %rsi
	callq	bar
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
	movq	$17, %rdi
	callq	foo
	movq	%rax, %rdi
	movq	%rdi, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	