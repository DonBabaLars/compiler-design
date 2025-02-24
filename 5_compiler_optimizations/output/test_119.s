	.text
	.globl	binary_gcd
binary_gcd:
	pushq	%rbp
	movq	%rsp, %rbp
	cmpq	%rsi, %rdi
	sete	%dl
	andq	$1, %rdx
	cmpq	$0, %rdx
	jne	ret_u
	jmp	term1
	.text
both_even:
	movq	%rdi, %rax
	movq	$1, %rcx
	shrq	%cl, %rax
	movq	%rax, %rdx
	movq	%rsi, %rax
	movq	$1, %rcx
	shrq	%cl, %rax
	movq	%rax, %rdi
	pushq	%rdx
	movq	%rdi, %rsi
	movq	%rdx, %rdi
	callq	binary_gcd
	popq	%rdx
	movq	%rax, %rdi
	movq	%rdi, %rax
	movq	$1, %rcx
	shlq	%cl, %rax
	movq	%rax, %rdi
	movq	%rdi, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
gcd:
	movq	$-1, %rdx
	xorq	%rdi, %rdx
	andq	$1, %rdx
	movq	$0, %rax
	cmpq	%rdx, %rax
	setne	%dl
	andq	$1, %rdx
	cmpq	$0, %rdx
	jne	u_even
	jmp	u_odd
	.text
ret_u:
	movq	%rdi, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
ret_v:
	movq	%rsi, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
term1:
	movq	$0, %rax
	cmpq	%rdi, %rax
	sete	%dl
	andq	$1, %rdx
	cmpq	$0, %rdx
	jne	ret_v
	jmp	term2
	.text
term2:
	movq	$0, %rax
	cmpq	%rsi, %rax
	sete	%dl
	andq	$1, %rdx
	cmpq	$0, %rdx
	jne	ret_u
	jmp	gcd
	.text
u_even:
	movq	%rsi, %rdx
	andq	$1, %rdx
	movq	$0, %rax
	cmpq	%rdx, %rax
	setne	%dl
	andq	$1, %rdx
	cmpq	$0, %rdx
	jne	ue_vo
	jmp	both_even
	.text
u_gt:
	subq	%rsi, %rdi
	movq	%rdi, %rax
	movq	$1, %rcx
	shrq	%cl, %rax
	movq	%rax, %rdi
	pushq	%rsi
	callq	binary_gcd
	popq	%rsi
	movq	%rax, %rdi
	movq	%rdi, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
u_odd:
	movq	$-1, %rdx
	xorq	%rsi, %rdx
	andq	$1, %rdx
	movq	$0, %rax
	cmpq	%rdx, %rax
	setne	%dl
	andq	$1, %rdx
	cmpq	$0, %rdx
	jne	v_even
	jmp	v_odd
	.text
ue_vo:
	movq	%rdi, %rax
	movq	$1, %rcx
	shrq	%cl, %rax
	movq	%rax, %rdi
	pushq	%rsi
	callq	binary_gcd
	popq	%rsi
	movq	%rax, %rdi
	movq	%rdi, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
v_even:
	movq	%rsi, %rax
	movq	$1, %rcx
	shrq	%cl, %rax
	movq	%rax, %rsi
	pushq	%rsi
	callq	binary_gcd
	popq	%rsi
	movq	%rax, %rdi
	movq	%rdi, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
v_gt:
	subq	%rdi, %rsi
	movq	%rsi, %rax
	movq	$1, %rcx
	shrq	%cl, %rax
	movq	%rax, %rsi
	pushq	%rsi
	pushq	%rdi
	movq	%rsi, %rdi
	popq	%rsi
	callq	binary_gcd
	popq	%rsi
	movq	%rax, %rdi
	movq	%rdi, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
v_odd:
	cmpq	%rsi, %rdi
	setg	%dl
	andq	$1, %rdx
	cmpq	$0, %rdx
	jne	u_gt
	jmp	v_gt
	.text
	.globl	main
main:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	$15, %rsi
	movq	$21, %rdi
	callq	binary_gcd
	movq	%rax, %rdi
	movq	%rdi, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	