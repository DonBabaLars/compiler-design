	.data
	.globl	_str_arr2201
_str_arr2201:
	.asciz	"hello"
	.text
	.globl	program
program:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$8, %rsp
	movq	%rsp, %rdi
	subq	$8, %rsp
	movq	%rsp, %r8 
	subq	$8, %rsp
	movq	%rsp, %rsi
	subq	$8, %rsp
	movq	%rsp, %rdx
	leaq	_str_arr2201(%rip), %rax
	addq	$0, %rax
	addq	$0, %rax
	movq	%rax, %r9 
	movq	%r9 , (%rdi)
	movq	(%rdi), %rdi
	pushq	%r8 
	pushq	%rsi
	pushq	%rdx
	callq	array_of_string
	popq	%rdx
	popq	%rsi
	popq	%r8 
	movq	%rax, %rdi
	movq	%rdi, (%r8 )
	movq	$0, %rax
	movq	%rsi, %rcx
	movq	%rax, (%rcx)
	movq	$0, %rax
	movq	%rdx, %rcx
	movq	%rax, (%rcx)
	jmp	_cond2217
	.text
_body2216:
	movq	(%rsi), %rdi
	movq	(%r8 ), %r11
	movq	(%rdx), %r10
	movq	%r11, %rax
	movq	%rax, %r9 
	pushq	%r11
	pushq	%r10
	pushq	%r9 
	pushq	%r8 
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	%r10, %rsi
	movq	%r9 , %rdi
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
	movq	%rax, %r9 
	movq	(%r9 ), %r9 
	addq	%r9 , %rdi
	movq	%rdi, (%rsi)
	movq	(%rdx), %rdi
	addq	$1, %rdi
	movq	%rdi, (%rdx)
	jmp	_cond2217
	.text
_cond2217:
	movq	(%rdx), %rdi
	cmpq	$5, %rdi
	setl	%dil
	andq	$1, %rdi
	cmpq	$0, %rdi
	jne	_body2216
	jmp	_post2215
	.text
_post2215:
	movq	(%rsi), %rdi
	movq	%rdi, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	