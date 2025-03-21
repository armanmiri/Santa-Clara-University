//Name: Arman Miri  
//Date: 1/13/25
//Title: Lab2 step 6 - Programming in C and use of Systems Calls
//Description: Uses threads to execute parallel loops with delays, showcasing thread creation, execution, and synchronization with pthread_join

#include <stdio.h>      /* printf, stderr */
#include <sys/types.h>  /* pid_t */
#include <unistd.h>     /* fork */
#include <stdlib.h>     /* atoi */
#include <errno.h>      /* errno */ 
#include <pthread.h>    /* pthreads */

void *thread(void *arg) 
{
    int n = *(int *)arg; 
    for (int i = 0; i < 100; i++) 
    {
        printf("Thread %ld: %d\n", (long)pthread_self(), i); // added (long) to remove warning in compilation
    
        usleep(n);
    }
    return NULL;
}

int main(int argc, char *argv[]) {
    int n = atoi(argv[1]); 
    pthread_t thread1, thread2;

    printf("\nBefore creating threads.\n");

    pthread_create(&thread1, NULL, thread, &n);
    pthread_create(&thread2, NULL, thread, &n);

    pthread_join(thread1, NULL);
    pthread_join(thread2, NULL);

    printf("Threads complete.\n");
    return 0;
}
