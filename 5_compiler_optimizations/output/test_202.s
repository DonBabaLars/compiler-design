	.data
	.globl	_str_arr6899
_str_arr6899:
	.asciz	"hello"
	.text
	.globl	neg
neg:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$8, %rsp
	movq	%rsp, %rdx
	movq	%rdi, (%rdx)
	movq	(%rdx), %rdi
	movq	$0, %rax
	subq	%rdi, %rax
	movq	%rax, %rdi
	movq	%rdi, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	program
program:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	subq	$8, %rsp
	movq	%rsp, %rdx
	subq	$8, %rsp
	movq	%rsp, %rsi
	pushq	%rsi
	pushq	%rdx
	movq	$48, %rdi
	callq	oat_malloc
	popq	%rdx
	popq	%rsi
	movq	%rax, %rdi
	movq	%rdi, %rax
	movq	%rax, -8(%rbp)
	movq	-8(%rbp), %rax
	addq	$0, %rax
	addq	$0, %rax
	movq	%rax, %rdi
	movq	$3, %rax
	movq	%rdi, %rcx
	movq	%rax, (%rcx)
	movq	-8(%rbp), %rax
	addq	$0, %rax
	addq	$8, %rax
	movq	%rax, %rdi
	movq	$1, %rax
	movq	%rdi, %rcx
	movq	%rax, (%rcx)
	leaq	_str_arr6899(%rip), %rax
	addq	$0, %rax
	addq	$0, %rax
	movq	%rax, %rdi
	movq	-8(%rbp), %rax
	addq	$0, %rax
	addq	$16, %rax
	movq	%rax, %r8 
	movq	%rdi, (%r8 )
	pushq	%rsi
	pushq	%rdx
	movq	$3, %rdi
	callq	oat_alloc_array
	popq	%rdx
	popq	%rsi
	movq	%rax, %rdi
	movq	%rdi, %rax
	movq	%rax, %r9 
	subq	$8, %rsp
	movq	%rsp, %r8 
	movq	$3, %rax
	movq	%r8 , %rcx
	movq	%rax, (%rcx)
	subq	$8, %rsp
	movq	%rsp, %rdi
	movq	%r9 , (%rdi)
	movq	$0, %rax
	movq	%rdx, %rcx
	movq	%rax, (%rcx)
	jmp	_cond6914
	.text
_body6913:
	movq	(%rdi), %r11
	movq	(%rdx), %r10
	movq	%r11, %rax
	movq	%rax, -16(%rbp)
	pushq	%r11
	pushq	%r10
	pushq	%r9 
	pushq	%r8 
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	%r10, %rsi
	movq	-16(%rbp), %rdi
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
	movq	%rax, %r10
	movq	$0, %rax
	movq	%r10, %rcx
	movq	%rax, (%rcx)
	movq	(%rdx), %r10
	addq	$1, %r10
	movq	%r10, (%rdx)
	jmp	_cond6914
	.text
_cond6914:
	movq	(%rdx), %r10
	movq	(%r8 ), %r11
	cmpq	%r11, %r10
	setl	%r10b
	andq	$1, %r10
	cmpq	$0, %r10
	jne	_body6913
	jmp	_post6912
	.text
_else6952:
	movq	(%rsi), %rdi
	movq	%rdi, %rax
	addq	$0, %rax
	addq	$0, %rax
	movq	%rax, %rdi
	movq	(%rdi), %rdi
	movq	%rdi, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
_merge6951:
	movq	$0, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
_post6912:
	movq	-8(%rbp), %rax
	addq	$0, %rax
	addq	$24, %rax
	movq	%rax, %rdi
	movq	%r9 , (%rdi)
	movq	-8(%rbp), %rax
	addq	$0, %rax
	addq	$32, %rax
	movq	%rax, %rdi
	movq	$0, %rax
	movq	%rdi, %rcx
	movq	%rax, (%rcx)
	movq	-8(%rbp), %rax
	addq	$0, %rax
	addq	$40, %rax
	movq	%rax, %rdi
	leaq	neg(%rip), %rax
	movq	%rdi, %rcx
	movq	%rax, (%rcx)
	movq	-8(%rbp), %rax
	movq	%rsi, %rcx
	movq	%rax, (%rcx)
	movq	(%rsi), %rdi
	movq	%rdi, %rax
	addq	$0, %rax
	addq	$16, %rax
	movq	%rax, %rdi
	movq	(%rdi), %rdi
	pushq	%rdi
	pushq	%rsi
	callq	print_string
	popq	%rsi
	popq	%rdi
	movq	(%rsi), %rdi
	movq	%rdi, %rax
	addq	$0, %rax
	addq	$8, %rax
	movq	%rax, %rdi
	movq	(%rdi), %rdi
	cmpq	$0, %rdi
	jne	_then6953
	jmp	_else6952
	.text
_then6953:
	movq	(%rsi), %rdi
	movq	%rdi, %rax
	addq	$0, %rax
	addq	$40, %rax
	movq	%rax, %rdi
	movq	(%rdi), %rdx
	movq	(%rsi), %rdi
	movq	%rdi, %rax
	addq	$0, %rax
	addq	$0, %rax
	movq	%rax, %rdi
	movq	(%rdi), %rdi
	pushq	%r15
	movq	%rdx, %r15
	pushq	%rdx
	callq	*%r15
	popq	%rdx
	popq	%r15
	movq	%rax, %rdi
	movq	%rdi, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	