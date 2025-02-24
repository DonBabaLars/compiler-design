	.data
	.globl	i
i:
	.quad	0
	.text
	.globl	f
f:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$8, %rsp
	movq	%rsp, %r8 
	subq	$8, %rsp
	movq	%rsp, %rdx
	subq	$8, %rsp
	movq	%rsp, %r9 
	movq	%rdi, (%r8 )
	movq	%rsi, (%rdx)
	movq	$0, %rax
	movq	%r9 , %rcx
	movq	%rax, (%rcx)
	movq	(%r8 ), %rdi
	cmpq	$1, %rdi
	setge	%dil
	andq	$1, %rdi
	cmpq	$0, %rdi
	jne	_then930
	jmp	_else929
	.text
_else929:
	movq	(%r8 ), %rsi
	movq	(%rdx), %rdi
	addq	%rsi, %rdi
	movq	%rdi, (%r9 )
	jmp	_merge928
	.text
_merge928:
	movq	(%r9 ), %rdi
	movq	%rdi, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
_then930:
	movq	(%rdx), %rdi
	movq	(%r8 ), %rsi
	subq	$1, %rsi
	pushq	%r9 
	pushq	%rsi
	pushq	%rdi
	movq	%rsi, %rdi
	popq	%rsi
	callq	f
	popq	%rsi
	popq	%r9 
	movq	%rax, %rdi
	addq	$1, %rdi
	movq	%rdi, (%r9 )
	jmp	_merge928
	.text
	.globl	program
program:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$8, %rsp
	movq	%rsp, %rsi
	subq	$8, %rsp
	movq	%rsp, %rdi
	movq	$3, %rax
	movq	%rsi, %rcx
	movq	%rax, (%rcx)
	movq	$3, %rax
	movq	%rdi, %rcx
	movq	%rax, (%rcx)
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	pushq	%rsi
	pushq	%rdi
	movq	%rsi, %rdi
	popq	%rsi
	callq	f
	popq	%rsi
	movq	%rax, %rdi
	leaq	i(%rip), %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
	addq	%rsi, %rdi
	movq	%rdi, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	