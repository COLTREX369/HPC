	.file	"matrix_mult.c"
	.text
	.p2align 4
	.globl	multiplicar_matrices
	.type	multiplicar_matrices, @function
multiplicar_matrices:
.LFB39:
	.cfi_startproc
	endbr64
	testl	%ecx, %ecx
	jle	.L17
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	movl	%ecx, %eax
	movq	%rdi, %r10
	movslq	%ecx, %rdi
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	shrl	%eax
	movl	%ecx, %r15d
	movq	%rsi, %r9
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	salq	$4, %rax
	movq	%rdx, %r14
	movq	%r10, %r13
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	leaq	0(,%rdi,8), %rsi
	xorl	%r8d, %r8d
	xorl	%edx, %edx
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	andl	$1, %r15d
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	movq	%rdi, %rbx
	salq	$4, %rbx
	movq	%rax, -16(%rsp)
	movl	%ecx, %eax
	andl	$-2, %eax
	movl	%eax, -32(%rsp)
	.p2align 4,,10
	.p2align 3
.L3:
	movq	-16(%rsp), %rax
	movl	%edx, -28(%rsp)
	movq	%r9, %r12
	xorl	%ebp, %ebp
	movq	%rsi, -24(%rsp)
	leaq	(%rax,%r13), %r11
	.p2align 4,,10
	.p2align 3
.L9:
	movl	%ebp, %esi
	cmpl	$1, %ecx
	je	.L10
	movq	%r13, %rdx
	movq	%r12, %rax
	pxor	%xmm1, %xmm1
	.p2align 4,,10
	.p2align 3
.L5:
	movsd	(%rax), %xmm0
	movupd	(%rdx), %xmm3
	addq	$16, %rdx
	movhpd	(%rax,%rdi,8), %xmm0
	addq	%rbx, %rax
	mulpd	%xmm3, %xmm0
	addsd	%xmm0, %xmm1
	unpckhpd	%xmm0, %xmm0
	addsd	%xmm0, %xmm1
	cmpq	%rdx, %r11
	jne	.L5
	testl	%r15d, %r15d
	je	.L4
	movl	-32(%rsp), %eax
.L8:
	movl	%ecx, %edx
	imull	%eax, %edx
	addl	%r8d, %eax
	cltq
	addl	%esi, %edx
	movslq	%edx, %rdx
	movsd	(%r9,%rdx,8), %xmm0
	mulsd	(%r10,%rax,8), %xmm0
	addsd	%xmm0, %xmm1
.L4:
	movsd	%xmm1, (%r14,%rbp,8)
	addq	$1, %rbp
	addq	$8, %r12
	cmpq	%rdi, %rbp
	jne	.L9
	movl	-28(%rsp), %edx
	movq	-24(%rsp), %rsi
	addl	%ecx, %r8d
	addl	$1, %edx
	addq	%rsi, %r14
	addq	%rsi, %r13
	cmpl	%edx, %ecx
	jne	.L3
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L10:
	.cfi_restore_state
	xorl	%eax, %eax
	pxor	%xmm1, %xmm1
	jmp	.L8
.L17:
	.cfi_def_cfa_offset 8
	.cfi_restore 3
	.cfi_restore 6
	.cfi_restore 12
	.cfi_restore 13
	.cfi_restore 14
	.cfi_restore 15
	ret
	.cfi_endproc
.LFE39:
	.size	multiplicar_matrices, .-multiplicar_matrices
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC1:
	.string	"Uso: %s <N>\n"
.LC2:
	.string	"Error al asignar memoria.\n"
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC7:
	.string	"=== Ejecutando %d iteraciones para N = %d ===\n"
	.section	.rodata.str1.1
.LC9:
	.string	"Iteracion %d: %.6f segundos\n"
	.section	.text.startup,"ax",@progbits
	.p2align 4
	.globl	main
	.type	main, @function
