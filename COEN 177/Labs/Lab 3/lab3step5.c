// Name: Arman Miri
// Date: 1/19/25
// Title: Lab3 step 5 - Pthreads and inter-process Communication – Pipes
// Description: A program implementing the Producer-Consumer problem using pipes for message communication.

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <sys/wait.h>

#define MAX_MESSAGES 10

int main() 
{
    int fds[2];

    pipe(fds);

    if (fork() == 0) 
    {
        close(fds[0]); 
        
        for (int i = 1; i <= MAX_MESSAGES; i++) 
        {
            char message[50];
        
            snprintf(message, sizeof(message), "Message %d from producer", i);
        
            write(fds[1], message, strlen(message) + 1); 
        
            printf("Producer: Sent -> %s\n", message);
        
            sleep(1); 
        }
        
        close(fds[1]); 
        
        exit(0);
    } 
    else if (fork() == 0) 
    {
        close(fds[1]); 
     
        char buffer[50];
     
        int count;
     
        while ((count = read(fds[0], buffer, sizeof(buffer))) > 0) 
        {
            buffer[count] = '\0'; 
        
            printf("Consumer: Received -> %s\n", buffer);
        }
        
        close(fds[0]); 
        
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
