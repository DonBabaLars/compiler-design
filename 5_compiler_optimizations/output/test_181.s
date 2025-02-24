	.data
	.globl	_str_arr4037
_str_arr4037:
	.asciz	"Correct!"
	.text
	.globl	euclid_division
euclid_division:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$8, %rsp
	movq	%rsp, %r9 
	subq	$8, %rsp
	movq	%rsp, %r10
	subq	$8, %rsp
	movq	%rsp, %r8 
	subq	$8, %rsp
	movq	%rsp, %rdx
	movq	%rdi, (%r9 )
	movq	%rsi, (%r10)
	movq	(%r10), %rdi
	cmpq	$0, %rdi
	setl	%dil
	andq	$1, %rdi
	cmpq	$0, %rdi
	jne	_then4116
	jmp	_else4115
	.text
_body4131:
	movq	(%r8 ), %rdi
	addq	$1, %rdi
	movq	%rdi, (%r8 )
	movq	(%rdx), %rdi
	movq	(%r10), %rsi
	subq	%rsi, %rdi
	movq	%rdi, (%rdx)
	jmp	_cond4132
	.text
_body4157:
	movq	(%r8 ), %rdi
	addq	$1, %rdi
	movq	%rdi, (%r8 )
	movq	(%rdx), %rdi
	movq	(%r10), %rsi
	subq	%rsi, %rdi
	movq	%rdi, (%rdx)
	jmp	_cond4158
	.text
_cond4132:
	movq	(%rdx), %rdi
	movq	(%r10), %rsi
	cmpq	%rsi, %rdi
	setge	%dil
	andq	$1, %rdi
	cmpq	$0, %rdi
	jne	_body4131
	jmp	_post4130
	.text
_cond4158:
	movq	(%rdx), %rdi
	movq	(%r10), %rsi
	cmpq	%rsi, %rdi
	setge	%dil
	andq	$1, %rdi
	cmpq	$0, %rdi
	jne	_body4157
	jmp	_post4156
	.text
_else4115:
	jmp	_merge4114
	.text
_else4148:
	movq	(%r8 ), %rdi
	movq	$0, %rax
	subq	%rdi, %rax
	movq	%rax, %rdi
	subq	$1, %rdi
	movq	%rdi, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
_else4151:
	jmp	_merge4150
	.text
_merge4114:
	movq	$0, %rax
	movq	%r8 , %rcx
	movq	%rax, (%rcx)
	movq	(%r9 ), %rdi
	movq	%rdi, (%rdx)
	movq	(%r9 ), %rdi
	cmpq	$0, %rdi
	setl	%dil
	andq	$1, %rdi
	cmpq	$0, %rdi
	jne	_then4152
	jmp	_else4151
	.text
_merge4147:
	jmp	_merge4150
	.text
_merge4150:
	jmp	_cond4158
	.text
_post4130:
	movq	(%rdx), %rdi
	cmpq	$0, %rdi
	sete	%dil
	andq	$1, %rdi
	cmpq	$0, %rdi
	jne	_then4149
	jmp	_else4148
	.text
_post4156:
	movq	(%r8 ), %rdi
	movq	%rdi, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
_then4116:
	movq	(%r10), %rdi
	movq	$0, %rax
	subq	%rdi, %rax
	movq	%rax, %rdi
	movq	(%r9 ), %rsi
	pushq	%rsi
	pushq	%rdi
	movq	%rsi, %rdi
	popq	%rsi
	callq	euclid_division
	popq	%rsi
	movq	%rax, %rdi
	movq	$0, %rax
	subq	%rdi, %rax
	movq	%rax, %rdi
	movq	%rdi, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
_then4149:
	movq	(%r8 ), %rdi
	movq	$0, %rax
	subq	%rdi, %rax
	movq	%rax, %rdi
	movq	%rdi, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
_then4152:
	movq	(%r9 ), %rdi
	movq	$0, %rax
	subq	%rdi, %rax
	movq	%rax, %rdi
	movq	%rdi, (%rdx)
	jmp	_cond4132
	.text
	.globl	binary_search
