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
tempmemorie: .space 1048576
distanta: .space 4
elementinit: .space 4
saveEAX: .space 4
saveEBX: .space 4
saveECX: .space 4
saveEDX: .space 4
linia: .space 4
coloana: .space 4
numberInput: .asciz "%d"
op: .asciz "%d"
getOutput: .asciz "((%d, %d), (%d, %d))\n"
outputZero: .asciz "((0,0), (0,0))\n"
intervalOutput: .asciz "%d: ((%d, %d), (%d, %d))\n"
otpget: .asciz "((%d, %d), (%d, %d))\n"

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
pushl $intervalOutput
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
pushl $otpget
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



deletefunction:
pushl %ebp
movl %esp,%ebp

movl 8(%ebp),%edi
movl $0,%ecx
movl $0,%ebx

delloopline:
cmpl $1024,%ebx
je enddeletefunction

movl $0,%ecx
delloopcolumn:
cmpl $1024,%ecx
je delchangeline

movl $1024,%eax
movl $0,%edx
mull %ebx
addl %ecx,%eax
movl $0,%edx
movb (%edi,%eax,1),%dl

cmpb id,%dl
jne delchangecolumn
deletemyid:
cmpl $1023,%ecx
je checktodelete

cmpb id,%dl
jne enddeletefunction

movl $0,%edx
movl $1024,%eax
mull %ebx
addl %ecx,%eax
movl $0,%edx

movb %dl,(%edi,%eax,1)
incl %ecx
incl %eax
movb (%edi,%eax,1),%dl
jmp deletemyid

delchangecolumn:
incl %ecx
jmp delloopcolumn

delchangeline:
incl %ebx
jmp delloopline

checktodelete:
cmpb id,%dl
jne enddeletefunction

movl $0,%edx
movb %dl,(%edi,%eax,1)

enddeletefunction:
popl %ebp
ret


printmemoryfunction:
pushl %ebp
movl %esp,%ebp

movl 8(%ebp),%edi
/* 12 pt indJST, 16 indJDR, 20 indLinie */
movl $0,%esi
movl $0,%ecx

looplineprint:
cmpl $1024,%esi
je endprintmemoryfunction

movl $0,%ecx
loopcolumnprint:
cmpl $1023,%ecx
jae changelineprint

movl $1024,%eax
movl $0,%edx
mull %esi
addl %ecx,%eax
movl $0,%edx

movb (%edi,%eax,1),%dl
cmpb $0,%dl
je changecolumnprint

movl 20(%ebp),%ebx
movl %esi,(%ebx) /* punem linia */
movl 12(%ebp),%ebx
movl %ecx,(%ebx) /*punem indJST */

movl $0,%ebx
movb %dl,%bl

printcurrentid:
cmpl $1023,%ecx
je checkifsameid

cmpb %dl,%bl
jne etecxdecrease

incl %ecx
incl %eax
movb (%edi,%eax,1),%bl
jmp printcurrentid


checkifsameid:
cmpb %dl,%bl
je thisonetoo
etecxdecrease:
decl %ecx
jmp thisonetoo

changecolumnprint:
incl %ecx
jmp loopcolumnprint

changelineprint:
incl %esi
jmp looplineprint

thisonetoo:
movl 16(%ebp),%ebx /* indJDR */
movl %ecx,(%ebx)
jmp printinterval

printinterval:
pushl %ecx
pushl %esi
pushl indJDR
pushl indLinie
pushl indJST
pushl indLinie
pushl %edx
pushl $intervalOutput
call printf
popl %eax
popl %eax
popl %eax
popl %eax
popl %eax
popl %eax
popl %esi
popl %ecx

jmp changecolumnprint

endprintmemoryfunction:
popl %ebp
ret




defragmentationfunction:
pushl %ebp
movl %esp,%ebp

movl 32(%ebp),%edi

movl $0,%esi
movl $0,%ecx

looplinedefrag:
cmpl $1024,%esi
je enddefragmentationfunction

movl $0,%ecx
loopcolumndefrag:
cmpl $1024,%ecx
je changelooplinedefrag

movl $1024,%eax
movl $0,%edx
mull %esi
addl %ecx,%eax
movl $0,%edx

movb (%edi,%eax,1),%dl
cmpb $0,%dl
je changeloopcolumndefrag

movb %dl,id

movl 8(%ebp),%ebx
movl %ecx,(%ebx) /*punem indicele din stanga */
movl 16(%ebp),%ebx
movl %esi,(%ebx) /*punem linia */

defragloopsameid:
cmpl $1023,%ecx
je verifdefrag

cmpb id,%dl
jne defragdecrecx

incl %ecx
movl $0,%edx
movl $1024,%eax
mull %esi
addl %ecx,%eax
movl $0,%edx
movb (%edi,%eax,1),%dl

jmp defragloopsameid

verifdefrag:
cmpb id,%dl
je findmyplace

defragdecrecx:
decl %ecx
findmyplace:
movl 12(%ebp),%ebx
movl %ecx,(%ebx) /*unde se termina id ul */

movl 36(%ebp),%ebx
movl %ecx,(%ebx) /*salvam ecx ul */

movl 40(%ebp),%ebx
movl %esi,(%ebx) /* salvam esi ul*/

movl 8(%ebp),%ebx
movl (%ebx),%ebx
subl %ebx,%ecx
incl %ecx /*distanta*/

