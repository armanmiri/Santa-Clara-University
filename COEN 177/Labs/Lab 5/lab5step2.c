// Name: Arman Miri  
// Date: 2/2/25
// Title: Lab 5 - Synchronization using semaphores, locks, and condition variables
// Description: questions and results for lab

// Thread Synchronization
// To compile this code:
// If using the SCU Linux lab first add #include<fcntl.h>
// Then you're ready to compile.
// To compile just add -lpthread to your gcc command like:
// gcc lab5step2.c -lpthread
// gcc lab5step2.c -o test -lpthread

// i had macOS issues with the code so i had to make some changes to make it work on macOS so there are little changes

#include <stdio.h>
#include <unistd.h>
#include <pthread.h> 
#include <semaphore.h> 
#include <stdint.h>  // macOS fix for intptr_t usage
#include <fcntl.h>   // macOS fix for named semaphores
#include <sys/stat.h> // macOS fix for semaphore unlinking

#define NTHREADS 10
pthread_t threads[NTHREADS];
pthread_mutex_t lock; 

void* go(void* arg) { 
  pthread_mutex_lock(&lock);
  printf("Thread %ld Entered Critical Section..\n", (intptr_t)arg); // critical selection and macOS fix for casting
  sleep(1); 
  pthread_mutex_unlock(&lock);
  return NULL;
} 

int main() { 
  pthread_mutex_init(&lock, NULL);
  static int i;
  for (i = 0; i < NTHREADS; i++)  
    pthread_create(&threads[i], NULL, go, (void *)(intptr_t)i); // macOS fix for casting
  for (i = 0; i < NTHREADS; i++) {
    pthread_join(threads[i], NULL);
    printf("\t\t\tThread %d returned \n", i);
  }
  printf("Main thread done.\n");
  pthread_mutex_destroy(&lock); // macOS fix for mutex cleanup
  return 0; 
}
