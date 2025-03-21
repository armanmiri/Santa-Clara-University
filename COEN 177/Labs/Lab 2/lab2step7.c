//Name: Arman Miri  
//Date: 1/13/25
//Title: Lab2 step 7 - Programming in C and use of Systems Calls
//Description: Implements forking and uses the execlp function to execute the ls command, ensuring the parent process waits for the child to finish

#include <stdio.h>      /* printf, stderr */
#include <sys/types.h>  /* pid_t */
#include <unistd.h>     /* fork */
#include <stdlib.h>     /* atoi */
#include <errno.h>      /* errno */ 
#include <pthread.h>    /* pthreads */
#include <sys/wait.h>   /* wait */


int main() {
    pid_t pid;

    printf("Before forking.\n");

    pid = fork(); 

    if (pid == 0) 
    {
        execlp("/bin/ls", "ls", NULL);
    } 
    else 
    {
        wait(NULL);
        printf("Child Complete\n");
        exit(0);
    }

    return 0;
}
