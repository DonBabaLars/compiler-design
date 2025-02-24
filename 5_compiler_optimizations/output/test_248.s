	.text
	.globl	program
program:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$8, %rsp
	movq	%rsp, %rsi
	subq	$8, %rsp
	movq	%rsp, %rdi
	movq	$0, %rax
	movq	%rsi, %rcx
	movq	%rax, (%rcx)
	movq	$0, %rax
	movq	%rdi, %rcx
	movq	%rax, (%rcx)
	movq	(%rsi), %rsi
	cmpq	$0, %rsi
	sete	%sil
	andq	$1, %rsi
	cmpq	$0, %rsi
	jne	_null8612
	jmp	_notnull8611
	.text
_merge8610:
	movq	(%rdi), %rdi
	movq	%rdi, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
_notnull8611:
	movq	$4, %rax
	movq	%rdi, %rcx
	movq	%rax, (%rcx)
	jmp	_merge8610
	.text
_null8612:
	movq	$5, %rax
	movq	%rdi, %rcx
	movq	%rax, (%rcx)
	jmp	_merge8610