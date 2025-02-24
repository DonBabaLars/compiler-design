	.text
	.globl	gcd
gcd:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$8, %rsp
	movq	%rsp, %r9 
	subq	$8, %rsp
	movq	%rsp, %r8 
	subq	$8, %rsp
	movq	%rsp, %rdx
	movq	%rdi, (%r9 )
	movq	%rsi, (%r8 )
	jmp	_cond6229
	.text
_body6228:
	movq	(%r8 ), %rdi
	movq	%rdi, (%rdx)
	movq	(%r8 ), %rdi
	movq	(%r9 ), %rsi
	pushq	%r9 
	pushq	%r8 
	pushq	%rsi
	pushq	%rdx
	pushq	%rdi
	movq	%rsi, %rdi
	popq	%rsi
	callq	mod
	popq	%rdx
	popq	%rsi
	popq	%r8 
	popq	%r9 
	movq	%rax, %rdi
	movq	%rdi, (%r8 )
	movq	(%rdx), %rdi
	movq	%rdi, (%r9 )
	jmp	_cond6229
	.text
_cond6229:
	movq	(%r8 ), %rdi
	cmpq	$0, %rdi
	setne	%dil
	andq	$1, %rdi
	cmpq	$0, %rdi
	jne	_body6228
	jmp	_post6227
	.text
_post6227:
	movq	(%r9 ), %rdi
	movq	%rdi, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	mod
mod:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$8, %rsp
	movq	%rsp, %r9 
	subq	$8, %rsp
	movq	%rsp, %r8 
	subq	$8, %rsp
	movq	%rsp, %rdx
	movq	%rdi, (%r9 )
	movq	%rsi, (%r8 )
	movq	(%r9 ), %rdi
	movq	%rdi, (%rdx)
	jmp	_cond6213
	.text
_body6212:
	movq	(%rdx), %rdi
	movq	(%r8 ), %rsi
	subq	%rsi, %rdi
	movq	%rdi, (%rdx)
	jmp	_cond6213
	.text
_cond6213:
	movq	(%rdx), %rdi
	movq	(%r8 ), %rsi
	subq	%rsi, %rdi
	cmpq	$0, %rdi
	setge	%dil
	andq	$1, %rdi
	cmpq	$0, %rdi
	jne	_body6212
	jmp	_post6211
	.text
_post6211:
	movq	(%rdx), %rdi
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
	movq	$64, %rax
	movq	%rsi, %rcx
	movq	%rax, (%rcx)
	movq	$48, %rax
	movq	%rdi, %rcx
	movq	%rax, (%rcx)
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	pushq	%rsi
	pushq	%rdi
	movq	%rsi, %rdi
	popq	%rsi
	callq	gcd
	popq	%rsi
	movq	%rax, %rdi
	movq	%rdi, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	