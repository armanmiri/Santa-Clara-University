// Name: Arman Miri
// Date: 1/19/25
// Title: Lab3 step 7 - Pthreads and inter-process Communication – Pipes
// Description: A program fixing the race condition from step 6 by avoiding shared variables and ensuring correct thread iteration.

#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

void *go(void *arg);
#define NTHREADS 10
pthread_t threads[NTHREADS];
int args[NTHREADS]; 

int main() 
{

    int i;

    for (i = 0; i < NTHREADS; i++) 
    {
        args[i] = i; 
    
        pthread_create(&threads[i], NULL, go, &args[i]);
    }
    for (i = 0; i < NTHREADS; i++) 
    {
        printf("Thread %d returned\n", i);
    
        pthread_join(threads[i], NULL);
    }
    
    printf("Main thread done.\n");
    
    return 0;
}

void *go(void *arg) 
{
    printf("Hello from thread %ld with iteration %d\n", (long)pthread_self(), *(int *)arg);

    return 0;
}
