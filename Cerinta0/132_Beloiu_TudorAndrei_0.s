.data
n: .space 4
id: .space 1
dim: .space 4
op: .space 4
memorie: .space 1024
nadd: .space 4
stGet: .space 4
drGet: .space 4
stPrint: .space 4
drPrint: .space 4
inp: .asciz "%d"
inpN: .asciz "%d"
inpOp: .asciz "%d"
outOp: .asciz "%d\n"
outAdd: .asciz "%d: (%d, %d)\n"
outGet: .asciz "(%d, %d)\n"
outGetZero: .asciz "%d: (%d, %d)\n"
comb: .asciz "%hhu si %d\n"
outPrint: .asciz "%d: (%d, %d)\n"
outZero: .asciz "%d: (0, 0)\n"
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
jbe nextidfalse /*obligatoriu fiecare id e pus pe minim 2 blocuri */
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
je nextidfalse

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
cmpl %esi,%eax
je putem
cmpb $0,%dl
jne check
incl %esi

check:
cmpl %esi,%eax
ja nextmemoryindex
je looputem
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

nextidfalse:
movl $0,%edx
movzbl id,%edx

pushl %ecx
pushl %edx
pushl $outZero
call printf
popl %edx
popl %eax
popl %ecx

decl %ecx
jmp etloopadd

nextidtrue:
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

jmp nextidtrue

endaddfunc:
popl %ebp
ret



funcprintmemory:
pushl %ebp
movl %esp,%ebp

movl 8(%ebp),%edi
movl $0,%ebx

movl $0,%eax
loopfuncprintmemory:
cmpl $1023,%ebx /* orice fisier are minim 2 blocuri deci automat daca ajunge la 1023 nu mai exista niciun fisier(memoria are 1024 bytes) */
jae endfuncprintmemory

movl $0,%eax
movl $0,%edx
movb (%edi,%ebx,1),%dl

cmpb %dl,%al /*daca sunt diferite inseamna ca am gasit un fisier */
je nextindexprintmemory

movl 16(%ebp),%esi
movl %ebx,(%esi) /* punem in stPrint indicele de unde incepe id ul */
movb (%edi,%ebx,1),%al

printcurrid:
cmpl $1023,%ebx
je checkifelementequaltoo
cmpb %al,%dl
jne etidecrease /* 1 */

incl %ebx
movb (%edi,%ebx,1),%dl
jmp printcurrid

checkifelementequaltoo:
cmpb %al,%dl
je thisonetoo
/* daca nu sunt egale, scadem 1 din ebx ca asta inseamna ca sirul id ului se termina cu o pozitie mai in spate */
etidecrease: /* 1 */
decl %ebx
jmp thisonetoo

thisonetoo:
movl 12(%ebp),%esi
movl %ebx,(%esi) /* punem in adresa de memorie a lui drPrint valoarea lui ebx */
jmp printinterval

nextindexprintmemory:
incl %ebx
movl $0,%edx
movb (%edi,%ebx,1),%dl
jmp loopfuncprintmemory

printinterval:


movl 16(%ebp),%esi
movl (%esi),%esi
movl 12(%ebp),%edx
movl (%edx),%edx
/*al are id ul */

pushl %ecx
pushl %ebx
pushl %edx
pushl %esi
pushl %eax
pushl $outPrint
call printf
popl %eax
popl %eax
popl %eax
popl %eax
popl %ebx
popl %ecx

jmp nextindexprintmemory

endfuncprintmemory:
popl %ebp
ret

/* ideea e sa parcurg memoria(cu index ul ecx)  si cand gasesc element diferit de 0 sa i dau rewrite pe pozitia ebx */
/* dupa aceea, trebuie sa facem toate elementele de dupa ebx 0 */
rewritememory:
pushl %ebp
movl %esp,%ebp

movl 8(%ebp),%edi
movl $0,%ebx
movl $0,%ecx
movl $0,%edx

looprewritememory:
cmpl $1024,%ecx
je insert0afterebx

movl $0,%edx
movb (%edi,%ecx,1),%dl
cmpb $0,%dl
/* daca sunt diferite, il pun in memorie pe pozitia ebx */
jne insertmemory

incl %ecx
jmp looprewritememory

insertmemory:
movb %dl,(%edi,%ebx,1)
incl %ebx
incl %ecx
jmp looprewritememory

insert0afterebx:
cmpl $1024,%ebx
je endfuncrewritememory

movl $0,%edx
movb %dl,(%edi,%ebx,1)

incl %ebx
jmp insert0afterebx

endfuncrewritememory:
popl %ebp
ret


.global main

main:
pushl $n
pushl $inpN
call scanf
popl %eax
popl %eax

lea memorie,%edi
movl $0,%ecx
memoryinit0:
cmpl $1024,%ecx
je solveproject

movl $0,%eax
movb %al,(%edi,%ecx,1)

incl %ecx
jmp memoryinit0

solveproject:
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

cmpl $3,%eax
je deleteoperation

cmpl $4,%eax
je defragoperation

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
movl $0,%edx
movzbl id,%edx

movl $0,%eax
movl %eax,stGet
movl %eax,drGet

pushl %ecx
pushl drGet
pushl stGet
pushl %edx
pushl $outGetZero
call printf
popl %edx
popl %eax
popl %eax
popl %eax
popl %ecx

decl %ecx
jmp etloop


deleteoperation:
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

loopfindidtodelete:
cmpl $1023,%ebx
je printmemory

cmpb %al,%dl
jne nextindexfinddelete
foundidtodelete:
cmpl $1023,%ebx
je deletecheck

cmpb %al,%dl
jne printmemory

movl $0,%edx
movb %dl,(%edi,%ebx,1)
incl %ebx
movb (%edi,%ebx,1),%dl
jmp foundidtodelete

nextindexfinddelete:
incl %ebx
movb (%edi,%ebx,1),%dl
jmp loopfindidtodelete

deletecheck:
cmpb %al,%dl
je deletethisebxtoo
jmp printmemory

deletethisebxtoo:
movl $0,%edx
movb %dl,(%edi,%ebx,1)
jmp printmemory

/* functie universala pentru a afisa toate id urile + intervale din memorie */
printmemory:
lea memorie,%edi
pushl %ecx
pushl $stPrint
pushl $drPrint
pushl %edi
call funcprintmemory
popl %eax
popl %eax
popl %eax
popl %ecx

decl %ecx
jmp etloop

defragoperation:
lea memorie,%edi

pushl %ecx
pushl %edi
call rewritememory
popl %eax
popl %ecx

jmp printmemory

etexit:
pushl $0
call fflush
popl %eax

movl $1,%eax
movl $0,%ebx
int $0x80

.section .note.GNU-stack,"",@progbits
