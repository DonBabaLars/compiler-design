	.data
	.globl	lfsr_iterations
lfsr_iterations:
	.quad	5
	.data
	.globl	lfsr_length
lfsr_length:
	.quad	4
	.data
	.globl	lfsr_init_values
lfsr_init_values:
	.quad	_global_arr5170
	.data
	.globl	_global_arr5170
_global_arr5170:
	.quad	4
	.quad	1
	.quad	0
	.quad	1
	.quad	0
	.data
	.globl	_str_arr5148
_str_arr5148:
	.asciz	"T"
	.data
	.globl	_str_arr5150
_str_arr5150:
	.asciz	"F"
	.data
	.globl	_str_arr5113
_str_arr5113:
	.asciz	" "
	.text
	.globl	xor
xor:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$8, %rsp
	movq	%rsp, %r8 
	subq	$8, %rsp
	movq	%rsp, %rdx
	movq	%rdi, (%r8 )
	movq	%rsi, (%rdx)
	movq	(%r8 ), %rsi
	movq	(%rdx), %rdi
	cmpq	$0, %rdi
	sete	%dil
	andq	$1, %rdi
	movq	%rsi, %r9 
	andq	%rdi, %r9 
	movq	(%r8 ), %rdi
	cmpq	$0, %rdi
	sete	%sil
	andq	$1, %rsi
	movq	(%rdx), %rdi
	andq	%rsi, %rdi
	orq	%r9 , %rdi
	movq	%rdi, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	string_of_bool
string_of_bool:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$8, %rsp
	movq	%rsp, %rdx
	movq	%rdi, (%rdx)
	movq	(%rdx), %rdi
	cmpq	$0, %rdi
	jne	_then5154
	jmp	_else5153
	.text
_else5153:
	leaq	_str_arr5150(%rip), %rax
	addq	$0, %rax
	addq	$0, %rax
	movq	%rax, %rdi
	movq	%rdi, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
_merge5152:
	movq	$0, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
_then5154:
	leaq	_str_arr5148(%rip), %rax
	addq	$0, %rax
	addq	$0, %rax
	movq	%rax, %rdi
	movq	%rdi, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	print_lfsr
print_lfsr:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$8, %rsp
	movq	%rsp, %rdx
	subq	$8, %rsp
	movq	%rsp, %r8 
	subq	$8, %rsp
	movq	%rsp, %r9 
	movq	%rdi, (%rdx)
	movq	%rsi, (%r8 )
	movq	$0, %rax
	movq	%r9 , %rcx
	movq	%rax, (%rcx)
	jmp	_cond5132
	.text
_body5131:
	movq	(%rdx), %rsi
	movq	(%r9 ), %r10
	movq	%rsi, %rax
	movq	%rax, %rdi
	pushq	%r10
	pushq	%r9 
	pushq	%r8 
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	%r10, %rsi
	callq	oat_assert_array_length
	popq	%rdx
	popq	%rsi
	popq	%rdi
	popq	%r8 
	popq	%r9 
	popq	%r10
	movq	%rsi, %rax
	addq	$0, %rax
	addq	$8, %rax
	movq	%rax, %rcx
	movq	%r10, %rax
	imulq	$8, %rax
	addq	%rcx, %rax
	movq	%rax, %rdi
	movq	(%rdi), %rdi
	pushq	%r9 
	pushq	%r8 
	pushq	%rdx
	callq	string_of_bool
	popq	%rdx
	popq	%r8 
	popq	%r9 
	movq	%rax, %rdi
	pushq	%r9 
	pushq	%r8 
	pushq	%rdi
	pushq	%rdx
	callq	print_string
	popq	%rdx
	popq	%rdi
	popq	%r8 
	popq	%r9 
	movq	(%r9 ), %rdi
	addq	$1, %rdi
	movq	%rdi, (%r9 )
	jmp	_cond5132
	.text
