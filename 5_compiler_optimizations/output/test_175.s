	.text
	.globl	f
f:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$8, %rsp
	movq	%rsp, %r8 
	subq	$8, %rsp
	movq	%rsp, %rdx
	movq	%rdi, (%r8 )
	movq	$0, %rax
	movq	%rdx, %rcx
	movq	%rax, (%rcx)
	movq	(%r8 ), %rdi
	cmpq	$0, %rdi
	sete	%dil
	andq	$1, %rdi
	cmpq	$0, %rdi
	jne	_then2792
	jmp	_else2791
	.text
_else2791:
	movq	(%r8 ), %rsi
	movq	(%r8 ), %rdi
	subq	$1, %rdi
	pushq	%rsi
	pushq	%rdx
	callq	f
	popq	%rdx
	popq	%rsi
	movq	%rax, %rdi
	imulq	%rsi, %rdi
	movq	%rdi, (%rdx)
	jmp	_merge2790
	.text
_merge2790:
	movq	(%rdx), %rdi
	movq	%rdi, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
_then2792:
	movq	$1, %rax
	movq	%rdx, %rcx
	movq	%rax, (%rcx)
	jmp	_merge2790
	.text
	.globl	program
program:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	$5, %rdi
	callq	f
	movq	%rax, %rdi
	movq	%rdi, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	