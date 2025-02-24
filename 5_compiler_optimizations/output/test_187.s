	.text
	.globl	binary_gcd
binary_gcd:
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
	cmpq	%rdi, %rsi
	sete	%dil
	andq	$1, %rdi
	cmpq	$0, %rdi
	jne	_then4931
	jmp	_else4930
	.text
_else4930:
	jmp	_merge4929
	.text
_else4936:
	jmp	_merge4935
	.text
_else4942:
	jmp	_merge4941
	.text
_else4962:
	movq	(%rdx), %rdi
	movq	%rdi, %rax
	movq	$1, %rcx
	shrq	%cl, %rax
	movq	%rax, %rsi
	movq	(%r8 ), %rdi
	movq	%rdi, %rax
	movq	$1, %rcx
	shrq	%cl, %rax
	movq	%rax, %rdi
	pushq	%rsi
	callq	binary_gcd
	popq	%rsi
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
_else4965:
	jmp	_merge4964
	.text
_else4976:
	jmp	_merge4975
	.text
_else4988:
	jmp	_merge4987
	.text
_merge4929:
	movq	(%r8 ), %rdi
	cmpq	$0, %rdi
	sete	%dil
	andq	$1, %rdi
	cmpq	$0, %rdi
	jne	_then4937
	jmp	_else4936
	.text
_merge4935:
	movq	(%rdx), %rdi
	cmpq	$0, %rdi
	sete	%dil
	andq	$1, %rdi
	cmpq	$0, %rdi
	jne	_then4943
	jmp	_else4942
	.text
_merge4941:
	movq	(%r8 ), %rdi
	xorq	$-1, %rdi
	andq	$1, %rdi
	cmpq	$1, %rdi
	sete	%dil
	andq	$1, %rdi
	cmpq	$0, %rdi
	jne	_then4966
	jmp	_else4965
	.text
_merge4961:
	jmp	_merge4964
	.text
_merge4964:
	movq	(%rdx), %rdi
	xorq	$-1, %rdi
	andq	$1, %rdi
	cmpq	$1, %rdi
	sete	%dil
	andq	$1, %rdi
	cmpq	$0, %rdi
	jne	_then4977
	jmp	_else4976
	.text
_merge4975:
	movq	(%r8 ), %rsi
	movq	(%rdx), %rdi
	cmpq	%rdi, %rsi
	setg	%dil
	andq	$1, %rdi
	cmpq	$0, %rdi
	jne	_then4989
	jmp	_else4988
	.text
_merge4987:
	movq	(%r8 ), %r9 
	movq	(%rdx), %rdi
	movq	(%r8 ), %rsi
	subq	%rsi, %rdi
	movq	%rdi, %rax
	movq	$1, %rcx
	shrq	%cl, %rax
	movq	%rax, %rdi
	pushq	%r9 
	movq	%r9 , %rsi
	callq	binary_gcd
	popq	%r9 
	movq	%rax, %rdi
	movq	%rdi, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
_then4931:
	movq	(%r8 ), %rdi
	movq	%rdi, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
_then4937:
	movq	(%rdx), %rdi
	movq	%rdi, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
_then4943:
	movq	(%r8 ), %rdi
	movq	%rdi, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
_then4963:
	movq	(%rdx), %rdi
	movq	(%r8 ), %rsi
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
_then4966:
	movq	(%rdx), %rdi
	andq	$1, %rdi
	cmpq	$1, %rdi
	sete	%dil
	andq	$1, %rdi
	cmpq	$0, %rdi
	jne	_then4963
	jmp	_else4962
	.text
_then4977:
	movq	(%rdx), %rdi
	movq	%rdi, %rax
	movq	$1, %rcx
	shrq	%cl, %rax
	movq	%rax, %rsi
	movq	(%r8 ), %rdi
	pushq	%rsi
	callq	binary_gcd
	popq	%rsi
	movq	%rax, %rdi
	movq	%rdi, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
_then4989:
	movq	(%rdx), %rsi
	movq	(%r8 ), %r8 
	movq	(%rdx), %rdi
	movq	%r8 , %rax
	subq	%rdi, %rax
	movq	%rax, %rdi
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
	.globl	program
program:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$8, %rsp
	movq	%rsp, %rsi
	subq	$8, %rsp
	movq	%rsp, %rdi
	movq	$21, %rax
	movq	%rsi, %rcx
	movq	%rax, (%rcx)
	movq	$15, %rax
	movq	%rdi, %rcx
	movq	%rax, (%rcx)
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
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