	.text
_printform:
	.asciz	"%x"

	.align	16
	.global	mul64p
mul64p:
	pushl	%ebp
	movl	%esp, %ebp

	pushl	%ebx
	pushl	%edi
	pushl	%esi

	xorl	%edx, %edx
	xorl	%eax, %eax

	subl	$16, %esp
	movl	$0, (%esp)
	movl	$0, 4(%esp)
	movl	$0, 8(%esp)
	movl	$0, 12(%esp)
/*
	pushl	$_printform
	call	printf
	addl	$4, %esp
*/
// b * d  ---- 0, 4

	movl	8(%ebp), %eax
	movl	16(%ebp), %ecx

	mull	%ecx
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
/*
	pushl	$_printform
	call	printf	
	addl	$4, %esp
*/
// a * d  ---- 4, 8, 12

	movl	12(%ebp), %eax
	movl	16(%ebp), %ecx

	mull	%ecx
	addl	%eax, 4(%esp)
	jnc	next_1_1

	clc
	addl	$1, 8(%esp)

next_1_1:
	addl	%edx, 8(%esp)
	jnc	next_1_2

	clc
	addl	$1, 12(%esp)

next_1_2:
/*
	pushl	$_printform
	call	printf
	addl	$4, %esp
*/
// c * b  ---- 4, 8, 12

	movl	8(%ebp), %eax
	movl	20(%ebp), %ecx

	mull	%ecx
	addl	%eax, 4(%esp)
	jnc	next_2_1

	clc
	addl	$1, 8(%esp)
	jnc	next_2_1

	clc
	addl	$1, 12(%esp)

next_2_1:
	addl	%edx, 8(%esp)
	jnc	next_2_2

	clc
	addl	$1, 12(%esp)

next_2_2:
/*
	pushl	$_printform
	call	printf
	addl	$4, %esp
*/
// a * c  ---- 8, 12

	movl	12(%ebp), %eax
	movl	20(%ebp), %ecx

	mull	%ecx
	addl	%eax, 8(%esp)
	jnc	next_3

	clc
	addl	$1, 12(%esp)

next_3:
	addl	%edx, 12(%esp)
/*
	pushl	$_printform
	call	printf
*/

	movl	12(%esp), %eax

	movl	$15, %ebx
	shl	$12, %ebx
	andl	%ebx, %eax
	cmpl	$0, %eax
	jne	Print_1_1

	movl	12(%esp), %eax

	shr	$4, %ebx
	andl	%ebx, %eax
	cmpl	$0, %eax
	jne	Print_1_2

	movl	12(%esp), %eax

	shr	$4, %ebx
	andl	%ebx, %eax
	cmpl	$0, %eax
	jne	Print_1_3

	movl	12(%esp), %eax

	shr	$4, %ebx
	andl	%ebx, %eax
	cmpl	$0, %eax
	jne	Print_1_4

	movl	8(%esp), %eax

	movl	$15, %ebx
	shl	$12, %ebx
	andl	%ebx, %eax
	cmpl	$0, %eax
	jne	Print_2_1

	movl	8(%esp), %eax

	shr	$4, %ebx
	andl	%ebx, %eax
	cmpl	$0, %eax
	jne	Print_2_2

	movl	8(%esp), %eax

	shr	$4, %ebx
	andl	%ebx, %eax
	cmpl	$0, %eax
	jne	Print_2_3

	movl	8(%esp), %eax

	shr	$4, %ebx
	andl	%ebx, %eax
	cmpl	$0, %eax
	jne	Print_2_4

	movl	4(%esp), %eax

	movl	$15, %ebx
	shl	$12, %ebx
	andl	%ebx, %eax
	cmpl	$0, %eax
	jne	Print_3_1

	movl	4(%esp), %eax

	shr	$4, %ebx
	andl	%ebx, %eax
	cmpl	$0, %eax
	jne	Print_3_2

	movl	4(%esp), %eax

	shr	$4, %ebx
	andl	%ebx, %eax
	cmpl	$0, %eax
	jne	Print_3_3

	movl	4(%esp), %eax

	shr	$4, %ebx
	andl	%ebx, %eax
	cmpl	$0, %eax
	jne	Print_3_4

	movl	(%esp), %eax

	movl	$15, %ebx
	shl	$12, %ebx
	andl	%ebx, %eax
	cmpl	$0, %eax
	jne	Print_4_1

	movl	(%esp), %eax

	shr	$4, %ebx
	andl	%ebx, %eax
	cmpl	$0, %eax
	jne	Print_4_2

	movl	(%esp), %eax

	shr	$4, %ebx
	andl	%ebx, %eax
	cmpl	$0, %eax
	jne	Print_4_3

	jmp	Print_4_4

