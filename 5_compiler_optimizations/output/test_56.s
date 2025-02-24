	.text
	.globl	factorial
factorial:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$8, %rsp
	movq	%rsp, %rsi
	subq	$8, %rsp
	movq	%rsp, %rdx
	movq	%rdi, (%rsi)
	movq	$1, %rax
	movq	%rdx, %rcx
	movq	%rax, (%rcx)
	jmp	start
	.text
end:
	movq	(%rdx), %rdi
	movq	%rdi, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
start:
	movq	(%rsi), %rdi
	cmpq	$0, %rdi
	setg	%dil
	andq	$1, %rdi
	cmpq	$0, %rdi
	jne	then
	jmp	end
	.text
then:
	movq	(%rdx), %r8 
	movq	(%rsi), %rdi
	imulq	%r8 , %rdi
	movq	%rdi, (%rdx)
	movq	(%rsi), %rdi
	subq	$1, %rdi
	movq	%rdi, (%rsi)
	jmp	start
	.text
	.globl	main
main:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	$5, %rdi
	callq	factorial
	movq	%rax, %rdi
	movq	%rdi, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	