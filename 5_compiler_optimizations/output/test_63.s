	.data
	.globl	x
x:
	.quad	_global_arr138
	.data
	.globl	_global_arr138
_global_arr138:
	.quad	3
	.quad	1
	.quad	2
	.quad	3
	.data
	.globl	y
y:
	.quad	_global_arr137
	.data
	.globl	_global_arr137
_global_arr137:
	.quad	3
	.quad	4
	.quad	5
	.quad	6
	.text
	.globl	f
f:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$8, %rsp
	movq	%rsp, %r9 
	subq	$8, %rsp
	movq	%rsp, %r8 
	subq	$8, %rsp
	movq	%rsp, %r10
	movq	%rdi, (%r9 )
	movq	%rsi, (%r8 )
	movq	%rdx, (%r10)
	movq	(%r10), %rdi
	cmpq	$0, %rdi
	jne	_then153
	jmp	_else152
	.text
_else152:
	movq	(%r8 ), %rdi
	movq	%rdi, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
_merge151:
	movq	$0, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
_then153:
	movq	(%r9 ), %rdi
	movq	%rdi, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	program
program:
	pushq	%rbp
	movq	%rsp, %rbp
	leaq	y(%rip), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	leaq	x(%rip), %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
	pushq	%rdi
	movq	$1, %rdx
	pushq	%rdi
	movq	%rsi, %rdi
	popq	%rsi
	callq	f
	popq	%rdi
	movq	%rax, %rsi
	movq	%rsi, %rax
	movq	%rax, %rdi
	pushq	%rdi
	pushq	%rsi
	movq	$0, %rsi
	callq	oat_assert_array_length
	popq	%rsi
	popq	%rdi
	movq	%rsi, %rax
	addq	$0, %rax
	addq	$8, %rax
	addq	$0, %rax
	movq	%rax, %rdi
	movq	$17, %rax
	movq	%rdi, %rcx
	movq	%rax, (%rcx)
	leaq	x(%rip), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	movq	%rdi, %rax
	movq	%rax, %rsi
	pushq	%rdi
	pushq	%rsi
	movq	%rsi, %rdi
	movq	$0, %rsi
	callq	oat_assert_array_length
	popq	%rsi
	popq	%rdi
	movq	%rdi, %rax
	addq	$0, %rax
	addq	$8, %rax
	addq	$0, %rax
	movq	%rax, %rdi
	movq	(%rdi), %rdi
	movq	%rdi, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	