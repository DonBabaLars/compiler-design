	.text
	.globl	create_pair
create_pair:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$8, %rsp
	movq	%rsp, %r8 
	subq	$8, %rsp
	movq	%rsp, %rdx
	movq	%rdi, (%r8 )
	movq	%rsi, (%rdx)
	pushq	%r8 
	pushq	%rdx
	movq	$16, %rdi
	callq	oat_malloc
	popq	%rdx
	popq	%r8 
	movq	%rax, %rdi
	movq	%rdi, %rax
	movq	%rax, %rdi
	movq	(%r8 ), %r8 
	movq	%rdi, %rax
	addq	$0, %rax
	addq	$0, %rax
	movq	%rax, %rsi
	movq	%r8 , (%rsi)
	movq	(%rdx), %rdx
	movq	%rdi, %rax
	addq	$0, %rax
	addq	$8, %rax
	movq	%rax, %rsi
	movq	%rdx, (%rsi)
	movq	%rdi, %rax
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
	pushq	%rdx
	movq	$0, %rsi
	movq	$1, %rdi
	callq	create_pair
	popq	%rdx
	movq	%rax, %rdi
	movq	%rdi, (%rdx)
	movq	(%rdx), %rdi
	movq	%rdi, %rax
	addq	$0, %rax
	addq	$0, %rax
	movq	%rax, %rdi
	movq	(%rdi), %rsi
	movq	(%rdx), %rdi
	movq	%rdi, %rax
	addq	$0, %rax
	addq	$8, %rax
	movq	%rax, %rdi
	movq	(%rdi), %rdi
	andq	%rsi, %rdi
	cmpq	$0, %rdi
	jne	_then6802
	jmp	_else6801
	.text
_else6801:
	movq	$0, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
_merge6800:
	movq	$0, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
_then6802:
	movq	$1, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	