Print_1_1:
	movl	$15, %ebx
	shl	$12, %ebx
	movl	12(%esp), %eax
	andl	%ebx, %eax
	shr	$12, %ebx
	pushl	%eax
	pushl	$_printform
	call	printf
	addl	$8, %esp

Print_1_2:
	movl	$15, %ebx
	shl	$8, %ebx
	movl	12(%esp), %eax
	andl	%ebx, %eax
	shr	$8, %ebx
	pushl	%eax
	pushl	$_printform
	call	printf
	addl	$8, %esp

Print_1_3:
	movl	$15, %ebx
	shl	$4, %ebx
	movl	12(%esp), %eax
	andl	%ebx, %eax
	shr	$4, %ebx
	pushl	%eax
	pushl	$_printform
	call	printf
	addl	$8, %esp

Print_1_4:
	movl	$15, %ebx
	movl	12(%esp), %eax
	andl	%ebx, %eax
	pushl	%eax
	pushl	$_printform
	call	printf
	addl	$8, %esp

Print_2_1:
	movl	$15, %ebx
	shl	$12, %ebx
	movl	8(%esp), %eax
	andl	%ebx, %eax
	shr	$12, %ebx
	pushl	%eax
	pushl	$_printform
	call	printf
	addl	$8, %esp

Print_2_2:
	movl	$15, %ebx
	shl	$8, %ebx
	movl	8(%esp), %eax
	andl	%ebx, %eax
	shr	$8, %ebx
	pushl	%eax
	pushl	$_printform
	call	printf
	addl	$8, %esp

Print_2_3:
	movl	$15, %ebx
	shl	$4, %ebx
	movl	8(%esp), %eax
	andl	%ebx, %eax
	shr	$4, %ebx
	pushl	%eax
	pushl	$_printform
	call	printf
	addl	$8, %esp

Print_2_4:
	movl	$15, %ebx
	movl	8(%esp), %eax
	andl	%ebx, %eax
	pushl	%eax
	pushl	$_printform
	call	printf
	addl	$8, %esp

Print_3_1:
	movl	$15, %ebx
	shl	$12, %ebx
	movl	4(%esp), %eax
	andl	%ebx, %eax
	shr	$12, %ebx
	pushl	%eax
	pushl	$_printform
	call	printf
	addl	$8, %esp

Print_3_2:
	movl	$15, %ebx
	shl	$8, %ebx
	movl	4(%esp), %eax
	andl	%ebx, %eax
	shr	$8, %ebx
	pushl	%eax
	pushl	$_printform
	call	printf
	addl	$8, %esp

Print_3_3:
	movl	$15, %ebx
	shl	$4, %ebx
	movl	4(%esp), %eax
	andl	%ebx, %eax
	shr	$4, %ebx
	pushl	%eax
	pushl	$_printform
	call	printf
	addl	$8, %esp

Print_3_4:
	movl	$15, %ebx
	movl	4(%esp), %eax
	andl	%ebx, %eax
	pushl	%eax
	pushl	$_printform
	call	printf
	addl	$8, %esp

Print_4_1:
	movl	$15, %ebx
	shl	$12, %ebx
	movl	(%esp), %eax
	andl	%ebx, %eax
	shr	$12, %ebx
	pushl	%eax
	pushl	$_printform
	call	printf
	addl	$8, %esp

Print_4_2:
	movl	$15, %ebx
	shl	$8, %ebx
	movl	(%esp), %eax
	andl	%ebx, %eax
	shr	$8, %ebx
	pushl	%eax
	pushl	$_printform
	call	printf
	addl	$8, %esp

Print_4_3:
	movl	$15, %ebx
	shl	$4, %ebx
	movl	(%esp), %eax
	andl	%ebx, %eax
	shr	$4, %ebx
	pushl	%eax
	pushl	$_printform
	call	printf
	addl	$8, %esp	

Print_4_4:
	movl	$15, %ebx
	movl	(%esp), %eax
	andl	%ebx, %eax
	pushl	%eax
	pushl	$_printform
	call	printf
	addl	$8, %esp

end:
	addl	$16, %esp

	pushl	$'\n'
	call	putchar
	addl	$4, %esp

	popl	%esi
	popl	%edi
	popl	%ebx

	movl	%ebp, %ebp
	popl	%ebp
	ret
