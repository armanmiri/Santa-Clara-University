// Name: Arman Miri
// Date: 1/19/25
// Title: Lab3 step 3 - Pthreads and inter-process Communication – Pipes
// Description: A program where the writer process executes the "ls" command and passes its output to a pipe, while the reader process prints the output.

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <sys/wait.h>

// main
int main(int argc, char *argv[]) {
    int fds[2];
    char buff[60];
    int count;
    int i;

    pipe(fds);

    if (fork() == 0) 
    {
        printf("\nWriter on the upstream end of the pipe\n");
    
        close(fds[0]);
    
        dup2(fds[1], 1);
    
        execlp("ls", "ls", NULL);
    
        exit(0);
    } 
    else if (fork() == 0) 
    {
        printf("\nReader on the downstream end of the pipe\n");
    
        close(fds[1]);
    
        while ((count = read(fds[0], buff, 60)) > 0) 
        {
            for (i = 0; i < count; i++) 
            {
                write(1, buff + i, 1);
            
                write(1, " ", 1);
            }
            printf("\n");
        }

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
