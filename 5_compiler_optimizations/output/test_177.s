	.data
	.globl	_str_arr3209
_str_arr3209:
	.asciz	" "
	.data
	.globl	_str_arr3215
_str_arr3215:
	.asciz	" "
	.text
	.globl	program
program:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$8, %rsp
	movq	%rsp, %rdi
	subq	$8, %rsp
	movq	%rsp, %rdx
	movq	$0, %rax
	movq	%rdi, %rcx
	movq	%rax, (%rcx)
	pushq	%rdi
	pushq	%rdx
	movq	$10, %rdi
	callq	oat_alloc_array
	popq	%rdx
	popq	%rdi
	movq	%rax, %rsi
	movq	%rsi, %rax
	movq	%rax, %rsi
	movq	%rsi, %rax
	addq	$0, %rax
	addq	$8, %rax
	addq	$0, %rax
	movq	%rax, %r8 
	movq	$126, %rax
	movq	%r8 , %rcx
	movq	%rax, (%rcx)
	movq	%rsi, %rax
	addq	$0, %rax
	addq	$8, %rax
	addq	$8, %rax
	movq	%rax, %r8 
	movq	$125, %rax
	movq	%r8 , %rcx
	movq	%rax, (%rcx)
	movq	%rsi, %rax
	addq	$0, %rax
	addq	$8, %rax
	addq	$16, %rax
	movq	%rax, %r8 
	movq	$124, %rax
	movq	%r8 , %rcx
	movq	%rax, (%rcx)
	movq	%rsi, %rax
	addq	$0, %rax
	addq	$8, %rax
	addq	$24, %rax
	movq	%rax, %r8 
	movq	$123, %rax
	movq	%r8 , %rcx
	movq	%rax, (%rcx)
	movq	%rsi, %rax
	addq	$0, %rax
	addq	$8, %rax
	addq	$32, %rax
	movq	%rax, %r8 
	movq	$122, %rax
	movq	%r8 , %rcx
	movq	%rax, (%rcx)
	movq	%rsi, %rax
	addq	$0, %rax
	addq	$8, %rax
	addq	$40, %rax
	movq	%rax, %r8 
	movq	$121, %rax
	movq	%r8 , %rcx
	movq	%rax, (%rcx)
	movq	%rsi, %rax
	addq	$0, %rax
	addq	$8, %rax
	addq	$48, %rax
	movq	%rax, %r8 
	movq	$120, %rax
	movq	%r8 , %rcx
	movq	%rax, (%rcx)
	movq	%rsi, %rax
	addq	$0, %rax
	addq	$8, %rax
	addq	$56, %rax
	movq	%rax, %r8 
	movq	$119, %rax
	movq	%r8 , %rcx
	movq	%rax, (%rcx)
	movq	%rsi, %rax
	addq	$0, %rax
	addq	$8, %rax
	addq	$64, %rax
	movq	%rax, %r8 
	movq	$118, %rax
	movq	%r8 , %rcx
	movq	%rax, (%rcx)
	movq	%rsi, %rax
	addq	$0, %rax
	addq	$8, %rax
	addq	$72, %rax
	movq	%rax, %r8 
	movq	$117, %rax
	movq	%r8 , %rcx
	movq	%rax, (%rcx)
	movq	%rsi, (%rdx)
	movq	(%rdx), %rsi
	pushq	%rdi
	pushq	%rdx
	movq	%rsi, %rdi
	callq	string_of_array
	popq	%rdx
	popq	%rdi
	movq	%rax, %rsi
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	%rsi, %rdi
	callq	print_string
	popq	%rdx
	popq	%rsi
	popq	%rdi
	movq	(%rdx), %rsi
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	$9, %rdx
	movq	%rsi, %rdi
	movq	$0, %rsi
	callq	oat_mergesort
	popq	%rdx
	popq	%rsi
	popq	%rdi
	leaq	_str_arr3209(%rip), %rax
	addq	$0, %rax
	addq	$0, %rax
	movq	%rax, %rsi
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	%rsi, %rdi
	callq	print_string
	popq	%rdx
	popq	%rsi
	popq	%rdi
	movq	(%rdx), %rsi
	pushq	%rdi
	movq	%rsi, %rdi
	callq	string_of_array
	popq	%rdi
	movq	%rax, %rsi
	pushq	%rdi
	pushq	%rsi
	movq	%rsi, %rdi
	callq	print_string
	popq	%rsi
	popq	%rdi
	leaq	_str_arr3215(%rip), %rax
	addq	$0, %rax
	addq	$0, %rax
	movq	%rax, %rsi
	pushq	%rdi
	pushq	%rsi
	movq	%rsi, %rdi
	callq	print_string
	popq	%rsi
	popq	%rdi
	movq	(%rdi), %rdi
	movq	%rdi, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	oat_mergesort
