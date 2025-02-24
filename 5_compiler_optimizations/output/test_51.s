	.text
	.globl	naive_mod
naive_mod:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$8, %rsp
	movq	%rsp, %rdx
	movq	$0, %rax
	movq	%rdx, %rcx
	movq	%rax, (%rcx)
	jmp	start
	.text
final:
	movq	(%rdx), %rdx
	movq	%rdx, %rax
	subq	%rsi, %rax
	movq	%rax, %rsi
	subq	%rsi, %rdi
	movq	%rdi, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
start:
	movq	(%rdx), %r8 
	addq	%rsi, %r8 
	movq	%r8 , (%rdx)
	cmpq	%rdi, %r8 
	setg	%r8b
	andq	$1, %r8 
	cmpq	$0, %r8 
	jne	final
	jmp	start
	.text
	.globl	naive_prime
naive_prime:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$8, %rsp
	movq	%rsp, %rdx
	movq	$2, %rax
	movq	%rdx, %rcx
	movq	%rax, (%rcx)
	jmp	loop
	.text
final_false:
	movq	$0, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
final_true:
	movq	$1, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
inc:
	movq	(%rdx), %r8 
	movq	$1, %rsi
	addq	%r9 , %rsi
	movq	%rsi, (%rdx)
	pushq	%r8 
	pushq	%rdi
	pushq	%rdx
	movq	%r8 , %rsi
	callq	naive_mod
	popq	%rdx
	popq	%rdi
	popq	%r8 
	movq	%rax, %rsi
	movq	$0, %rax
	cmpq	%rsi, %rax
	sete	%sil
	andq	$1, %rsi
	cmpq	$0, %rsi
	jne	final_false
	jmp	loop
	.text
loop:
	movq	(%rdx), %r9 
	movq	%r9 , %rsi
	imulq	%r9 , %rsi
	cmpq	%rdi, %rsi
	setg	%sil
	andq	$1, %rsi
	cmpq	$0, %rsi
	jne	final_true
	jmp	inc
	.text
	.globl	main
main:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	$100, %rdi
	callq	naive_prime
	movq	%rax, %rdi
	movq	%rdi, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	