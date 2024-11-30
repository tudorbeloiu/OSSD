.data
memorie: .space 1048576 /*1024x1024 */
id: .space 1
n: .space 4
numberOfFiles: .space 4
sz: .space 4
numberInput: .asciz "%d"
op: .asciz "%d"
interval: .asciz "%d: ((%d, %d), (%d, %d))\n"
getOutput: .asciz "((%d, %d), (%d, %d))\n"

.text

addfunction:
pushl %ebp
movl %esp,%ebp

movl 16(%ebp),%edi

movl $0,%edx
movl 8(%ebp),%eax
cmpl $8,%eax
jbe endaddfunction
movl $8,%ebx
divl %ebx
cmpl $0,%edx
je fillmemory
incl %eax



endaddfunction:
popl %ebp
ret

.global main

main:
/* initializam matricea cu 0 */
lea memorie,%edi
movl $0,%ebx
movl $0,%ecx

lineloop:
cmpl $1024,%ebx
je solve

movl $0,%ecx
columnloop:
cmpl $1024,%ecx
je changeline

movl $0,%edx
movl $1024,%eax
mull %ebx
addl %ecx,%eax

movb %dl,(%edi,%eax,1)
incl %ecx
jmp columnloop

changeline:
incl %ebx
jmp lineloop


solve:
pushl $n
pushl $numberInput
call scanf
popl %eax
popl %eax

movl $0,%ecx
operationsloop:
cmpl n,%ecx
je et_exit

pushl %ecx
pushl $op
pushl $numberInput
call scanf
popl %eax
popl %eax
popl %ecx

movl op,%eax

cmpl $1,%eax
je addoperation

cmpl $2,%eax
je getoperation

cmpl $3,%eax
je deleteoperation

cmpl $4,%eax
je defragmentationoperation


addoperation:
pushl %ecx
pushl $numberOfFiles
pushl $numberInput
call scanf
popl %eax
popl %eax
popl %ecx

movl $0,%eax
loopthroughoperations:
cmpl numberOfFiles,%eax
je endaddoperation

pushl %ecx
pushl %eax
pushl $id
pushl $numberInput
call scanf
popl %ebx
popl %ebx
popl %eax
popl %ecx

movl id,%ebx
andl $0xDD,%ebx
movb %bl,id

pushl %ecx
pushl %eax
pushl $sz
pushl $numberInput
call scanf
popl %ebx
popl %ebx
popl %eax
popl %ecx

lea memorie,%edi
pushl %ecx
pushl %eax
pushl %edi
pushl id
pushl sz
call addfunction
popl %ebx
popl %ebx
popl %ebx
popl %eax
popl %ecx

incl %eax
jmp loopthroughoperations

endaddoperation:
incl %ecx
jmp operationsloop



getoperation:
incl %ecx
jmp operationsloop


deleteoperation:
incl %ecx
jmp operationsloop


defragmentationoperation:
incl %ecx
jmp operationsloop

et_exit:
pushl $0
call fflush
popl %ebx

movl $1,%eax
movl $0,%ebx
int $0x80

.section .note.GNU-stack,"",@progbits