oat_mergesort:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$8, %rsp
	movq	%rsp, %r11
	subq	$8, %rsp
	movq	%rsp, %r9 
	subq	$8, %rsp
	movq	%rsp, %r10
	subq	$8, %rsp
	movq	%rsp, %r8 
	movq	%rdi, (%r11)
	movq	%rsi, (%r9 )
	movq	%rdx, (%r10)
	movq	$0, %rax
	movq	%r8 , %rcx
	movq	%rax, (%rcx)
	movq	(%r9 ), %rdi
	movq	(%r10), %rsi
	cmpq	%rsi, %rdi
	setl	%dil
	andq	$1, %rdi
	cmpq	$0, %rdi
	jne	_then3171
	jmp	_else3170
	.text
_else3170:
	jmp	_merge3169
	.text
_merge3169:
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
_then3171:
	movq	(%r9 ), %rdi
	movq	(%r10), %rsi
	addq	%rsi, %rdi
	movq	%rdi, %rax
	movq	$1, %rcx
	shrq	%cl, %rax
	movq	%rax, %rdi
	movq	%rdi, (%r8 )
	movq	(%r8 ), %rdi
	movq	(%r9 ), %rsi
	movq	(%r11), %rdx
	pushq	%r11
	pushq	%r10
	pushq	%r9 
	pushq	%r8 
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	pushq	%rdi
	movq	%rdx, %rdi
	popq	%rdx
	callq	oat_mergesort
	popq	%rdx
	popq	%rsi
	popq	%rdi
	popq	%r8 
	popq	%r9 
	popq	%r10
	popq	%r11
	movq	(%r10), %rdi
	movq	(%r8 ), %rsi
	addq	$1, %rsi
	movq	(%r11), %rdx
	pushq	%r11
	pushq	%r10
	pushq	%r9 
	pushq	%r8 
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	pushq	%rdi
	movq	%rdx, %rdi
	popq	%rdx
	callq	oat_mergesort
	popq	%rdx
	popq	%rsi
	popq	%rdi
	popq	%r8 
	popq	%r9 
	popq	%r10
	popq	%r11
	movq	(%r8 ), %rdi
	movq	(%r10), %rdx
	movq	(%r9 ), %rsi
	movq	(%r11), %r8 
	pushq	%r8 
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	%rdi, %rcx
	movq	%r8 , %rdi
	callq	merge
	popq	%rdx
	popq	%rsi
	popq	%rdi
	popq	%r8 
	jmp	_merge3169
	.text
	.globl	merge