binary_search:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$24, %rsp
	movq	%rdx, -16(%rbp)
	movq	%rcx, %rdx
	subq	$8, %rsp
	movq	%rsp, %r11
	subq	$8, %rsp
	movq	%rsp, %r10
	subq	$8, %rsp
	movq	%rsp, -24(%rbp)
	subq	$8, %rsp
	movq	%rsp, %r9 
	subq	$8, %rsp
	movq	%rsp, %r8 
	movq	%rdi, (%r11)
	movq	%rsi, (%r10)
	movq	-16(%rbp), %rax
	movq	-24(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	%rdx, (%r9 )
	movq	(%r9 ), %rdi
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
	cmpq	%rsi, %rdi
	setl	%dil
	andq	$1, %rdi
	cmpq	$0, %rdi
	jne	_then4060
	jmp	_else4059
	.text
_else4059:
	jmp	_merge4058
	.text
_else4082:
	jmp	_merge4081
	.text
_else4099:
	movq	$1, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
_merge4058:
	movq	(%r9 ), %rdi
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
	addq	%rsi, %rdi
	pushq	%r11
	pushq	%r10
	pushq	%r9 
	pushq	%r8 
	movq	$2, %rsi
	callq	euclid_division
	popq	%r8 
	popq	%r9 
	popq	%r10
	popq	%r11
	movq	%rax, %rdi
	movq	%rdi, (%r8 )
	movq	(%r11), %rsi
	movq	(%r8 ), %rdi
	movq	%rsi, %rax
	movq	%rax, %rdx
	pushq	%r11
	pushq	%r10
	pushq	%r9 
	pushq	%r8 
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	%rdi, %rsi
	movq	%rdx, %rdi
	callq	oat_assert_array_length
	popq	%rdx
	popq	%rsi
	popq	%rdi
	popq	%r8 
	popq	%r9 
	popq	%r10
	popq	%r11
	movq	%rsi, %rax
	addq	$0, %rax
	addq	$8, %rax
	movq	%rax, %rcx
	movq	%rdi, %rax
	imulq	$8, %rax
	addq	%rcx, %rax
	movq	%rax, %rdi
	movq	(%rdi), %rsi
	movq	(%r10), %rdi
	cmpq	%rdi, %rsi
	setg	%dil
	andq	$1, %rdi
	cmpq	$0, %rdi
	jne	_then4083
	jmp	_else4082
	.text
_merge4081:
	movq	(%r11), %rsi
	movq	(%r8 ), %rdi
	movq	%rsi, %rax
	movq	%rax, %rdx
	pushq	%r11
	pushq	%r10
	pushq	%r9 
	pushq	%r8 
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	%rdi, %rsi
	movq	%rdx, %rdi
	callq	oat_assert_array_length
	popq	%rdx
	popq	%rsi
	popq	%rdi
	popq	%r8 
	popq	%r9 
	popq	%r10
	popq	%r11
	movq	%rsi, %rax
	addq	$0, %rax
	addq	$8, %rax
	movq	%rax, %rcx
	movq	%rdi, %rax
	imulq	$8, %rax
	addq	%rcx, %rax
	movq	%rax, %rdi
	movq	(%rdi), %rsi
	movq	(%r10), %rdi
	cmpq	%rdi, %rsi
	setl	%dil
	andq	$1, %rdi
	cmpq	$0, %rdi
	jne	_then4100
	jmp	_else4099
	.text
_merge4098:
	movq	$0, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
_then4060:
	movq	$0, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
_then4083:
	movq	(%r8 ), %rdi
	movq	%rdi, %rdx
	subq	$1, %rdx
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r8 
	movq	(%r10), %rdi
	movq	(%r11), %rsi
	pushq	%r8 
	pushq	%rsi
	pushq	%rdx
	movq	%rdx, %rcx
	movq	%r8 , %rdx
	pushq	%rdi
	movq	%rsi, %rdi
	popq	%rsi
	callq	binary_search
	popq	%rdx
	popq	%rsi
	popq	%r8 
	movq	%rax, %rdi
	movq	%rdi, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
_then4100:
	movq	(%r9 ), %rdi
	movq	(%r8 ), %rsi
	movq	%rsi, %r8 
	addq	$1, %r8 
	movq	(%r10), %rsi
	movq	(%r11), %rdx
	pushq	%r8 
	pushq	%rsi
	pushq	%rdx
	movq	%rdi, %rcx
	movq	%rdx, %rdi
	movq	%r8 , %rdx
	callq	binary_search
	popq	%rdx
	popq	%rsi
	popq	%r8 
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
	subq	$32, %rsp
	subq	$8, %rsp
	movq	%rsp, %rsi
	subq	$8, %rsp
	movq	%rsp, -8(%rbp)
	subq	$8, %rsp
	movq	%rsp, %rdi
	subq	$8, %rsp
	movq	%rsp, %rdx
	subq	$8, %rsp
	movq	%rsp, -16(%rbp)
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	$100, %rdi
	callq	oat_alloc_array
	popq	%rdx
	popq	%rsi
	popq	%rdi
	movq	%rax, %r8 
	movq	%r8 , %rax
	movq	%rax, %r9 
	subq	$8, %rsp
	movq	%rsp, %r8 
	movq	$100, %rax
	movq	%r8 , %rcx
	movq	%rax, (%rcx)
	subq	$8, %rsp
	movq	%rsp, -24(%rbp)
	movq	%r9 , %rax
	movq	-24(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	$0, %rax
	movq	%rsi, %rcx
	movq	%rax, (%rcx)
	jmp	_cond3988
	.text
_body3987:
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r11
	movq	(%rsi), %r10
	movq	%r11, %rax
	movq	%rax, -32(%rbp)
	pushq	%r11
	pushq	%r10
	pushq	%r9 
	pushq	%r8 
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	%r10, %rsi
	movq	-32(%rbp), %rdi
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
	movq	(%rsi), %r10
	addq	$1, %r10
	movq	%r10, (%rsi)
	jmp	_cond3988
	.text
_body4007:
	movq	-8(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r9 
	movq	(%rdi), %rsi
	movq	%r9 , %rax
	movq	%rax, %r8 
	pushq	%r9 
	pushq	%r8 
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	%r8 , %rdi
	callq	oat_assert_array_length
	popq	%rdx
	popq	%rsi
	popq	%rdi
	popq	%r8 
	popq	%r9 
	movq	%r9 , %rax
	addq	$0, %rax
	addq	$8, %rax
	movq	%rax, %rcx
	movq	%rsi, %rax
	imulq	$8, %rax
	addq	%rcx, %rax
	movq	%rax, %rsi
	movq	(%rdi), %r8 
	imulq	$2, %r8 
	addq	$1, %r8 
	movq	%r8 , (%rsi)
	movq	(%rdi), %rsi
	addq	$1, %rsi
	movq	%rsi, (%rdi)
	jmp	_cond4008
	.text
_cond3988:
	movq	(%rsi), %r10
	movq	(%r8 ), %r11
	cmpq	%r11, %r10
	setl	%r10b
	andq	$1, %r10
	cmpq	$0, %r10
	jne	_body3987
	jmp	_post3986
	.text
_cond4008:
	movq	(%rdi), %rsi
	cmpq	$100, %rsi
	setl	%sil
	andq	$1, %rsi
	cmpq	$0, %rsi
	jne	_body4007
	jmp	_post4006
	.text
_else4041:
	jmp	_merge4040
	.text
_merge4040:
	movq	$0, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
_post3986:
	movq	%r9 , %rax
	movq	-8(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	$0, %rax
	movq	%rdi, %rcx
	movq	%rax, (%rcx)
	jmp	_cond4008
	.text
_post4006:
	movq	-8(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	pushq	%rdx
	movq	$99, %rcx
	movq	$0, %rdx
	movq	$80, %rsi
	callq	binary_search
	popq	%rdx
	movq	%rax, %rdi
	movq	%rdi, (%rdx)
	movq	-8(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	pushq	%rdx
	movq	$99, %rcx
	movq	$0, %rdx
	movq	$81, %rsi
	callq	binary_search
	popq	%rdx
	movq	%rax, %rdi
	movq	%rdi, %rax
	movq	-16(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	(%rdx), %rdi
	movq	-16(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
	andq	%rsi, %rdi
	cmpq	$0, %rdi
	sete	%sil
	andq	$1, %rsi
	movq	(%rdx), %rdi
	movq	-16(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rdx
	orq	%rdx, %rdi
	andq	%rsi, %rdi
	cmpq	$0, %rdi
	jne	_then4042
	jmp	_else4041
	.text
_then4042:
	leaq	_str_arr4037(%rip), %rax
	addq	$0, %rax
	addq	$0, %rax
	movq	%rax, %rdi
	pushq	%rdi
	callq	print_string
	popq	%rdi
	jmp	_merge4040