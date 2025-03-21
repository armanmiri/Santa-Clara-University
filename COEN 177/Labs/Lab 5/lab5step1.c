// Name: Arman Miri  
// Date: 2/2/25
// Title: Lab 5 - Synchronization using semaphores, locks, and condition variables
// Description: questions and results for lab

// Thread Synchronization
// To compile this code:
// If using the SCU Linux lab first add #include<fcntl.h>
// Then you're ready to compile.
// To compile just add -lpthread to your gcc command like:
// gcc lab5step1.c -lpthread
// gcc lab5step1.c -o test -lpthread

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
sem_t *mutex; 

void* go(void* arg) { 
  sem_wait(mutex); // entry selection
  printf("Thread %ld Entered Critical Section..\n", (intptr_t)arg); // critical selection and macOS fix for casting
  sleep(1); 
  sem_post(mutex); // exit selection
  return NULL;
} 

int main() { 
  sem_unlink("mutex"); // macOS fix 
  mutex = sem_open("mutex", O_CREAT, 0644, 1);
  static int i;
  for (i = 0; i < NTHREADS; i++)  
    pthread_create(&threads[i], NULL, go, (void *)(intptr_t)i); // macOS fix for casting
  for (i = 0; i < NTHREADS; i++) {
    pthread_join(threads[i], NULL);
    printf("\t\t\tThread %d returned \n", i);
  }
  printf("Main thread done.\n");
  sem_close(mutex); 
  sem_unlink("mutex"); // macOS fix for cleanup
  return 0; 
}
