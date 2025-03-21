// Name: Arman Miri  
// Date: 1/26/25
// Title: Lab 4 - Developing multi-threaded applications 
// Description: Modified program to observe thread execution without joins.


#include <stdio.h>
#include <unistd.h>
#include <pthread.h>

#define NTHREADS 20

void *go(void *);
pthread_t threads[NTHREADS];

int main() {
    static int i;
    for (i = 0; i < NTHREADS; i++)  
        pthread_create(&threads[i], NULL, go, &i);
    
    printf("Main thread done.\n");
}
void *go(void *arg) {
    printf("Hello from thread %d with thread ID %d \n", *(int *)arg, (int)pthread_self());
    return (NULL);
}
