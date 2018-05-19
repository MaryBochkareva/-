.text
.global writeu32
writeu32:

    push %ebp
    movl %esp, %ebp

    pushl %ebx
    pushl %esi

    xorl %esi, %esi

.WHILE:

    movl %eax, %ebx

    call div10

    movl %eax, %ecx

    call mul10

    subl %eax, %ebx

    movl %ebx, %eax
    addl $48, %eax

    pushl %eax

    incl %esi

    movl %ecx, %eax

    cmpl $0, %eax
    jne .WHILE

.OUTPUT:

    popl %eax

    pushl %eax
    pushl %ecx
    pushl %edx

    call writechar

    popl %edx
    popl %ecx
    popl %eax

    decl %esi
    cmpl $0, %esi
    jne .OUTPUT

    popl %esi
    popl %ebx

    movl %ebp, %esp
    popl %ebp
    ret

.text
div10:
    
    push %ebp
    movl %esp, %ebp

    pushl %ebx
    pushl %edx
    xorl %edx, %edx


    movl %eax, %ebx
    movl %eax, %edx

    shrl $2, %eax
    shrl $1, %ebx
    addl %ebx, %eax

    movl %eax, %ebx
    shrl $4, %ebx
    addl %ebx, %eax

    movl %eax, %ebx
    shrl $8, %ebx
    addl %ebx, %eax

    movl %eax, %ebx
    shrl $16, %ebx
    addl %ebx, %eax

    shrl $3, %eax


    movl %eax, %ebx
    shll $2, %ebx
    addl %eax, %ebx
    shll $1, %ebx

    subl %ebx, %edx

    cmpl $10, %edx
    jb good

    incl %eax

    good:

    popl %edx
    popl %ebx

    movl %ebp, %esp
    popl %ebp
    ret

.text
mul10:
    
    push %ebp
    movl %esp, %ebp

    pushl %ebx
    pushl %edx
    xorl %edx, %edx

    movl $10, %ebx


    pushl %edi

    movl %eax, %edi
    shll $3, %eax
    shll $1, %edi
    addl %edi, %eax


    popl %edi

    popl %edx
    popl %ebx

    movl %ebp, %esp
    popl %ebp

    ret
