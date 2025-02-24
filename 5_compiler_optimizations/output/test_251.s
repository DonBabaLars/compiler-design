	.data
	.globl	x
x:
	.quad	_global_arr8801
	.data
	.globl	_global_arr8801
_global_arr8801:
	.quad	3
	.quad	1
	.quad	2
	.quad	3
	.data
	.globl	y
y:
	.quad	_global_arr8800
	.data
	.globl	_global_arr8800
_global_arr8800:
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
	jne	_then8816
	jmp	_else8815
	.text
_else8815:
	movq	(%r8 ), %rdi
	movq	%rdi, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
_merge8814:
	movq	$0, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
_then8816:
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
	subq	$8, %rsp
	movq	%rsp, %rdi
	leaq	y(%rip), %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
	leaq	x(%rip), %rax
	movq	(%rax), %rax
	movq	%rax, %rdx
	pushq	%rdi
	pushq	%rsi
	movq	%rdx, %rdi
	movq	$1, %rdx
	callq	f
	popq	%rsi
	popq	%rdi
	movq	%rax, %rdx
	movq	%rdx, %rax
	movq	%rax, %rsi
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	%rsi, %rdi
	movq	$0, %rsi
	callq	oat_assert_array_length
	popq	%rdx
	popq	%rsi
	popq	%rdi
	movq	%rdx, %rax
	addq	$0, %rax
	addq	$8, %rax
	addq	$0, %rax
	movq	%rax, %rsi
	movq	$17, %rax
	movq	%rsi, %rcx
	movq	%rax, (%rcx)
	leaq	y(%rip), %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
	leaq	x(%rip), %rax
	movq	(%rax), %rax
	movq	%rax, %rdx
	pushq	%rdi
	pushq	%rsi
	movq	%rdx, %rdi
	movq	$1, %rdx
	callq	f
	popq	%rsi
	popq	%rdi
	movq	%rax, %rdx
	movq	%rdx, %rax
	movq	%rax, %rsi
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	%rsi, %rdi
	movq	$0, %rsi
	callq	oat_assert_array_length
	popq	%rdx
	popq	%rsi
	popq	%rdi
	movq	%rdx, %rax
	addq	$0, %rax
	addq	$8, %rax
	addq	$0, %rax
	movq	%rax, %rsi
	movq	(%rsi), %rsi
	leaq	x(%rip), %rax
	movq	(%rax), %rax
	movq	%rax, %r8 
	leaq	y(%rip), %rax
	movq	(%rax), %rax
	movq	%rax, %rdx
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	%r8 , %rsi
	movq	%rdx, %rdi
	movq	$0, %rdx
	callq	f
	popq	%rdx
	popq	%rsi
	popq	%rdi
	movq	%rax, %r8 
	movq	%r8 , %rax
	movq	%rax, %rdx
	pushq	%r8 
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	$0, %rsi
	movq	%rdx, %rdi
	callq	oat_assert_array_length
	popq	%rdx
	popq	%rsi
	popq	%rdi
	popq	%r8 
	movq	%r8 , %rax
	addq	$0, %rax
	addq	$8, %rax
	addq	$0, %rax
	movq	%rax, %rdx
	movq	(%rdx), %rdx
	addq	%rdx, %rsi
	movq	%rsi, (%rdi)
	movq	(%rdi), %rdi
	movq	%rdi, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	