main:
.LFB40:
	.cfi_startproc
	endbr64
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$136, %rsp
	.cfi_def_cfa_offset 192
	movq	%fs:40, %rdx
	movq	%rdx, 120(%rsp)
	xorl	%edx, %edx
	cmpl	$1, %edi
	jle	.L69
	movq	8(%rsi), %rdi
	movl	$10, %edx
	xorl	%esi, %esi
	call	strtol@PLT
	movslq	%eax, %r13
	movq	%rax, 48(%rsp)
	movq	%rax, %r15
	movl	%eax, %ebp
	movq	%r13, %r14
	imulq	%r13, %r14
	salq	$3, %r14
	movq	%r14, %rdi
	call	malloc@PLT
	movq	%r14, %rdi
	movq	%rax, %r12
	call	malloc@PLT
	movq	%r14, %rdi
	movq	%rax, %rbx
	call	malloc@PLT
	testq	%r12, %r12
	movq	%rax, 40(%rsp)
	movq	%rax, %rsi
	sete	%al
	testq	%rbx, %rbx
	sete	%dl
	orb	%dl, %al
	jne	.L24
	testq	%rsi, %rsi
	je	.L24
	movl	%r15d, %eax
	imull	%r15d, %eax
	testl	%eax, %eax
	je	.L26
	cmpl	$1, %eax
	je	.L70
	movl	%eax, %edx
	movsd	.LC3(%rip), %xmm0
	movq	%r12, %rcx
	shrl	%edx
	salq	$4, %rdx
	unpcklpd	%xmm0, %xmm0
	leaq	(%rdx,%r12), %rsi
	testb	$16, %dl
	je	.L30
	leaq	16(%r12), %rcx
	movups	%xmm0, (%r12)
	cmpq	%rsi, %rcx
	je	.L64
.L30:
	movups	%xmm0, (%rcx)
	addq	$32, %rcx
	movups	%xmm0, -16(%rcx)
	cmpq	%rsi, %rcx
	jne	.L30
.L64:
	movl	%eax, %esi
	andl	$-2, %esi
	testb	$1, %al
	je	.L31
	movq	.LC3(%rip), %rdi
	movl	%esi, %ecx
	movq	%rdi, (%r12,%rcx,8)
.L31:
	movsd	.LC6(%rip), %xmm0
	leaq	(%rdx,%rbx), %rdi
	andb	$16, %dl
	movq	%rbx, %rcx
	unpcklpd	%xmm0, %xmm0
	je	.L32
	leaq	16(%rbx), %rcx
	movups	%xmm0, (%rbx)
	cmpq	%rcx, %rdi
	je	.L63
.L32:
	movups	%xmm0, (%rcx)
	addq	$32, %rcx
	movups	%xmm0, -16(%rcx)
	cmpq	%rcx, %rdi
	jne	.L32
.L63:
	cmpl	%esi, %eax
	je	.L33
.L29:
	movq	.LC6(%rip), %rdi
	movslq	%esi, %rsi
	movq	%rdi, (%rbx,%rsi,8)
.L33:
	movl	%eax, %eax
	movq	40(%rsp), %rdi
	xorl	%esi, %esi
	leaq	0(,%rax,8), %rdx
	call	memset@PLT
.L26:
	leaq	.LC7(%rip), %rsi
	movl	%ebp, %ecx
	movl	$10, %edx
	xorl	%eax, %eax
	movl	$2, %edi
	movq	%r13, %r15
	call	__printf_chk@PLT
	movq	48(%rsp), %rsi
	salq	$4, %r15
	leaq	0(,%r13,8), %rax
	movq	%rax, 56(%rsp)
	movl	%esi, %eax
	movl	$1, 36(%rsp)
	movl	%esi, %r14d
	shrl	%eax
	salq	$4, %rax
	movq	%rax, 24(%rsp)
	movl	%esi, %eax
	andl	$-2, %eax
	movl	%eax, 12(%rsp)
	leaq	80(%rsp), %rax
	movq	%rax, 64(%rsp)
	leaq	96(%rsp), %rax
	movq	%rax, 72(%rsp)
	movl	%esi, %eax
	andl	$1, %eax
	movl	%eax, 8(%rsp)
.L42:
	movq	64(%rsp), %rsi
	movl	$1, %edi
	call	clock_gettime@PLT
	testl	%ebp, %ebp
	jle	.L34
	movl	48(%rsp), %eax
	movq	40(%rsp), %r11
	movq	%r12, %r9
	xorl	%r8d, %r8d
	movq	56(%rsp), %rdi
	xorl	%edx, %edx
	movq	%rax, (%rsp)
	.p2align 4,,10
	.p2align 3
.L35:
	movq	24(%rsp), %rax
	movl	%edx, 32(%rsp)
	movq	%rbx, %rsi
	xorl	%ecx, %ecx
	movq	%rdi, 16(%rsp)
	leaq	(%rax,%r9), %r10
	.p2align 4,,10
	.p2align 3
