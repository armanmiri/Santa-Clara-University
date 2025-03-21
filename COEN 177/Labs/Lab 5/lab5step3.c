// Name: Arman Miri  
// Date: 2/2/25
// Title: Lab 5 - Synchronization using semaphores, locks, and condition variables
// Description: Implemented the Producer-Consumer problem using semaphores to synchronize access to the shared buffer.


#include <stdio.h>
#include <pthread.h>
#include <semaphore.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/stat.h>

#define BUFFER_SIZE 5
#define PRODUCER_ITERATIONS 10
#define CONSUMER_ITERATIONS 10

int buffer[BUFFER_SIZE];
int count = 0;

sem_t *empty, *full, *lock;

void* producer(void* arg) 
{
    for(int i = 0; i < PRODUCER_ITERATIONS; i++) 
    {
        int item = i;
        
        printf("Produced: %d\n", item); 
        
        sem_wait(empty); 

        sem_wait(lock);  
        
        buffer[count++] = item; 
        
        sem_post(lock); 
        
        sem_post(full); 
        
        sleep(1);
    }
    return NULL;
}

void* consumer(void* arg) 
{
    for(int i = 0; i < CONSUMER_ITERATIONS; i++) 
    {
        sem_wait(full); 
        
        sem_wait(lock); 
    
        int item = buffer[--count]; 
    
        sem_post(lock); 
        
        sem_post(empty); 
    
        printf("Consumed: %d\n", item); 
    
        sleep(1);
    }
    return NULL;
}

int main() 
{
    pthread_t prod, cons;

    sem_unlink("/empty");
    
    sem_unlink("/full");
    
    sem_unlink("/lock");

    empty = sem_open("/empty", O_CREAT, 0, BUFFER_SIZE); 

    full = sem_open("/full", O_CREAT, 0, 0);

    lock = sem_open("/lock", O_CREAT, 0, 1);

    pthread_create(&prod, NULL, producer, NULL);
    
    pthread_create(&cons, NULL, consumer, NULL);

    pthread_join(prod, NULL);

    pthread_join(cons, NULL);

    sem_close(empty);

    sem_close(full);

    sem_close(lock);

    sem_unlink("/empty");

    sem_unlink("/full");

    sem_unlink("/lock");

    return 0;
}
