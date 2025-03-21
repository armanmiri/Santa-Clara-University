// Name: Arman Miri
// Date: 1/19/25
// Title: Lab3 step 6 - Pthreads and inter-process Communication – Pipes
// Description: A program demonstrating thread creation and the bug with shared variables in concurrent execution.

#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

void *go(void *);
#define NTHREADS 10
pthread_t threads[NTHREADS];

int main() {
    int i;
    for (i = 0; i < NTHREADS; i++)
        pthread_create(&threads[i], NULL, go, &i);
    for (i = 0; i < NTHREADS; i++) {
        printf("Thread %d returned\n", i);
        pthread_join(threads[i], NULL);
    }
    printf("Main thread done.\n");
    return 0;
}

void *go(void *arg) {
    printf("Hello from thread %ld with iteration %d\n", (long)pthread_self(), *(int *)arg);
    return 0;
}