.L41:
	movl	%ecx, %edi
	cmpl	$1, %r14d
	je	.L44
	movq	%rsi, %rdx
	movq	%r9, %rax
	pxor	%xmm0, %xmm0
.L37:
	movsd	(%rdx), %xmm2
	movupd	(%rax), %xmm3
	addq	$16, %rax
	movhpd	(%rdx,%r13,8), %xmm2
	addq	%r15, %rdx
	mulpd	%xmm3, %xmm2
	addsd	%xmm2, %xmm0
	unpckhpd	%xmm2, %xmm2
	addsd	%xmm2, %xmm0
	cmpq	%r10, %rax
	jne	.L37
	movl	8(%rsp), %eax
	testl	%eax, %eax
	je	.L36
	movl	12(%rsp), %eax
.L40:
	movl	%ebp, %edx
	imull	%eax, %edx
	addl	%r8d, %eax
	cltq
	addl	%edi, %edx
	movslq	%edx, %rdx
	movsd	(%rbx,%rdx,8), %xmm1
	mulsd	(%r12,%rax,8), %xmm1
	addsd	%xmm1, %xmm0
.L36:
	movsd	%xmm0, (%r11,%rcx,8)
	addq	$8, %rsi
	addq	$1, %rcx
	cmpq	%rcx, (%rsp)
	jne	.L41
	movl	32(%rsp), %edx
	movq	16(%rsp), %rdi
	addl	%r14d, %r8d
	addl	$1, %edx
	addq	%rdi, %r11
	addq	%rdi, %r9
	cmpl	%edx, %ebp
	jne	.L35
.L34:
	movq	72(%rsp), %rsi
	movl	$1, %edi
	call	clock_gettime@PLT
	movq	104(%rsp), %rax
	pxor	%xmm0, %xmm0
	subq	88(%rsp), %rax
	cvtsi2sdq	%rax, %xmm0
	pxor	%xmm1, %xmm1
	movq	96(%rsp), %rax
	subq	80(%rsp), %rax
	cvtsi2sdq	%rax, %xmm1
	movl	36(%rsp), %edx
	divsd	.LC8(%rip), %xmm0
	leaq	.LC9(%rip), %rsi
	movl	$2, %edi
	movl	$1, %eax
	addsd	%xmm1, %xmm0
	call	__printf_chk@PLT
	addl	$1, 36(%rsp)
	movl	36(%rsp), %eax
	cmpl	$11, %eax
	jne	.L42
	movq	%r12, %rdi
	call	free@PLT
	movq	%rbx, %rdi
	call	free@PLT
	movq	40(%rsp), %rdi
	call	free@PLT
	xorl	%eax, %eax
.L21:
	movq	120(%rsp), %rdx
	subq	%fs:40, %rdx
	jne	.L71
	addq	$136, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L44:
	.cfi_restore_state
	pxor	%xmm0, %xmm0
	xorl	%eax, %eax
	jmp	.L40
.L69:
	movq	(%rsi), %rdx
	movl	$2, %edi
	xorl	%eax, %eax
	leaq	.LC1(%rip), %rsi
	call	__printf_chk@PLT
.L23:
	movl	$1, %eax
	jmp	.L21
.L70:
	movq	.LC3(%rip), %rsi
	movq	%rsi, (%r12)
	xorl	%esi, %esi
	jmp	.L29
.L71:
	call	__stack_chk_fail@PLT
.L24:
	movq	stderr(%rip), %rcx
	movl	$26, %edx
	movl	$1, %esi
	leaq	.LC2(%rip), %rdi
	call	fwrite@PLT
	jmp	.L23
	.cfi_endproc
.LFE40:
	.size	main, .-main
	.section	.rodata.cst8,"aM",@progbits,8
	.align 8
.LC3:
	.long	0
	.long	1072693248
	.align 8
.LC6:
	.long	0
	.long	1073741824
	.align 8
.LC8:
	.long	0
	.long	1104006501
	.ident	"GCC: (Ubuntu 13.3.0-6ubuntu2~24.04.1) 13.3.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	1f - 0f
	.long	4f - 1f
	.long	5
0:
	.string	"GNU"
1:
	.align 8
	.long	0xc0000002
	.long	3f - 2f
2:
	.long	0x3
3:
	.align 8
4:
