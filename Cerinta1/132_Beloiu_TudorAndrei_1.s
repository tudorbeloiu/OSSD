.data
memorie: .space 1048576
id: .space 1
n: .space 4
numberOfFiles: .space 4
sz: .space 4
numberOfBlocks: .space 4
indLinie: .space 4
indJST: .space 4
indJDR: .space 4
numberInput: .asciz "%d"
op: .asciz "%d"
intervale: .asciz "%d: ((%d, %d), (%d, %d))\n"
getOutput: .asciz "((%d, %d), (%d, %d))\n"
outputZero: .asciz "((0,0), (0,0))\n"
mortiiei: .asciz "%d\n"
mortiiei2: .asciz "%d: ((%d, %d), (%d, %d))\n"
.text

addfunction:
pushl %ebp
movl %esp,%ebp

movl 8(%ebp),%edi

movl $0,%edx
movl sz,%eax
cmpl $8,%eax
jbe endaddfunctionwith0
cmpl $8192,%eax
ja endaddfunctionwith0
movl $8,%ebx
divl %ebx
movl %eax,%esi
cmpl $0,%edx
je startloop
incl %esi

startloop:
movl 12(%ebp),%ebx
movl %esi,(%ebx)

movl $0,%ebx
movl $0,%ecx
addloopline:
cmpl $1024,%ebx
je endaddfunctionwith0

movl $0,%ecx
addloopcolumn:
cmpl $1024,%ecx
je checknextline

movl $0,%edx
movl $1024,%eax
mull %ebx
addl %ecx,%eax
movl $0,%edx

movb (%edi,%eax,1),%dl /*verificam daca elementul este 0 */
cmpb $0,%dl
jne nextmemoryindexonline

movl 12(%ebp),%esi
movl (%esi),%esi

loopequalto0:
cmpl $1023,%ecx
je verificam
cmpl $0,%esi
je putem
cmpb $0,%dl
jne nextmemoryindexonline
decl %esi

movl $0,%edx
movl $1024,%eax
mull %ebx
incl %ecx
addl %ecx,%eax
movl $0,%edx

movb (%edi,%eax,1),%dl
jmp loopequalto0

verificam:
cmpl $1,%esi
je looputem
cmpl $1,%esi
ja checknextline
cmpl $0,%esi
je putem

putem:
decl %ecx
looputem:
movl 12(%ebp),%esi
movl (%esi),%esi
completarecuid:
cmpl $0,%esi
je afisareadaugare

movl $0,%edx
movl $1024,%eax
mull %ebx
addl %ecx,%eax

movl $0,%edx
movb id,%dl
movb %dl,(%edi,%eax,1)
decl %ecx
decl %esi

jmp completarecuid

nextmemoryindexonline:
incl %ecx
jmp addloopcolumn

checknextline:
incl %ebx
jmp addloopline

afisareadaugare:
incl %ecx
movl 12(%ebp),%esi
movl (%esi),%esi
addl %ecx,%esi
subl $1,%esi

movl 24(%ebp),%edx
movl %ebx,(%edx)

movl 20(%ebp),%edx
movl %esi,(%edx)

movl 16(%ebp),%edx
movl %ecx,(%edx)

movl $0,%edx
movzbl id,%edx

pushl indJDR
pushl indLinie
pushl indJST
pushl indLinie
pushl %edx
pushl $mortiiei2
call printf
popl %edx
popl %esi
popl %esi
popl %esi
popl %esi
popl %esi

jmp endaddfunction

endaddfunctionwith0:
pushl %ecx
pushl %eax
pushl %edx
pushl $outputZero
call printf
popl %esi
popl %edx
popl %eax
popl %ecx

endaddfunction:
popl %ebp
ret



getfunction:
pushl %ebp
movl %esp,%ebp

movl 8(%ebp),%edi
movl $0,%ecx
movl $0,%ebx

getloopline:
cmpl $1024,%ebx
je getprint0interval

movl $0,%ecx
getloopcolumn:
cmpl $1023,%ecx
je changelineget

movl $0,%edx
movl $1024,%eax
mull %ebx
addl %ecx,%eax
movl $0,%edx

movb (%edi,%eax,1),%dl
cmpb id,%dl
jne changecolumnget

movl 20(%ebp),%esi
movl %ebx,(%esi) /*punem indicele liniei in memorie la adresa lui indLinie */

movl 12(%ebp),%esi
movl %ecx,(%esi) /*indicele din stanga */
whileisid:
cmpl $1023,%ecx
je verifget
cmpb id,%dl
jne afisareget

incl %ecx
movl $0,%edx
movl $1024,%eax
mull %ebx
addl %ecx,%eax
movl $0,%edx
movb (%edi,%eax,1),%dl
jmp whileisid

changecolumnget:
incl %ecx
jmp getloopcolumn

changelineget:
incl %ebx
jmp getloopline

verifget:
cmpb id,%dl
je afisareget2

afisareget:
decl %ecx
afisareget2:
movl 16(%ebp),%esi
movl %ecx,(%esi) /*aici se termina id ul */

pushl indJDR
pushl indLinie
pushl indJST
pushl indLinie
pushl $getOutput
call printf
popl %eax
popl %eax
popl %eax
popl %eax
popl %eax

jmp endgetfunction

getprint0interval:
pushl $outputZero
call printf
popl %eax

endgetfunction:
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

movl n,%ecx
operationsloop:
cmpl $0,%ecx
je et_exit

pushl %ecx
pushl $op
pushl $numberInput
call scanf
popl %eax
popl %eax
popl %ecx

movl $0,%eax
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
movl id,%edx
andl $0xFF,%edx
movb %dl,id

pushl %ecx
pushl %eax
pushl $indLinie
pushl $indJDR
pushl $indJST
pushl $numberOfBlocks
pushl %edi
call addfunction
popl %ebx
popl %ebx
popl %ebx
popl %ebx
popl %ebx
popl %eax
popl %ecx

incl %eax
jmp loopthroughoperations

endaddoperation:
decl %ecx
jmp operationsloop



getoperation:
pushl %ecx
pushl $id
pushl $numberInput
call scanf
popl %eax
popl %eax
popl %ecx

lea memorie,%edi
movl id,%edx
andl $0xFF,%edx
movb %dl,id

pushl %ecx
pushl $indLinie
pushl $indJDR
pushl $indJST
pushl %edi
call getfunction
popl %eax
popl %eax
popl %eax
popl %eax
popl %ecx

decl %ecx
jmp operationsloop


deleteoperation:
decl %ecx
jmp operationsloop


defragmentationoperation:
decl %ecx
jmp operationsloop

et_exit:
pushl $0
call fflush
popl %ebx

movl $1,%eax
movl $0,%ebx
int $0x80

.section .note.GNU-stack,"",@progbits
