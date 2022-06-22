	.file	"sseTest.c"
	.intel_syntax noprefix
	.text
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC6:
	.string	"|%g %g| * |%g %g| = |%g %g|\n"
.LC7:
	.string	"|%g %g|   |%g %g|   |%g %g|\n"
	.section	.text.startup,"ax",@progbits
	.p2align 4,,15
	.globl	main
	.type	main, @function
main:
.LFB5054:
	.cfi_startproc
	sub	rsp, 136
	.cfi_def_cfa_offset 144
	pxor	xmm3, xmm3
	movsd	xmm8, QWORD PTR .LC1[rip]
	mov	QWORD PTR 80[rsp], 0x000000000
	movsd	xmm0, QWORD PTR .LC0[rip]
	mov	QWORD PTR 88[rsp], 0x000000000
	movsd	QWORD PTR 56[rsp], xmm8
	mov	QWORD PTR 96[rsp], 0x000000000
	mov	QWORD PTR 104[rsp], 0x000000000
	movsd	QWORD PTR 48[rsp], xmm0
	lea	rsi, .LC6[rip]
	mov	edi, 1
	movsd	xmm1, QWORD PTR .LC2[rip]
	mov	rax, QWORD PTR fs:40
	mov	QWORD PTR 120[rsp], rax
	xor	eax, eax
	movapd	xmm2, XMMWORD PTR 48[rsp]
	mov	rax, QWORD PTR .LC3[rip]
	movapd	xmm7, XMMWORD PTR .LC5[rip]
	mulpd	xmm7, xmm2
	movsd	QWORD PTR 64[rsp], xmm1
	mov	QWORD PTR 72[rsp], rax
	mov	eax, 6
	movsd	QWORD PTR 40[rsp], xmm8
	mulpd	xmm2, xmm3
	movapd	xmm6, XMMWORD PTR 64[rsp]
	addpd	xmm7, XMMWORD PTR 80[rsp]
	movapd	xmm4, xmm6
	addpd	xmm2, XMMWORD PTR 96[rsp]
	mulpd	xmm4, xmm3
	addpd	xmm6, xmm6
	pxor	xmm3, xmm3
	addpd	xmm7, xmm4
	addpd	xmm6, xmm2
	movapd	xmm2, xmm1
	movapd	xmm4, xmm7
	movaps	XMMWORD PTR [rsp], xmm7
	movapd	xmm5, xmm6
	movaps	XMMWORD PTR 16[rsp], xmm6
	call	__printf_chk@PLT
	pxor	xmm2, xmm2
	lea	rsi, .LC7[rip]
	mov	edi, 1
	mov	eax, 6
	movapd	xmm6, XMMWORD PTR 16[rsp]
	movapd	xmm7, XMMWORD PTR [rsp]
	unpckhpd	xmm6, xmm6
	unpckhpd	xmm7, xmm7
	movsd	xmm8, QWORD PTR 40[rsp]
	movapd	xmm5, xmm6
	movsd	xmm1, QWORD PTR .LC3[rip]
	movapd	xmm4, xmm7
	movapd	xmm3, xmm8
	movapd	xmm0, xmm8
	call	__printf_chk@PLT
	mov	rdx, QWORD PTR 120[rsp]
	xor	rdx, QWORD PTR fs:40
	jne	.L5
	xor	eax, eax
	add	rsp, 136
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L5:
	.cfi_restore_state
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE5054:
	.size	main, .-main
	.section	.rodata.cst8,"aM",@progbits,8
	.align 8
.LC0:
	.long	0
	.long	1072693248
	.align 8
.LC1:
	.long	0
	.long	1073741824
	.align 8
.LC2:
	.long	0
	.long	1074266112
	.align 8
.LC3:
	.long	0
	.long	1074790400
	.section	.rodata.cst16,"aM",@progbits,16
	.align 16
.LC5:
	.long	0
	.long	1074266112
	.long	0
	.long	1074266112
	.ident	"GCC: (Ubuntu 7.5.0-3ubuntu1~18.04) 7.5.0"
	.section	.note.GNU-stack,"",@progbits
