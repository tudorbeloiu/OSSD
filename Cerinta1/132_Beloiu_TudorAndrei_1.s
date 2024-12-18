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
getOutputZero: .asciz "((0, 0), (0, 0))\n"
outputZero: .asciz "%d: ((0, 0), (0, 0))\n"
intervalOutput: .asciz "%d: ((%d, %d), (%d, %d))\n"
otpget: .asciz "((%d, %d), (%d, %d))\n"
/* mai jos sunt pt concrete */
max_path_size: .space 256
dir: .space 256
str_input: .asciz "%s"
str_output: .asciz "%s\n"
int_output: .asciz "%d\n"
format_path: .asciz "%s/%s"
dir_ptr: .space 4
file_name: .space 256
full_file_path: .space 512
offset: .long 11 /* pentru d_name, structura dirent are mai multe campuri */
dot: .asciz "."
dotdot: .asciz ".."
fd: .space 4
fd_nou: .space 4
file_stat: .space 96
st_size: .space 128
msj_complet: .asciz "File: %s, Descriptor: %d, Size: %d\n"
ok: .space 4
isConcrete: .space 4
outputConcrete: .asciz "(%d, %d): ((%d, %d), (%d, %d))\n"
outputZeroConcrete: .asciz "(%d, %d): ((0, 0), (0, 0))\n"
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
movl isConcrete,%esi
cmpl $1,%esi
je afisarePentruConcrete

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

afisarePentruConcrete:
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
pushl sz
pushl %edx
pushl $outputConcrete
call printf
popl %esi
popl %edx
popl %esi
popl %esi
popl %esi
popl %esi
popl %esi

jmp endaddfunction


endaddfunctionwith0:
movl isConcrete,%edx
cmpl $1,%edx
je outputForConcrete

movl $0,%edx
movzbl id,%edx

pushl %ecx
pushl %eax
pushl %edx
pushl $outputZero
call printf
popl %esi
popl %edx
popl %eax
popl %ecx

jmp endaddfunction

outputForConcrete:
movl $0,%edx
movzbl id,%edx

pushl %ecx
pushl %eax
pushl sz
pushl %edx
pushl $outputZeroConcrete
call printf
popl %esi
popl %edx
popl %esi
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
pushl %edx
pushl $getOutputZero
call printf
popl %edx
popl %eax


endgetfunction:
popl %ebp
ret



get_concrete:
pushl %ebp
movl %esp,%ebp

movl 8(%ebp),%edi
movl $0,%ecx
movl $0,%ebx
/* in 12 ebp am ok ul */

get_concrete_line:
cmpl $1024,%ebx
je end_get_concrete

movl $0,%ecx
get_concrete_column:
cmpl $1023,%ecx
je changelineget_concrete

movl $0,%edx
movl $1024,%eax
mull %ebx
addl %ecx,%eax
movl $0,%edx

movb (%edi,%eax,1),%dl
cmpb id,%dl
jne changecolumnget_concrete

jmp found_cant_place

changecolumnget_concrete:
incl %ecx
jmp get_concrete_column

changelineget_concrete:
incl %ebx
jmp get_concrete_line


found_cant_place:
movl 12(%ebp),%eax
movl $0,(%eax)

end_get_concrete:
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

movl 32(%ebp),%edi

movl distanta,%ebx
stergemdinmem:
cmpl $0,%ebx
jl revenireregistrii

movl $0,%edx
movl $1024,%eax
mull %esi
addl %ecx,%eax
movl $0,%edx
movb %dl,(%edi,%eax,1)
decl %ecx
decl %ebx

jmp stergemdinmem
revenireregistrii:
incl %ecx
movl 32(%ebp),%edi

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

jmp loopcolumninitzero

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
jmp columnchangeelements

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

cmpl $5,%eax
je concreteoperation

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

movl $0,%edx
lea memorie,%edi
movl id,%edx
andl $0xFF,%edx
movb %dl,id

/* prima data vedem daca exista in memorie deja */
movl $1,%edx
movl %edx,ok

pushl %eax
pushl %ecx
pushl $ok
pushl %edi
call get_concrete
addl $8,%esp
popl %ecx
popl %eax

movl $2,%edx
movl %edx,isConcrete

movl ok,%edx

cmpl $1,%edx
jne next_in_add

lea memorie,%edi
movl $0,%edx
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

next_in_add:
pushl %ecx
pushl %eax
pushl id
pushl $outputZero
call printf
popl %ebx
popl %ebx
popl %eax
popl %ecx

incl %eax
jmp loopthroughoperations

