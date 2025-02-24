	.data
	.globl	_str_arr754
_str_arr754:
	.asciz	"abc"
	.text
	.globl	program
program:
	pushq	%rbp
	movq	%rsp, %rbp
	leaq	_str_arr754(%rip), %rax
	addq	$0, %rax
	addq	$0, %rax
	movq	%rax, %rdi
	pushq	%rdi
	callq	print_string
	popq	%rdi
	movq	$0, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	