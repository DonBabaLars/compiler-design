	.data
	.globl	arr1
arr1:
	.quad	_global_arr5357
	.data
	.globl	_global_arr5357
_global_arr5357:
	.quad	4
	.quad	1
	.quad	2
	.quad	3
	.quad	4
	.data
	.globl	arr2
arr2:
	.quad	_global_arr5356
	.data
	.globl	_global_arr5356
_global_arr5356:
	.quad	4
	.quad	1
	.quad	2
	.quad	3
	.quad	5
	.text
	.globl	arrcheck
arrcheck:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	subq	$8, %rsp
	movq	%rsp, %r11
	subq	$8, %rsp
	movq	%rsp, %r10
	subq	$8, %rsp
	movq	%rsp, %r8 
	subq	$8, %rsp
	movq	%rsp, -8(%rbp)
	subq	$8, %rsp
	movq	%rsp, %r9 
	movq	%rdi, (%r11)
	movq	%rsi, (%r10)
	movq	%rdx, (%r8 )
	movq	$0, %rax
	movq	-8(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	$0, %rax
	movq	%r9 , %rcx
	movq	%rax, (%rcx)
	jmp	_cond5334
	.text
_body5333:
	movq	(%r11), %rdx
	movq	(%r9 ), %rsi
	movq	%rdx, %rax
	movq	%rax, %rdi
	pushq	%r11
	pushq	%r10
	pushq	%r9 
	pushq	%r8 
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	callq	oat_assert_array_length
	popq	%rdx
	popq	%rsi
	popq	%rdi
	popq	%r8 
	popq	%r9 
	popq	%r10
	popq	%r11
	movq	%rdx, %rax
	addq	$0, %rax
	addq	$8, %rax
	movq	%rax, %rcx
	movq	%rsi, %rax
	imulq	$8, %rax
	addq	%rcx, %rax
	movq	%rax, %rdi
	movq	(%rdi), %rdi
	movq	(%r10), %rdx
	movq	(%r9 ), %rsi
	movq	%rdx, %rax
	movq	%rax, -16(%rbp)
	pushq	%r11
	pushq	%r10
	pushq	%r9 
	pushq	%r8 
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	-16(%rbp), %rdi
	callq	oat_assert_array_length
	popq	%rdx
	popq	%rsi
	popq	%rdi
	popq	%r8 
	popq	%r9 
	popq	%r10
	popq	%r11
	movq	%rdx, %rax
	addq	$0, %rax
	addq	$8, %rax
	movq	%rax, %rcx
	movq	%rsi, %rax
	imulq	$8, %rax
	addq	%rcx, %rax
	movq	%rax, %rsi
	movq	(%rsi), %rsi
	cmpq	%rsi, %rdi
	setne	%dil
	andq	$1, %rdi
	cmpq	$0, %rdi
	jne	_then5351
	jmp	_else5350
	.text
_cond5334:
	movq	(%r9 ), %rsi
	movq	(%r8 ), %rdi
	cmpq	%rdi, %rsi
	setl	%dil
	andq	$1, %rdi
	cmpq	$0, %rdi
	jne	_body5333
	jmp	_post5332
	.text
_else5350:
	jmp	_merge5349
	.text
_merge5349:
	movq	(%r9 ), %rdi
	addq	$1, %rdi
	movq	%rdi, (%r9 )
	jmp	_cond5334
	.text
_post5332:
	movq	-8(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	movq	%rdi, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
_then5351:
	movq	$1, %rax
	movq	-8(%rbp), %rcx
	movq	%rax, (%rcx)
	jmp	_merge5349
	.text
	.globl	program
program:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$8, %rsp
	movq	%rsp, %rdi
	movq	$1, %rax
	movq	%rdi, %rcx
	movq	%rax, (%rcx)
	leaq	arr2(%rip), %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
	leaq	arr1(%rip), %rax
	movq	(%rax), %rax
	movq	%rax, %rdx
	pushq	%rdi
	pushq	%rdx
	movq	%rdx, %rdi
	movq	$4, %rdx
	callq	arrcheck
	popq	%rdx
	popq	%rdi
	movq	%rax, %rsi
	cmpq	$1, %rsi
	sete	%sil
	andq	$1, %rsi
	cmpq	$0, %rsi
	jne	_then5314
	jmp	_else5313
	.text
_else5313:
	jmp	_merge5312
	.text
_merge5312:
	movq	(%rdi), %rdi
	movq	%rdi, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
_then5314:
	movq	$0, %rax
	movq	%rdi, %rcx
	movq	%rax, (%rcx)
	jmp	_merge5312