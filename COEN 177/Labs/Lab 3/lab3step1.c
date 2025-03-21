// Name: Arman Miri  
// Date: 1/19/25
// Title: Lab3 step 1 - Pthreads and inter-process Communication – Pipes
// Description: A program demonstrating inter-process communication using pipes to connect the "ls" and "more" commands.


#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/wait.h>

//main
int main() {

    int fds[2];
    pipe(fds);

    /*child 1 duplicates downstream into stdin */
    if (fork() == 0) {
        dup2(fds[0], 0);
        close(fds[1]);
        execlp("more", "more", 0); 
    }

    /*child 2 duplicates upstream into stdout */
    else if (fork() == 0) {
        dup2(fds[1], 1);
        close(fds[0]);
        execlp("ls", "ls", 0); 
    }

    else {  /*parent closes both ends and waits for children*/
        close(fds[0]);
        close(fds[1]);
        wait(0);
        wait(0); 
    }

    return 0;
}
