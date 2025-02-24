	.text
	.file	"count_sort.ll"
	.globl	min                     # -- Begin function min
	.p2align	4, 0x90
	.type	min,@function
min:                                    # @min
# %bb.0:
	movq	8(%rdi), %rax
	testq	%rsi, %rsi
	jle	.LBB0_3
# %bb.1:                                # %_body211.preheader
	xorl	%ecx, %ecx
	.p2align	4, 0x90
.LBB0_2:                                # %_body211
                                        # =>This Inner Loop Header: Depth=1
	movq	8(%rdi,%rcx,8), %rdx
	cmpq	%rax, %rdx
	cmovleq	%rdx, %rax
	addq	$1, %rcx
	cmpq	%rcx, %rsi
	jne	.LBB0_2
.LBB0_3:                                # %_post210
	retq
.Lfunc_end0:
	.size	min, .Lfunc_end0-min
                                        # -- End function
	.globl	max                     # -- Begin function max
	.p2align	4, 0x90
	.type	max,@function
max:                                    # @max
# %bb.0:
	movq	8(%rdi), %rax
	testq	%rsi, %rsi
	jle	.LBB1_3
# %bb.1:                                # %_body177.preheader
	xorl	%ecx, %ecx
	.p2align	4, 0x90
.LBB1_2:                                # %_body177
                                        # =>This Inner Loop Header: Depth=1
	movq	8(%rdi,%rcx,8), %rdx
	cmpq	%rax, %rdx
	cmovgeq	%rdx, %rax
	addq	$1, %rcx
	cmpq	%rcx, %rsi
	jne	.LBB1_2
.LBB1_3:                                # %_post176
	retq
.Lfunc_end1:
	.size	max, .Lfunc_end1-max
                                        # -- End function
	.globl	count_sort              # -- Begin function count_sort
	.p2align	4, 0x90
	.type	count_sort,@function
count_sort:                             # @count_sort
	.cfi_startproc
# %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	pushq	%rax
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	movq	%rsi, %r12
	movq	%rdi, %r13
	callq	min
	movq	%rax, %r15
	movq	%r13, %rdi
	movq	%r12, %rsi
	callq	max
	movq	%rax, %r14
	movq	%rax, -48(%rbp)         # 8-byte Spill
	subq	%r15, %r14
	addq	$1, %r14
	movq	%r14, %rdi
	callq	oat_alloc_array
	movq	%rax, %rbx
	testq	%r14, %r14
	jle	.LBB2_2
# %bb.1:                                # %_cond73.preheader.loopexit
	leaq	8(%rbx), %rdi
	shlq	$3, %r14
	xorl	%esi, %esi
	movq	%r14, %rdx
	callq	memset
.LBB2_2:                                # %_cond73.preheader
	testq	%r12, %r12
	jle	.LBB2_5
# %bb.3:                                # %_body72.preheader
	xorl	%eax, %eax
	.p2align	4, 0x90
.LBB2_4:                                # %_body72
                                        # =>This Inner Loop Header: Depth=1
	movq	8(%r13,%rax,8), %rcx
	subq	%r15, %rcx
	addq	$1, 8(%rbx,%rcx,8)
	addq	$1, %rax
	cmpq	%rax, %r12
	jne	.LBB2_4
.LBB2_5:                                # %_post71
	movq	%r12, %rdi
	callq	oat_alloc_array
	movq	%rax, %r13
	movq	%rsp, %rcx
	leaq	-16(%rcx), %rax
	movq	%rax, %rsp
	movq	%r13, -16(%rcx)
	testq	%r12, %r12
	movq	-48(%rbp), %r14         # 8-byte Reload
	jle	.LBB2_7
# %bb.6:                                # %_cond127.preheader.loopexit
	movq	(%rax), %rdi
	addq	$8, %rdi
	shlq	$3, %r12
	xorl	%esi, %esi
	movq	%r12, %rdx
	callq	memset
.LBB2_7:                                # %_cond127.preheader
	cmpq	%r15, %r14
	jl	.LBB2_13
# %bb.8:                                # %_body126.preheader
	xorl	%eax, %eax
	movq	%r15, %rcx
	jmp	.LBB2_9
	.p2align	4, 0x90
.LBB2_11:                               # %_else160
                                        #   in Loop: Header=BB2_9 Depth=1
	addq	$1, %rcx
	cmpq	%r14, %rcx
	jg	.LBB2_13
.LBB2_9:                                # %_body126
                                        # =>This Inner Loop Header: Depth=1
	movq	%rcx, %rdx
	subq	%r15, %rdx
	cmpq	$0, 8(%rbx,%rdx,8)
	jle	.LBB2_11
# %bb.10:                               # %_then161
                                        #   in Loop: Header=BB2_9 Depth=1
	movq	%rcx, 8(%r13,%rax,8)
	addq	$-1, 8(%rbx,%rdx,8)
	addq	$1, %rax
	cmpq	%r14, %rcx
	jle	.LBB2_9
.LBB2_13:                               # %_post125
	movq	%r13, %rax
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Lfunc_end2:
	.size	count_sort, .Lfunc_end2-count_sort
	.cfi_endproc
                                        # -- End function
	.globl	program                 # -- Begin function program
	.p2align	4, 0x90
	.type	program,@function
program:                                # @program
	.cfi_startproc
# %bb.0:
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset %rbx, -16
	movl	$9, %edi
	callq	oat_alloc_array
	movq	%rax, %rbx
	movq	$65, 8(%rax)
	movq	$70, 16(%rax)
	movq	$72, 24(%rax)
	movq	$90, 32(%rax)
	movq	$65, 40(%rax)
	movq	$65, 48(%rax)
	movq	$69, 56(%rax)
	movq	$89, 64(%rax)
	movq	$67, 72(%rax)
	movq	%rax, %rdi
	callq	string_of_array
	movq	%rax, %rdi
	callq	print_string
	movl	$_str_arr21, %edi
	callq	print_string
	movl	$9, %esi
	movq	%rbx, %rdi
	callq	count_sort
	movq	%rax, %rdi
	callq	string_of_array
	movq	%rax, %rdi
	callq	print_string
	xorl	%eax, %eax
	popq	%rbx
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end3:
	.size	program, .Lfunc_end3-program
	.cfi_endproc
                                        # -- End function
	.type	_str_arr21,@object      # @_str_arr21
	.data
	.globl	_str_arr21
_str_arr21:
	.asciz	"\n"
	.size	_str_arr21, 2


	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym _str_arr21
