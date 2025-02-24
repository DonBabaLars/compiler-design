	.text
	.globl	one_iteration
one_iteration:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, %rax
	movq	$1, %rcx
	shlq	%cl, %rax
	movq	%rax, %rsi
	movq	%rdi, %rdx
	xorq	%rsi, %rdx
	movq	%rsi, %rax
	movq	$2, %rcx
	shlq	%cl, %rax
	movq	%rax, %rdi
	xorq	%rdi, %rdx
	movq	%rdi, %rax
	movq	$1, %rcx
	shlq	%cl, %rax
	movq	%rax, %rdi
	xorq	%rdi, %rdx
	movq	%rdx, %rax
	movq	$63, %rcx
	shrq	%cl, %rax
	movq	%rax, %rdi
	andq	$1, %rdi
	orq	%rdx, %rdi
	movq	%rdi, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	main
main:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$8, %rsp
	movq	%rsp, %rdi
	movq	$1, %rax
	movq	%rdi, %rcx
	movq	%rax, (%rcx)
	jmp	loop
	.text
end:
	movq	%rdx, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
loop:
	movq	(%rdi), %rdx
	movq	%rdx, %rsi
	addq	$1, %rsi
	movq	%rsi, (%rdi)
	pushq	%rdi
	pushq	%rsi
	movq	%rdx, %rdi
	callq	one_iteration
	popq	%rsi
	popq	%rdi
	movq	%rax, %rdx
	cmpq	$5, %rsi
	sete	%sil
	andq	$1, %rsi
	cmpq	$0, %rsi
	jne	end
	jmp	loop