	.text
	.globl	program
program:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$8, %rsp
	movq	%rsp, %r10
	subq	$8, %rsp
	movq	%rsp, %rdi
	subq	$8, %rsp
	movq	%rsp, %r9 
	subq	$8, %rsp
	movq	%rsp, %rsi
	subq	$8, %rsp
	movq	%rsp, %rdx
	pushq	%r10
	pushq	%r9 
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	$5, %rdi
	callq	oat_alloc_array
	popq	%rdx
	popq	%rsi
	popq	%rdi
	popq	%r9 
	popq	%r10
	movq	%rax, %r8 
	movq	%r8 , %rax
	movq	%rax, %r8 
	movq	%r8 , %rax
	addq	$0, %rax
	addq	$8, %rax
	addq	$0, %rax
	movq	%rax, %r11
	movq	$111, %rax
	movq	%r11, %rcx
	movq	%rax, (%rcx)
	movq	%r8 , %rax
	addq	$0, %rax
	addq	$8, %rax
	addq	$8, %rax
	movq	%rax, %r11
	movq	$112, %rax
	movq	%r11, %rcx
	movq	%rax, (%rcx)
	movq	%r8 , %rax
	addq	$0, %rax
	addq	$8, %rax
	addq	$16, %rax
	movq	%rax, %r11
	movq	$113, %rax
	movq	%r11, %rcx
	movq	%rax, (%rcx)
	movq	%r8 , %rax
	addq	$0, %rax
	addq	$8, %rax
	addq	$24, %rax
	movq	%rax, %r11
	movq	$114, %rax
	movq	%r11, %rcx
	movq	%rax, (%rcx)
	movq	%r8 , %rax
	addq	$0, %rax
	addq	$8, %rax
	addq	$32, %rax
	movq	%rax, %r11
	movq	$115, %rax
	movq	%r11, %rcx
	movq	%rax, (%rcx)
	movq	%r8 , (%r10)
	movq	(%r10), %r8 
	pushq	%r9 
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	%r8 , %rdi
	callq	string_of_array
	popq	%rdx
	popq	%rsi
	popq	%rdi
	popq	%r9 
	movq	%rax, %r8 
	movq	%r8 , (%rdi)
	movq	(%rdi), %rdi
	pushq	%r9 
	pushq	%rsi
	pushq	%rdx
	callq	array_of_string
	popq	%rdx
	popq	%rsi
	popq	%r9 
	movq	%rax, %rdi
	movq	%rdi, (%r9 )
	movq	$0, %rax
	movq	%rsi, %rcx
	movq	%rax, (%rcx)
	movq	$0, %rax
	movq	%rdx, %rcx
	movq	%rax, (%rcx)
	jmp	_cond2319
	.text
_body2318:
	movq	(%rsi), %rdi
	movq	(%r9 ), %r11
	movq	(%rdx), %r10
	movq	%r11, %rax
	movq	%rax, %r8 
	pushq	%r11
	pushq	%r10
	pushq	%r9 
	pushq	%r8 
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	%r10, %rsi
	movq	%r8 , %rdi
	callq	oat_assert_array_length
	popq	%rdx
	popq	%rsi
	popq	%rdi
	popq	%r8 
	popq	%r9 
	popq	%r10
	popq	%r11
	movq	%r11, %rax
	addq	$0, %rax
	addq	$8, %rax
	movq	%rax, %rcx
	movq	%r10, %rax
	imulq	$8, %rax
	addq	%rcx, %rax
	movq	%rax, %r8 
	movq	(%r8 ), %r8 
	addq	%r8 , %rdi
	movq	%rdi, (%rsi)
	movq	(%rdx), %rdi
	addq	$1, %rdi
	movq	%rdi, (%rdx)
	jmp	_cond2319
	.text
_cond2319:
	movq	(%rdx), %rdi
	cmpq	$5, %rdi
	setl	%dil
	andq	$1, %rdi
	cmpq	$0, %rdi
	jne	_body2318
	jmp	_post2317
	.text
_post2317:
	movq	(%rsi), %rdi
	movq	%rdi, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	