merge:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$88, %rsp
	movq	%rsi, -16(%rbp)
	movq	%rdx, %rsi
	movq	%rcx, %rdx
	subq	$8, %rsp
	movq	%rsp, %r11
	subq	$8, %rsp
	movq	%rsp, -24(%rbp)
	subq	$8, %rsp
	movq	%rsp, %r9 
	subq	$8, %rsp
	movq	%rsp, -32(%rbp)
	subq	$8, %rsp
	movq	%rsp, -40(%rbp)
	subq	$8, %rsp
	movq	%rsp, -48(%rbp)
	subq	$8, %rsp
	movq	%rsp, -56(%rbp)
	subq	$8, %rsp
	movq	%rsp, %r8 
	subq	$8, %rsp
	movq	%rsp, %r10
	movq	%rdi, (%r11)
	movq	-16(%rbp), %rax
	movq	-24(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	%rsi, (%r9 )
	movq	%rdx, %rax
	movq	-32(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	$0, %rax
	movq	-40(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	$0, %rax
	movq	-48(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	$0, %rax
	movq	-56(%rbp), %rcx
	movq	%rax, (%rcx)
	pushq	%r11
	pushq	%r10
	pushq	%r9 
	pushq	%r8 
	movq	$50, %rdi
	callq	oat_alloc_array
	popq	%r8 
	popq	%r9 
	popq	%r10
	popq	%r11
	movq	%rax, %rdi
	movq	%rdi, %rax
	movq	%rax, %rsi
	subq	$8, %rsp
	movq	%rsp, %rdi
	movq	$50, %rax
	movq	%rdi, %rcx
	movq	%rax, (%rcx)
	subq	$8, %rsp
	movq	%rsp, -64(%rbp)
	movq	%rsi, %rax
	movq	-64(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	$0, %rax
	movq	%r8 , %rcx
	movq	%rax, (%rcx)
	jmp	_cond2982
	.text
_body2981:
	movq	-64(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rdx
	movq	%r8 , %rax
	movq	(%rax), %rax
	movq	%rax, -72(%rbp)
	movq	%rdx, %rax
	movq	%rax, -80(%rbp)
	pushq	%r11
	pushq	%r10
	pushq	%r9 
	pushq	%r8 
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	-72(%rbp), %rsi
	movq	-80(%rbp), %rdi
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
	movq	-72(%rbp), %rax
	imulq	$8, %rax
	addq	%rcx, %rax
	movq	%rax, %rdx
	movq	$0, %rax
	movq	%rdx, %rcx
	movq	%rax, (%rcx)
	movq	(%r8 ), %rdx
	addq	$1, %rdx
	movq	%rdx, (%r8 )
	jmp	_cond2982
	.text
_body3011:
	movq	(%r11), %rdi
	movq	-40(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r8 
	movq	%rdi, %rax
	movq	%rax, %rsi
	pushq	%r11
	pushq	%r10
	pushq	%r9 
	pushq	%r8 
	pushq	%rdi
	pushq	%rsi
	movq	%rsi, %rdi
	movq	%r8 , %rsi
	callq	oat_assert_array_length
	popq	%rsi
	popq	%rdi
	popq	%r8 
	popq	%r9 
	popq	%r10
	popq	%r11
	movq	%rdi, %rax
	addq	$0, %rax
	addq	$8, %rax
	movq	%rax, %rcx
	movq	%r8 , %rax
	imulq	$8, %rax
	addq	%rcx, %rax
	movq	%rax, %rdi
	movq	(%rdi), %rdx
	movq	(%r11), %rdi
	movq	-48(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r8 
	movq	%rdi, %rax
	movq	%rax, %rsi
	pushq	%r11
	pushq	%r10
	pushq	%r9 
	pushq	%r8 
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	%rsi, %rdi
	movq	%r8 , %rsi
	callq	oat_assert_array_length
	popq	%rdx
	popq	%rsi
	popq	%rdi
	popq	%r8 
	popq	%r9 
	popq	%r10
	popq	%r11
	movq	%rdi, %rax
	addq	$0, %rax
	addq	$8, %rax
	movq	%rax, %rcx
	movq	%r8 , %rax
	imulq	$8, %rax
	addq	%rcx, %rax
	movq	%rax, %rdi
	movq	(%rdi), %rdi
	cmpq	%rdi, %rdx
	setl	%dil
	andq	$1, %rdi
	cmpq	$0, %rdi
	jne	_then3064
	jmp	_else3063
	.text
_body3069:
	movq	(%r10), %rdi
	movq	-56(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r8 
	movq	%rdi, %rax
	movq	%rax, %rsi
	pushq	%r11
	pushq	%r10
	pushq	%r9 
	pushq	%r8 
	pushq	%rdi
	pushq	%rsi
	movq	%rsi, %rdi
	movq	%r8 , %rsi
	callq	oat_assert_array_length
	popq	%rsi
	popq	%rdi
	popq	%r8 
	popq	%r9 
	popq	%r10
	popq	%r11
	movq	%rdi, %rax
	addq	$0, %rax
	addq	$8, %rax
	movq	%rax, %rcx
	movq	%r8 , %rax
	imulq	$8, %rax
	addq	%rcx, %rax
	movq	%rax, %r8 
	movq	(%r11), %rdi
	movq	-40(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rdx
	movq	%rdi, %rax
	movq	%rax, %rsi
	pushq	%r11
	pushq	%r10
	pushq	%r9 
	pushq	%r8 
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	%rsi, %rdi
	movq	%rdx, %rsi
	callq	oat_assert_array_length
	popq	%rdx
	popq	%rsi
	popq	%rdi
	popq	%r8 
	popq	%r9 
	popq	%r10
	popq	%r11
	movq	%rdi, %rax
	addq	$0, %rax
	addq	$8, %rax
	movq	%rax, %rcx
	movq	%rdx, %rax
	imulq	$8, %rax
	addq	%rcx, %rax
	movq	%rax, %rdi
	movq	(%rdi), %rdi
	movq	%rdi, (%r8 )
	movq	-56(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	addq	$1, %rdi
	movq	%rdi, %rax
	movq	-56(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	-40(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	addq	$1, %rdi
	movq	%rdi, %rax
	movq	-40(%rbp), %rcx
	movq	%rax, (%rcx)
	jmp	_cond3070
	.text
_body3093:
	movq	(%r10), %rdi
	movq	-56(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r8 
	movq	%rdi, %rax
	movq	%rax, %rsi
	pushq	%r11
	pushq	%r10
	pushq	%r9 
	pushq	%r8 
	pushq	%rdi
	pushq	%rsi
	movq	%rsi, %rdi
	movq	%r8 , %rsi
	callq	oat_assert_array_length
	popq	%rsi
	popq	%rdi
	popq	%r8 
	popq	%r9 
	popq	%r10
	popq	%r11
	movq	%rdi, %rax
	addq	$0, %rax
	addq	$8, %rax
	movq	%rax, %rcx
	movq	%r8 , %rax
	imulq	$8, %rax
	addq	%rcx, %rax
	movq	%rax, %rdx
	movq	(%r11), %rdi
	movq	-48(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r8 
	movq	%rdi, %rax
	movq	%rax, %rsi
	pushq	%r11
	pushq	%r10
	pushq	%r9 
	pushq	%r8 
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	%rsi, %rdi
	movq	%r8 , %rsi
	callq	oat_assert_array_length
	popq	%rdx
	popq	%rsi
	popq	%rdi
	popq	%r8 
	popq	%r9 
	popq	%r10
	popq	%r11
	movq	%rdi, %rax
	addq	$0, %rax
	addq	$8, %rax
	movq	%rax, %rcx
	movq	%r8 , %rax
	imulq	$8, %rax
	addq	%rcx, %rax
	movq	%rax, %rdi
	movq	(%rdi), %rdi
	movq	%rdi, (%rdx)
	movq	-56(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	addq	$1, %rdi
	movq	%rdi, %rax
	movq	-56(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	-48(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	addq	$1, %rdi
	movq	%rdi, %rax
	movq	-48(%rbp), %rcx
	movq	%rax, (%rcx)
	jmp	_cond3094
	.text
_body3119:
	movq	(%r11), %rdi
	movq	-40(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r8 
	movq	%rdi, %rax
	movq	%rax, %rsi
	pushq	%r11
	pushq	%r10
	pushq	%r8 
	pushq	%rdi
	pushq	%rsi
	movq	%rsi, %rdi
	movq	%r8 , %rsi
	callq	oat_assert_array_length
	popq	%rsi
	popq	%rdi
	popq	%r8 
	popq	%r10
	popq	%r11
	movq	%rdi, %rax
	addq	$0, %rax
	addq	$8, %rax
	movq	%rax, %rcx
	movq	%r8 , %rax
	imulq	$8, %rax
	addq	%rcx, %rax
	movq	%rax, %r8 
	movq	(%r10), %rdi
	movq	-40(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r9 
	movq	%rdi, %rax
	movq	%rax, %rsi
	pushq	%r11
	pushq	%r10
	pushq	%r9 
	pushq	%r8 
	pushq	%rdi
	pushq	%rsi
	movq	%rsi, %rdi
	movq	%r9 , %rsi
	callq	oat_assert_array_length
	popq	%rsi
	popq	%rdi
	popq	%r8 
	popq	%r9 
	popq	%r10
	popq	%r11
	movq	%rdi, %rax
	addq	$0, %rax
	addq	$8, %rax
	movq	%rax, %rcx
	movq	%r9 , %rax
	imulq	$8, %rax
	addq	%rcx, %rax
	movq	%rax, %rdi
	movq	(%rdi), %rdi
	movq	%rdi, (%r8 )
	movq	-40(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	addq	$1, %rdi
	movq	%rdi, %rax
	movq	-40(%rbp), %rcx
	movq	%rax, (%rcx)
	jmp	_cond3120
	.text
_cond2982:
	movq	%r8 , %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%rdi), %rdx
	movq	-88(%rbp), %rax
	cmpq	%rdx, %rax
	setl	%dl
	andq	$1, %rdx
	cmpq	$0, %rdx
	jne	_body2981
	jmp	_post2980
	.text
_cond3012:
	movq	-40(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
	movq	-32(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	cmpq	%rdi, %rsi
	setle	%sil
	andq	$1, %rsi
	movq	-48(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r8 
	movq	(%r9 ), %rdi
	cmpq	%rdi, %r8 
	setle	%dil
	andq	$1, %rdi
	andq	%rsi, %rdi
	cmpq	$0, %rdi
	jne	_body3011
	jmp	_post3010
	.text
_cond3070:
	movq	-40(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
	movq	-32(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	cmpq	%rdi, %rsi
	setle	%dil
	andq	$1, %rdi
	cmpq	$0, %rdi
	jne	_body3069
	jmp	_post3068
	.text
_cond3094:
	movq	-48(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
	movq	(%r9 ), %rdi
	cmpq	%rdi, %rsi
	setle	%dil
	andq	$1, %rdi
	cmpq	$0, %rdi
	jne	_body3093
	jmp	_post3092
	.text
_cond3120:
	movq	-40(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
	movq	-56(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	cmpq	%rdi, %rsi
	setl	%dil
	andq	$1, %rdi
	cmpq	$0, %rdi
	jne	_body3119
	jmp	_post3118
	.text
_else3063:
	movq	(%r10), %rdi
	movq	-56(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r8 
	movq	%rdi, %rax
	movq	%rax, %rsi
	pushq	%r11
	pushq	%r10
	pushq	%r9 
	pushq	%r8 
	pushq	%rdi
	pushq	%rsi
	movq	%rsi, %rdi
	movq	%r8 , %rsi
	callq	oat_assert_array_length
	popq	%rsi
	popq	%rdi
	popq	%r8 
	popq	%r9 
	popq	%r10
	popq	%r11
	movq	%rdi, %rax
	addq	$0, %rax
	addq	$8, %rax
	movq	%rax, %rcx
	movq	%r8 , %rax
	imulq	$8, %rax
	addq	%rcx, %rax
	movq	%rax, %rdx
	movq	(%r11), %rdi
	movq	-48(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r8 
	movq	%rdi, %rax
	movq	%rax, %rsi
	pushq	%r11
	pushq	%r10
	pushq	%r9 
	pushq	%r8 
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	%rsi, %rdi
	movq	%r8 , %rsi
	callq	oat_assert_array_length
	popq	%rdx
	popq	%rsi
	popq	%rdi
	popq	%r8 
	popq	%r9 
	popq	%r10
	popq	%r11
	movq	%rdi, %rax
	addq	$0, %rax
	addq	$8, %rax
	movq	%rax, %rcx
	movq	%r8 , %rax
	imulq	$8, %rax
	addq	%rcx, %rax
	movq	%rax, %rdi
	movq	(%rdi), %rdi
	movq	%rdi, (%rdx)
	movq	-56(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	addq	$1, %rdi
	movq	%rdi, %rax
	movq	-56(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	-48(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	addq	$1, %rdi
	movq	%rdi, %rax
	movq	-48(%rbp), %rcx
	movq	%rax, (%rcx)
	jmp	_merge3062
	.text
_merge3062:
	jmp	_cond3012
	.text
_post2980:
	movq	%rsi, (%r10)
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	movq	%rdi, %rax
	movq	-40(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	-32(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	addq	$1, %rdi
	movq	%rdi, %rax
	movq	-48(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	movq	%rdi, %rax
	movq	-56(%rbp), %rcx
	movq	%rax, (%rcx)
	jmp	_cond3012
	.text
_post3010:
	jmp	_cond3070
	.text
_post3068:
	jmp	_cond3094
	.text
_post3092:
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	movq	%rdi, %rax
	movq	-40(%rbp), %rcx
	movq	%rax, (%rcx)
	jmp	_cond3120
	.text
_post3118:
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
_then3064:
	movq	(%r10), %rdi
	movq	-56(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r8 
	movq	%rdi, %rax
	movq	%rax, %rsi
	pushq	%r11
	pushq	%r10
	pushq	%r9 
	pushq	%r8 
	pushq	%rdi
	pushq	%rsi
	movq	%rsi, %rdi
	movq	%r8 , %rsi
	callq	oat_assert_array_length
	popq	%rsi
	popq	%rdi
	popq	%r8 
	popq	%r9 
	popq	%r10
	popq	%r11
	movq	%rdi, %rax
	addq	$0, %rax
	addq	$8, %rax
	movq	%rax, %rcx
	movq	%r8 , %rax
	imulq	$8, %rax
	addq	%rcx, %rax
	movq	%rax, %r8 
	movq	(%r11), %rdi
	movq	-40(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rdx
	movq	%rdi, %rax
	movq	%rax, %rsi
	pushq	%r11
	pushq	%r10
	pushq	%r9 
	pushq	%r8 
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	%rsi, %rdi
	movq	%rdx, %rsi
	callq	oat_assert_array_length
	popq	%rdx
	popq	%rsi
	popq	%rdi
	popq	%r8 
	popq	%r9 
	popq	%r10
	popq	%r11
	movq	%rdi, %rax
	addq	$0, %rax
	addq	$8, %rax
	movq	%rax, %rcx
	movq	%rdx, %rax
	imulq	$8, %rax
	addq	%rcx, %rax
	movq	%rax, %rdi
	movq	(%rdi), %rdi
	movq	%rdi, (%r8 )
	movq	-56(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	addq	$1, %rdi
	movq	%rdi, %rax
	movq	-56(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	-40(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	addq	$1, %rdi
	movq	%rdi, %rax
	movq	-40(%rbp), %rcx
	movq	%rax, (%rcx)
	jmp	_merge3062