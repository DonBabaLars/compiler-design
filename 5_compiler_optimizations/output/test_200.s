	.data
	.globl	arr_x
arr_x:
	.quad	_global_arr6851
	.data
	.globl	_global_arr6851
_global_arr6851:
	.quad	3
	.quad	3
	.quad	4
	.quad	5
	.data
	.globl	arr_z
arr_z:
	.quad	_global_arr6850
	.data
	.globl	_global_arr6850
_global_arr6850:
	.quad	3
	.quad	4
	.quad	5
	.quad	6
	.text
	.globl	program
program:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$8, %rsp
	movq	%rsp, %rdi
	pushq	%rdi
	movq	$24, %rdi
	callq	oat_malloc
	popq	%rdi
	movq	%rax, %rsi
	movq	%rsi, %rax
	movq	%rax, %rsi
	leaq	arr_x(%rip), %rax
	movq	(%rax), %rax
	movq	%rax, %r8 
	movq	%rsi, %rax
	addq	$0, %rax
	addq	$0, %rax
	movq	%rax, %rdx
	movq	%r8 , (%rdx)
	movq	%rsi, %rax
	addq	$0, %rax
	addq	$8, %rax
	movq	%rax, %rdx
	movq	$3, %rax
	movq	%rdx, %rcx
	movq	%rax, (%rcx)
	leaq	arr_z(%rip), %rax
	movq	(%rax), %rax
	movq	%rax, %r8 
	movq	%rsi, %rax
	addq	$0, %rax
	addq	$16, %rax
	movq	%rax, %rdx
	movq	%r8 , (%rdx)
	movq	%rsi, (%rdi)
	movq	(%rdi), %rsi
	movq	%rsi, %rax
	addq	$0, %rax
	addq	$0, %rax
	movq	%rax, %rsi
	movq	(%rsi), %rdx
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
	movq	(%rdi), %rdi
	movq	%rdi, %rax
	addq	$0, %rax
	addq	$16, %rax
	movq	%rax, %rdi
	movq	(%rdi), %rdx
	movq	%rdx, %rax
	movq	%rax, %rdi
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	$1, %rsi
	callq	oat_assert_array_length
	popq	%rdx
	popq	%rsi
	popq	%rdi
	movq	%rdx, %rax
	addq	$0, %rax
	addq	$8, %rax
	addq	$8, %rax
	movq	%rax, %rdi
	movq	(%rdi), %rdi
	imulq	%rsi, %rdi
	movq	%rdi, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	