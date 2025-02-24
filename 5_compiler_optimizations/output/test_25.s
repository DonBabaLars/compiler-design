	.text
	.globl	baz
baz:
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
	.globl	bar
bar:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rcx, %r11
	pushq	24(%rbp)
	popq	-16(%rbp)
	addq	%rsi, %rdi
	addq	%rdi, %rdx
	addq	%rdx, %r11
	movq	%r11, %rsi
	addq	%r8 , %rsi
	pushq	%r11
	pushq	%r9 
	pushq	%r8 
	pushq	%rsi
	pushq	%rdx
	pushq	-16(%rbp)
	pushq	16(%rbp)
	movq	%rsi, %rcx
	movq	%rdx, %rsi
	movq	%r11, %rdx
	callq	baz
	addq	$16, %rsp
	popq	%rdx
	popq	%rsi
	popq	%r8 
	popq	%r9 
	popq	%r11
	movq	%rax, %rdi
	addq	%r9 , %rsi
	addq	16(%rbp), %rsi
	addq	-16(%rbp), %rsi
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
	movq	$1, %rdi
	callq	foo
	movq	%rax, %rdi
	movq	%rdi, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	