_cond5132:
	movq	(%r9 ), %rsi
	movq	(%r8 ), %rdi
	cmpq	%rdi, %rsi
	setl	%dil
	andq	$1, %rdi
	cmpq	$0, %rdi
	jne	_body5131
	jmp	_post5130
	.text
_post5130:
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	program
program:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$40, %rsp
	subq	$8, %rsp
	movq	%rsp, %rdx
	subq	$8, %rsp
	movq	%rsp, -8(%rbp)
	subq	$8, %rsp
	movq	%rsp, %rsi
	subq	$8, %rsp
	movq	%rsp, %rdi
	subq	$8, %rsp
	movq	%rsp, -16(%rbp)
	subq	$8, %rsp
	movq	%rsp, -24(%rbp)
	leaq	lfsr_length(%rip), %rax
	movq	(%rax), %rax
	movq	%rax, %r10
	pushq	%r10
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	%r10, %rdi
	callq	oat_alloc_array
	popq	%rdx
	popq	%rsi
	popq	%rdi
	popq	%r10
	movq	%rax, %r8 
	movq	%r8 , %rax
	movq	%rax, %r9 
	subq	$8, %rsp
	movq	%rsp, %r8 
	movq	%r10, (%r8 )
	subq	$8, %rsp
	movq	%rsp, -32(%rbp)
	movq	%r9 , %rax
	movq	-32(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	$0, %rax
	movq	%rdx, %rcx
	movq	%rax, (%rcx)
	jmp	_cond5014
	.text
_body5013:
	movq	-32(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r11
	movq	(%rdx), %r10
	movq	%r11, %rax
	movq	%rax, -40(%rbp)
	pushq	%r11
	pushq	%r10
	pushq	%r9 
	pushq	%r8 
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	%r10, %rsi
	movq	-40(%rbp), %rdi
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
	jmp	_cond5014
	.text
_body5034:
	movq	-8(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r9 
	movq	(%rsi), %rdx
	movq	%r9 , %rax
	movq	%rax, %r8 
	pushq	%r9 
	pushq	%r8 
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	%rdx, %rsi
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
	movq	%rdx, %rax
	imulq	$8, %rax
	addq	%rcx, %rax
	movq	%rax, %r8 
	leaq	lfsr_init_values(%rip), %rax
	movq	(%rax), %rax
	movq	%rax, %r10
	movq	(%rsi), %rdx
	movq	%r10, %rax
	movq	%rax, %r9 
	pushq	%r10
	pushq	%r9 
	pushq	%r8 
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	%rdx, %rsi
	movq	%r9 , %rdi
	callq	oat_assert_array_length
	popq	%rdx
	popq	%rsi
	popq	%rdi
	popq	%r8 
	popq	%r9 
	popq	%r10
	movq	%r10, %rax
	addq	$0, %rax
	addq	$8, %rax
	movq	%rax, %rcx
	movq	%rdx, %rax
	imulq	$8, %rax
	addq	%rcx, %rax
	movq	%rax, %rdx
	movq	(%rdx), %rdx
	movq	%rdx, (%r8 )
	movq	(%rsi), %rdx
	addq	$1, %rdx
	movq	%rdx, (%rsi)
	jmp	_cond5035
	.text
_body5057:
	movq	-8(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r8 
	leaq	lfsr_length(%rip), %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
	subq	$2, %rsi
	movq	%r8 , %rax
	movq	%rax, %rdx
	pushq	%r8 
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	%rdx, %rdi
	callq	oat_assert_array_length
	popq	%rdx
	popq	%rsi
	popq	%rdi
	popq	%r8 
	movq	%r8 , %rax
	addq	$0, %rax
	addq	$8, %rax
	movq	%rax, %rcx
	movq	%rsi, %rax
	imulq	$8, %rax
	addq	%rcx, %rax
	movq	%rax, %rsi
	movq	(%rsi), %rdx
	movq	-8(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r9 
	leaq	lfsr_length(%rip), %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
	subq	$1, %rsi
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
	movq	(%rsi), %rsi
	pushq	%rdi
	pushq	%rdx
	movq	%rsi, %rdi
	movq	%rdx, %rsi
	callq	xor
	popq	%rdx
	popq	%rdi
	movq	%rax, %rsi
	movq	%rsi, %rax
	movq	-16(%rbp), %rcx
	movq	%rax, (%rcx)
	leaq	lfsr_length(%rip), %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
	subq	$1, %rsi
	movq	%rsi, %rax
	movq	-24(%rbp), %rcx
	movq	%rax, (%rcx)
	jmp	_cond5084
	.text
_body5083:
	movq	-8(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rdx
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r8 
	movq	%rdx, %rax
	movq	%rax, %rsi
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
	movq	%rdx, %rax
	addq	$0, %rax
	addq	$8, %rax
	movq	%rax, %rcx
	movq	%r8 , %rax
	imulq	$8, %rax
	addq	%rcx, %rax
	movq	%rax, %rdx
	movq	-8(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %r9 
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
	subq	$1, %rsi
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
	movq	(%rsi), %rsi
	movq	%rsi, (%rdx)
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
	subq	$1, %rsi
	movq	%rsi, %rax
	movq	-24(%rbp), %rcx
	movq	%rax, (%rcx)
	jmp	_cond5084
	.text
_cond5014:
	movq	(%rdx), %r10
	movq	(%r8 ), %r11
	cmpq	%r11, %r10
	setl	%r10b
	andq	$1, %r10
	cmpq	$0, %r10
	jne	_body5013
	jmp	_post5012
	.text
_cond5035:
	movq	(%rsi), %rdx
	leaq	lfsr_length(%rip), %rax
	movq	(%rax), %rax
	movq	%rax, %r8 
	cmpq	%r8 , %rdx
	setl	%dl
	andq	$1, %rdx
	cmpq	$0, %rdx
	jne	_body5034
	jmp	_post5033
	.text
_cond5058:
	movq	(%rdi), %rsi
	leaq	lfsr_iterations(%rip), %rax
	movq	(%rax), %rax
	movq	%rax, %rdx
	cmpq	%rdx, %rsi
	setl	%sil
	andq	$1, %rsi
	cmpq	$0, %rsi
	jne	_body5057
	jmp	_post5056
	.text
_cond5084:
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
	cmpq	$0, %rsi
	setg	%sil
	andq	$1, %rsi
	cmpq	$0, %rsi
	jne	_body5083
	jmp	_post5082
	.text
_post5012:
	movq	%r9 , %rax
	movq	-8(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	$0, %rax
	movq	%rsi, %rcx
	movq	%rax, (%rcx)
	jmp	_cond5035
	.text
_post5033:
	movq	$0, %rax
	movq	%rdi, %rcx
	movq	%rax, (%rcx)
	jmp	_cond5058
	.text
_post5056:
	leaq	lfsr_length(%rip), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	leaq	lfsr_init_values(%rip), %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
	pushq	%rdi
	pushq	%rsi
	pushq	%rdi
	movq	%rsi, %rdi
	popq	%rsi
	callq	print_lfsr
	popq	%rsi
	popq	%rdi
	leaq	_str_arr5113(%rip), %rax
	addq	$0, %rax
	addq	$0, %rax
	movq	%rax, %rdi
	pushq	%rdi
	callq	print_string
	popq	%rdi
	leaq	lfsr_length(%rip), %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
	movq	-8(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	pushq	%rdi
	pushq	%rsi
	callq	print_lfsr
	popq	%rsi
	popq	%rdi
	movq	$0, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
_post5082:
	movq	-8(%rbp), %rax
	movq	(%rax), %rax
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
	movq	-16(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rdx
	movq	%rdx, (%rsi)
	movq	(%rdi), %rsi
	addq	$1, %rsi
	movq	%rsi, (%rdi)
	jmp	_cond5058