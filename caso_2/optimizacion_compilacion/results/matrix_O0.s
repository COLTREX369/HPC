	.file	"matrix_mult.c"
	.text
	.globl	multiplicar_matrices
	.type	multiplicar_matrices, @function
multiplicar_matrices:
.LFB6:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -40(%rbp)
	movq	%rsi, -48(%rbp)
	movq	%rdx, -56(%rbp)
	movl	%ecx, -60(%rbp)
	movl	$0, -20(%rbp)
	jmp	.L2
.L7:
	movl	$0, -16(%rbp)
	jmp	.L3
.L6:
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -8(%rbp)
	movl	$0, -12(%rbp)
	jmp	.L4
.L5:
	movl	-20(%rbp), %eax
	imull	-60(%rbp), %eax
	movl	%eax, %edx
	movl	-12(%rbp), %eax
	addl	%edx, %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-40(%rbp), %rax
	addq	%rdx, %rax
	movsd	(%rax), %xmm1
	movl	-12(%rbp), %eax
	imull	-60(%rbp), %eax
	movl	%eax, %edx
	movl	-16(%rbp), %eax
	addl	%edx, %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-48(%rbp), %rax
	addq	%rdx, %rax
	movsd	(%rax), %xmm0
	mulsd	%xmm1, %xmm0
	movsd	-8(%rbp), %xmm1
	addsd	%xmm1, %xmm0
	movsd	%xmm0, -8(%rbp)
	addl	$1, -12(%rbp)
.L4:
	movl	-12(%rbp), %eax
	cmpl	-60(%rbp), %eax
	jl	.L5
	movl	-20(%rbp), %eax
	imull	-60(%rbp), %eax
	movl	%eax, %edx
	movl	-16(%rbp), %eax
	addl	%edx, %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-56(%rbp), %rax
	addq	%rdx, %rax
	movsd	-8(%rbp), %xmm0
	movsd	%xmm0, (%rax)
	addl	$1, -16(%rbp)
.L3:
	movl	-16(%rbp), %eax
	cmpl	-60(%rbp), %eax
	jl	.L6
	addl	$1, -20(%rbp)
.L2:
	movl	-20(%rbp), %eax
	cmpl	-60(%rbp), %eax
	jl	.L7
	nop
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	multiplicar_matrices, .-multiplicar_matrices
	.section	.rodata
.LC1:
	.string	"Uso: %s <N>\n"
.LC2:
	.string	"Error al asignar memoria.\n"
	.align 8
.LC5:
	.string	"=== Ejecutando %d iteraciones para N = %d ===\n"
.LC7:
	.string	"Iteracion %d: %.6f segundos\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB7:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	addq	$-128, %rsp
	movl	%edi, -116(%rbp)
	movq	%rsi, -128(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	cmpl	$1, -116(%rbp)
	jg	.L9
	movq	-128(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
	leaq	.LC1(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
	movl	$1, %eax
	jmp	.L17
.L9:
	movq	-128(%rbp), %rax
	addq	$8, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -92(%rbp)
	movl	-92(%rbp), %eax
	movslq	%eax, %rdx
	movl	-92(%rbp), %eax
	cltq
	imulq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, -88(%rbp)
	movq	-88(%rbp), %rax
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, -80(%rbp)
	movq	-88(%rbp), %rax
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, -72(%rbp)
	movq	-88(%rbp), %rax
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, -64(%rbp)
	cmpq	$0, -80(%rbp)
	je	.L11
	cmpq	$0, -72(%rbp)
	je	.L11
	cmpq	$0, -64(%rbp)
	jne	.L12
.L11:
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$26, %edx
	movl	$1, %esi
	leaq	.LC2(%rip), %rax
	movq	%rax, %rdi
	call	fwrite@PLT
	movl	$1, %eax
	jmp	.L17
.L12:
	movl	$0, -100(%rbp)
	jmp	.L13
.L14:
	movl	-100(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-80(%rbp), %rax
	addq	%rdx, %rax
	movsd	.LC3(%rip), %xmm0
	movsd	%xmm0, (%rax)
	movl	-100(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-72(%rbp), %rax
	addq	%rdx, %rax
	movsd	.LC4(%rip), %xmm0
	movsd	%xmm0, (%rax)
	movl	-100(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-64(%rbp), %rax
	addq	%rdx, %rax
	pxor	%xmm0, %xmm0
	movsd	%xmm0, (%rax)
	addl	$1, -100(%rbp)
.L13:
	movl	-92(%rbp), %eax
	imull	%eax, %eax
	cmpl	%eax, -100(%rbp)
	jl	.L14
	movl	-92(%rbp), %eax
	movl	%eax, %edx
	movl	$10, %esi
	leaq	.LC5(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
	movl	$1, -96(%rbp)
	jmp	.L15
.L16:
	leaq	-48(%rbp), %rax
	movq	%rax, %rsi
	movl	$1, %edi
	call	clock_gettime@PLT
	movl	-92(%rbp), %ecx
	movq	-64(%rbp), %rdx
	movq	-72(%rbp), %rsi
	movq	-80(%rbp), %rax
	movq	%rax, %rdi
	call	multiplicar_matrices
	leaq	-32(%rbp), %rax
	movq	%rax, %rsi
	movl	$1, %edi
	call	clock_gettime@PLT
	movq	-32(%rbp), %rdx
	movq	-48(%rbp), %rax
	subq	%rax, %rdx
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rdx, %xmm1
	movq	-24(%rbp), %rdx
	movq	-40(%rbp), %rax
	subq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	movsd	.LC6(%rip), %xmm2
	divsd	%xmm2, %xmm0
	addsd	%xmm1, %xmm0
	movsd	%xmm0, -56(%rbp)
	movq	-56(%rbp), %rdx
	movl	-96(%rbp), %eax
	movq	%rdx, %xmm0
	movl	%eax, %esi
	leaq	.LC7(%rip), %rax
	movq	%rax, %rdi
	movl	$1, %eax
	call	printf@PLT
	addl	$1, -96(%rbp)
.L15:
	cmpl	$10, -96(%rbp)
	jle	.L16
	movq	-80(%rbp), %rax
	movq	%rax, %rdi
	call	free@PLT
	movq	-72(%rbp), %rax
	movq	%rax, %rdi
	call	free@PLT
	movq	-64(%rbp), %rax
	movq	%rax, %rdi
	call	free@PLT
	movl	$0, %eax
.L17:
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L18
	call	__stack_chk_fail@PLT
.L18:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE7:
	.size	main, .-main
	.section	.rodata
	.align 8
.LC3:
	.long	0
	.long	1072693248
	.align 8
.LC4:
	.long	0
	.long	1073741824
	.align 8
.LC6:
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
