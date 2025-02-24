	.text
	.globl	foo
foo:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	$42, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	bar
bar:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	$0, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	main
main:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$8, %rsp
	movq	%rsp, %rsi
	subq	$8, %rsp
	movq	%rsp, %rdi
	movq	$0, %rax
	movq	%rsi, %rcx
	movq	%rax, (%rcx)
	movq	$100, %rax
	movq	%rdi, %rcx
	movq	%rax, (%rcx)
	movq	(%rdi), %rdi
	cmpq	$0, %rdi
	setne	%dil
	andq	$1, %rdi
	cmpq	$0, %rdi
	jne	then
	jmp	else
	.text
else:
	pushq	%rsi
	callq	bar
	popq	%rsi
	movq	%rax, %rdi
	movq	%rdi, (%rsi)
	jmp	end
	.text
end:
	movq	(%rsi), %rdi
	movq	%rdi, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
then:
	pushq	%rsi
	callq	foo
	popq	%rsi
	movq	%rax, %rdi
	movq	%rdi, (%rsi)
	jmp	end