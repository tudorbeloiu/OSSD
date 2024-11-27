.data
n: .space 4
id: .space 1
dim: .space 4
op: .space 4
memorie: .space 1024
nadd: .space 4
stGet: .space 4
drGet: .space 4
inp: .asciz "%d"
inpN: .asciz "%d"
inpOp: .asciz "%d"
outOp: .asciz "%d\n"
outAdd: .asciz "%d: (%d, %d)\n"
outGet: .asciz "(%d, %d)\n"
comb: .asciz "%hhu si %d\n"
.text

addfunc:
pushl %ebp
movl %esp,%ebp

movl 8(%ebp),%edi
movl 12(%ebp),%ecx

//acum citim combinatia id-dimensiune fisier si completam vectorul
etloopadd:
cmpl $0,%ecx
je endaddfunc

pushl %ecx
pushl $id
pushl $inp
call scanf
popl %eax
popl %eax
popl %ecx


movl id,%eax
andl $0xFF,%eax
movb %al,id

pushl %ecx
pushl $dim
pushl $inp
call scanf
popl %eax
popl %eax
popl %ecx

/*
pushl %ecx
pushl dim
pushl id
pushl $comb
call printf
popl %eax
popl %eax
popl %eax
popl %ecx
*/
movl $0,%edx
movl dim,%eax
cmpl $8,%eax
jbe nextid /*obligatoriu fiecare id e pus pe minim 2 blocuri */
movl $8,%ebx
divl %ebx /*eax retine initial nr de blocuri; daca edx e mai mare decat 0, inseamna ca nr de blocuri +=1*/
cmpl $0,%edx
je completarememorie
incl %eax

completarememorie:
movl 8(%ebp),%edi
movl $0,%ebx
loopcompletarememorie:
cmpl $1024,%ebx
je nextid

movl $0,%edx
movb (%edi,%ebx,1),%dl /*verificam daca elementul este 0 */
cmpb $0,%dl
jne nextmemoryindex
/*daca gasim element egal cu 0 verificam daca e destul spatiu pt eax*/

movl $0,%esi
loopequalto0:
cmpl $1023,%ebx
je verificam
cmpl %esi,%eax
je putem
cmpb $0,%dl
jne nextmemoryindex
incl %esi

incl %ebx
movb (%edi,%ebx,1),%dl
jmp loopequalto0

verificam:
cmpb $0,%dl
jne check
incl %esi

check:
cmpl %esi,%eax
ja nextmemoryindex
putem:
decl %ebx
looputem:
cmpl $0,%eax
je afisareadaugare

movl $0,%edx
movb id,%dl
movb %dl,(%edi,%ebx,1)
decl %ebx
decl %eax
jmp looputem

nextmemoryindex:
incl %ebx
jmp loopcompletarememorie

nextid:
decl %ecx
jmp etloopadd

afisareadaugare:
incl %ebx
addl %ebx,%eax
addl %esi,%eax
subl $1,%eax

movl $0,%edx
movzbl id,%edx

pushl %ecx
pushl %eax
pushl %ebx
pushl %edx
pushl $outAdd
call printf
popl %eax
popl %edx
popl %eax
popl %eax
popl %ecx

jmp nextid

endaddfunc:
popl %ebp
ret


.global main

main:
pushl $n
pushl $inpN
call scanf
popl %eax
popl %eax

movl n,%ecx
etloop:
cmp $0,%ecx
je etexit

pushl %ecx
pushl $op
pushl $inpOp
call scanf
popl %eax
popl %eax
popl %ecx

movl op,%eax
cmpl $1,%eax
je addoperation

cmpl $2,%eax
je getoperation

//mai jos afisez operatiile sa vad ca sunt ok
/*
pushl %ecx
pushl op
pushl $outOp
call printf
popl %eax
popl %eax
popl %ecx
*/
decl %ecx
jmp etloop


addoperation:
pushl %ecx
pushl $nadd
pushl $inp
call scanf
popl %eax
popl %eax
popl %ecx

lea memorie,%edi

pushl %ecx
pushl nadd
pushl %edi
call addfunc
popl %eax
popl %eax
popl %ecx

decl %ecx
jmp etloop


getoperation:
pushl %ecx
pushl $id
pushl $inp
call scanf
popl %eax
popl %eax
popl %ecx

movl $0,%eax
movb id,%al

lea memorie,%edi
movl $0,%ebx
movl $0,%edx
movb (%edi,%ebx,1),%dl
getloop:
cmpl $1023,%ebx
je afisare0get
cmpb %al,%dl
jne nextindexget

movl %ebx,stGet
getToFindloop:
cmpl $1023,%ebx
je verifget
cmpb %dl,%al
jne afisareget

incl %ebx
movl $0,%edx
movb (%edi,%ebx,1),%dl
jmp getToFindloop

nextindexget:
incl %ebx
movb (%edi,%ebx,1),%dl
jmp getloop

verifget:
cmpb %al,%dl
je afisareget2

afisareget:
decl %ebx
afisareget2:
movl %ebx,drGet
pushl %ecx
pushl drGet
pushl stGet
pushl $outGet
call printf
popl %eax
popl %eax
popl %eax
popl %ecx

decl %ecx
jmp etloop



afisare0get:
movl $0,%eax
movl %eax,stGet
movl %eax,drGet

pushl %ecx
pushl drGet
pushl stGet
pushl $outGet
call printf
popl %eax
popl %eax
popl %eax
popl %ecx

decl %ecx
jmp etloop


etexit:
pushl $0
call fflush
popl %eax

movl $1,%eax
movl $0,%ebx
int $0x80

.section .note.GNU-stack,"",@progbits