endaddoperation:
/*
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
*/

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


concreteoperation:
pushl %ecx
pushl $dir
pushl $str_input
call scanf
addl $8,%esp
popl %ecx

pushl %ecx
pushl $dir
call opendir
addl $4,%esp
popl %ecx

cmpl $0,%eax
je et_next_opp /* daca eax este 0 (NULL), inseamna ca nu putem deschide directorul */

movl %eax,dir_ptr /* retin in dir_ptr adresa directorului */

et_read_files:
pushl %ecx
movl dir_ptr,%eax
pushl %eax
call readdir
addl $4,%esp
popl %ecx

movl %eax,%ebx
testl %ebx,%ebx
jz close_dir


addl offset,%ebx
movl %ebx,file_name /* salvez pointer catre numele fisierului(fara concatenare la path) */
/* offset ul este necesar ca sa ajung la d_name din structura dirent */

/* acum verificam daca numele este diferit de . si de .. ( director curent si dir parinte ) */

pushl %ecx
pushl $dotdot
pushl %ebx
call strcmp
addl $8,%esp
popl %ecx

testl %eax,%eax
jz et_read_files

pushl %ecx
pushl $dot
pushl %ebx
call strcmp
addl $8,%esp
popl %ecx

testl %eax,%eax
jz et_read_files

/* acum construiesc path ul full /home/tudorbeloiu/.../file1.txt */
/* int snprintf(char *str, size_t size,const char *format , x1, x2 ) */

pushl %ecx
pushl %ebx /* contine entry -> d_name */
pushl $dir
pushl $format_path
pushl $512
pushl $full_file_path
call snprintf
addl $20,%esp /*snprintf rescrie complet full_path cu noua cale completa */
popl %ecx

pushl %ecx
pushl $0 /* 0_RDNLY */
pushl $full_file_path
call open
addl $8,%esp
popl %ecx

/* fd este in eax */

movl %eax,fd
movl %eax,fd_nou
movl %eax,%ebx
testl %ebx,%ebx

js et_read_files

/* noi trebuie sa facem (fd % 255) + 1 */
movl fd_nou,%eax
movl $0,%edx
movl $255,%ebx
divl %ebx
movl $0,%ebx
movl %edx,%ebx
incl %ebx
movl %ebx,fd_nou

pushl %ecx
pushl $file_stat
pushl fd
call fstat
addl $8,%esp
popl %ecx

cmpl $0,%eax /* daca eax este -1 inseamna ca avem o eroare */
jl et_read_files

movl $file_stat,%eax
movl 44(%eax),%ebx /* offset ul pana la st_size este 44 */

/* acum trebuie sa verificam daca fd exista deja in memorie */
/* daca nu exista, folosim add ul deja implementat */
movl %ebx,%eax
movl $0,%edx
movl $1024,%esi
divl %esi
movl %eax,%ebx /* trebuie sa transformam in kb (adica /1024) */
movl %ebx,sz

lea memorie,%edi
movl fd_nou,%edx
movb %dl,id

movl $1,%eax
movl %eax,isConcrete

movl $1,%eax
movl %eax,ok

pushl %ebx
pushl %ecx
pushl $ok
pushl %edi
call get_concrete
addl $8,%esp
popl %ecx
popl %ebx

/* daca ok este 1 inseamna ca nu l am gasit si putem face add cu el */
movl ok,%eax
cmpl $1,%eax
jne descriptor_repetat

movl %ebx,sz

pushl %ecx
pushl %ebx
pushl $indLinie
pushl $indJDR
pushl $indJST
pushl $numberOfBlocks
pushl %edi
call addfunction
addl $20,%esp
popl %ebx
popl %ecx
/* acum trebuie sa afisam sub forma (id,dimensiune): (...) */
jmp et_read_files

descriptor_repetat:
pushl %ecx
pushl sz
pushl fd_nou
pushl $outputZeroConcrete
call printf
addl $12,%esp
popl %ecx

jmp et_read_files

/*
pushl %ecx
pushl %ebx
pushl fd_nou
pushl $full_file_path
pushl $msj_complet
call printf
addl $16,%esp
popl %ecx
*/


close_dir:
pushl %ecx
pushl %ebx
call closedir
addl $4,%esp
popl %ecx
et_next_opp:
decl %ecx
jmp operationsloop
/*
jmp print_memory_concrete

print_memory_concrete:
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
*/

et_exit:
pushl $0
call fflush
popl %ebx

movl $1,%eax
movl $0,%ebx
int $0x80

.section .note.GNU-stack,"",@progbits
