.data
max_path_size: .space 256
dir: .space 256
str_input: .asciz "%s"
str_output: .asciz "%s\n"
int_output: .asciz "%d\n"
error_msg: .asciz "Eroare! Nu am putut deschide directorul!\n"
error_msg_file: .asciz "Eroare! Nu am putut deschide fisierul!\n"
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
.text

.global main

main:
pushl $dir
pushl $str_input
call scanf
addl $8,%esp

pushl $dir
call opendir
addl $4,%esp

cmpl $0,%eax
je open_error /* daca eax este 0 (NULL), inseamna ca nu putem deschide directorul*/

movl %eax,dir_ptr  /* retin in dir_ptr adresa directorului */

et_read_loop:
movl dir_ptr,%eax /* in eax retinem pointer catre DIR */
pushl %eax
call readdir
addl $4,%esp

movl %eax,%ebx
testl %ebx,%ebx
jz close_dir

addl offset,%ebx
movl %ebx,file_name /* salvez pointer catre numele fisierului(fara concatenare la path) */
/* offset ul este necesar ca sa ajung la d_name din structura dirent */

/* acum trb sa verificam daca este dif de dir parinte si de dir curent */

pushl $dot
pushl %ebx
call strcmp
addl $8,%esp
testl %eax,%eax
jz et_read_loop

pushl $dotdot
pushl %ebx
call strcmp
addl $8,%esp
testl %eax,%eax
jz et_read_loop

/* acum trb sa construiesc full path ul : /home/tudorbeloiu/.../file1.txt */
/* int snprintf(char *str, size_t size, const char *format,..,..) */
pushl %ebx /* entry -> d_name din codul c multumim iancu <3 */
pushl $dir
pushl $format_path
pushl $512
pushl $full_file_path
call snprintf /* snprintf rescrie complet full_path cu noua cale completa */
addl $20,%esp

/*
pushl $full_file_path
pushl $str_output
call printf
addl $8,%esp
*/
/* int open(const char *path, int flags) la noi flags e readonly */

pushl $0
pushl $full_file_path
call open
addl $8,%esp

/* fd e in eax */

movl %eax,fd
movl %eax,fd_nou
movl %eax,%ebx
testl %ebx,%ebx

js open_fail /* daca descriptorul e negativ inseamna ca e fail */

/*
pushl fd
pushl $int_input
call printf
addl $8,%esp
*/
movl fd_nou,%eax
movl $0,%edx
movl $255,%ebx
divl %ebx
movl $0,%ebx
movl %edx,%ebx
incl %ebx
movl %ebx,fd_nou

/*
pushl fd_nou
pushl $int_output
call printf
addl $8,%esp
*/

pushl $file_stat
pushl fd
call fstat
addl $8,%esp

cmpl $0,%eax /* daca eax este -1 inseamna ca avem o eroare */
jl open_fail

movl $file_stat,%eax
movl 44(%eax),%ebx

pushl %ebx
pushl fd_nou
pushl $full_file_path
pushl $msj_complet
call printf
addl $16,%esp

jmp et_read_loop

open_fail:
pushl $error_msg_file
call printf
addl $4,%esp

jmp et_read_loop

close_dir:
pushl %ebx
call closedir
addl $4,%esp
jmp et_exit

open_error:
pushl $error_msg
call printf
addl $4,%esp

et_exit:
movl $1,%eax
movl $0,%ebx
int $0x80

.section .note.GNU-stack,"",@progbits


