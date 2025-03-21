// Name: Arman Miri  
// Date: 1/13/25
// Title: Lab2 step 5 - Programming in C and use of Systems Calls
// Description: Demonstrates forking, executing a system call (ls), and threading in a single program​

#include <stdio.h>      
#include <sys/types.h>  
#include <unistd.h>     
#include <stdlib.h>     
#include <errno.h>      
#include <pthread.h>    

int main() {
    pid_t pid1, pid2, pid3, pid4, pid5, pid6;

    pid1 = fork();
    if (pid1 == 0) 
    {

        pid3 = fork();
        if (pid3 == 0) 
        {
        }
        else 
        {
            pid4 = fork();
            if (pid4 == 0) 
            {
            }
        }
    }
    else {
        pid2 = fork();
        if (pid2 == 0) 
        {

            pid5 = fork();
            if (pid5 == 0) 
            {
            }
            else 
            {
                pid6 = fork();
                if (pid6 == 0) 
                {
                }
            }
        }
    }

    printf("PID: %d, Parent PID: %d, Wait1: %d, Wait2: %d\n", getpid(), getppid(), wait(0), wait(0));

    return 0;
}
 
 