movl $0,%edx
movl 52(%ebp),%edx
movl (%edx),%edx
movl $1024,%ebx
subl %edx,%ebx

cmpl %ecx,%ebx
jae insertonline

nextlineondefrag:
movl 48(%ebp),%edx
movl (%edx),%edx
incl %edx
movl 48(%ebp),%eax
movl %edx,(%eax) /*linia = linia + 1 */

movl 52(%ebp),%edx
movl $0,(%edx) /*coloana este 0*/

insertonline:
movl 28(%ebp),%esi
movl 20(%ebp),%eax
movl %ecx,(%eax) /*retinem dist */
loopidk:
cmpl $0,%ecx
je increasetempcolumn

decl %ecx
movl $1024,%eax
movl $0,%edx
movl 48(%ebp),%ebx
movl (%ebx),%ebx
mull %ebx
movl 52(%ebp),%ebx
movl (%ebx),%ebx
addl %ebx,%eax
addl %ecx,%eax   /*t[linia*8+coloana+i] = elementinit */ 

movl $0,%edx
movzbl id,%edx
movb %dl,(%esi,%eax,1)
jmp loopidk

increasetempcolumn:
movl 20(%ebp),%eax
movl (%eax),%eax
addl %eax,%ebx
movl 52(%ebp),%eax
movl %ebx,(%eax) /*coloana = coloana + dist */

movl 36(%ebp),%ecx
movl (%ecx),%ecx

movl 40(%ebp),%esi
movl (%esi),%esi

movl 20(%ebp),%ebx
movl (%ebx),%ebx

movl 32(%ebp),%edi
stergemdinmem:
cmpl $0,%ebx
je revenireregistrii

movl $0,%edx
movl $1024,%eax
mull %esi
addl %ecx,%eax
movl $0,%edx
movb %dl,(%edi,%eax,1)
decl %ecx
decl %ebx

revenireregistrii:
incl %ecx
movl 36(%ebp),%ebx
movl %ecx,(%ebx)

movl 40(%ebp),%esi
movl (%esi),%esi


changeloopcolumndefrag:
incl %ecx
jmp loopcolumndefrag

changelooplinedefrag:
incl %esi
jmp looplinedefrag

enddefragmentationfunction:
popl %ebp
ret


initializareCuZero:
pushl %ebp
movl %esp,%ebp

movl 8(%ebp),%esi

movl $0,%ebx
movl $0,%ecx
looplineinitzero:
cmpl $1024,%ebx
je endinitializareCuZero

movl $0,%ecx
loopcolumninitzero:
cmpl $1024,%ecx
je changelineinitzero

movl $0,%edx
movl $1024,%eax
mull %ebx
addl %ecx,%eax

movl $0,%edx
movb %dl,(%esi,%eax,1)
incl %ecx

changelineinitzero:
incl %ebx
jmp looplineinitzero

endinitializareCuZero:
popl %ebp
ret


changeelements:
pushl %ebp
movl %esp,%ebp

movl 8(%ebp),%esi
movl 12(%ebp),%edi

movl $0,%ebx
movl $0,%ecx
linechangeelements:
cmpl $1024,%ebx
je endchangeelements

movl $0,%ecx
columnchangeelements:
cmpl $1024,%ecx
je lineincreaseelements

movl $1024,%eax
movl $0,%edx
mull %ebx
addl %ecx,%eax
movl $0,%edx

movb (%esi,%eax,1),%dl
movb %dl,(%edi,%eax,1)

incl %ecx

lineincreaseelements:
incl %ebx
jmp linechangeelements

endchangeelements:
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
pushl %ecx
pushl $id
pushl $numberInput
call scanf
popl %eax
popl %eax
popl %ecx

movl id,%edx
andl $0xFF,%edx
movb %dl,id

lea memorie,%edi

pushl %ecx
pushl %edi
call deletefunction
popl %eax
popl %ecx

/* acum printam intervalele existente prin functia de afisare(o sa mai avem nevoie de ea) */
lea memorie,%edi

pushl %ecx
pushl $indLinie
pushl $indJDR
pushl $indJST
pushl %edi
call printmemoryfunction
popl %eax
popl %eax
popl %eax
popl %eax
popl %ecx


decl %ecx
jmp operationsloop


defragmentationoperation:
lea memorie,%edi
lea tempmemorie,%esi

pushl %ecx
pushl %esi
call initializareCuZero
popl %eax
popl %ecx

movl $0,%eax
movl %eax,coloana
movl %eax,linia

lea memorie,%edi
lea tempmemorie,%esi

pushl %ecx
pushl $coloana
pushl $linia
pushl $saveEAX
pushl $saveEBX
pushl $saveECX
pushl %edi
pushl %esi
pushl $elementinit
pushl $distanta
pushl $indLinie
pushl $indJDR
pushl $indJST
call defragmentationfunction
popl %eax
popl %eax
popl %eax
popl %eax
popl %eax
popl %eax
popl %eax
popl %eax
popl %eax
popl %eax
popl %eax
popl %eax
popl %ecx

lea memorie,%edi
lea tempmemorie,%esi

pushl %ecx
pushl %edi
pushl %esi
call changeelements
popl %eax
popl %eax
popl %ecx

lea tempmemorie,%edi

pushl %ecx
pushl $indLinie
pushl $indJDR
pushl $indJST
pushl %edi
call printmemoryfunction
popl %eax
popl %eax
popl %eax
popl %eax
popl %ecx

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
