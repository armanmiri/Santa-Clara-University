// Name: Arman Miri
// Date: 1/19/25
// Title: Lab3 step 4 - Pthreads and inter-process Communication – Pipes
// Description: A program implementing the shell command "cat /etc/passwd | grep root" using pipes for inter-process communication.

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/wait.h>

int main() {
    int fds[2];
    
    pipe(fds);

    if (fork() == 0) 
    {
        close(fds[0]);
    
        dup2(fds[1], 1); 

        close(fds[1]);
    
        execlp("cat", "cat", "/etc/passwd", NULL);
    
        exit(0);
    } 
    else if (fork() == 0) 
    {
        close(fds[1]);
     
        dup2(fds[0], 0); 
     
        close(fds[0]);
     
        execlp("grep", "grep", "root", NULL);
     
        exit(0);
    } 
    else 
    {
        close(fds[0]);
     
        close(fds[1]);
     
        wait(0);
     
        wait(0);
    }

    return 0;
}
