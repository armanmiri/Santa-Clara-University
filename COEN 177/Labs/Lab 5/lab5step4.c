// Name: Arman Miri  
// Date: 2/2/25
// Title: Lab 5 - Synchronization using semaphores, locks, and condition variables
// Description: Implemented the Producer-Consumer problem using mutex locks and condition variables for synchronization.s


#include <stdio.h>
#include <pthread.h>
#include <unistd.h>

#define BUFFER_SIZE 5
#define PRODUCER_ITERATIONS 10
#define CONSUMER_ITERATIONS 10

int buffer[BUFFER_SIZE];

int count = 0;

pthread_mutex_t lock;

pthread_cond_t full, empty;

void* producer(void* arg) 
{
    for(int i = 0; i < PRODUCER_ITERATIONS; i++) 
    {
        int item = i;
        
        printf("Produced: %d\n", item);
        
        pthread_mutex_lock(&lock);
        
        while (count == BUFFER_SIZE)
            pthread_cond_wait(&empty, &lock);
        
        buffer[count++] = item;
        
        pthread_cond_signal(&full);
        
        pthread_mutex_unlock(&lock);
        
        sleep(1);
    }
    return NULL;
}

void* consumer(void* arg) 
{
    for(int i = 0; i < CONSUMER_ITERATIONS; i++) 
    {
        pthread_mutex_lock(&lock);
        
        while (count == 0)
            pthread_cond_wait(&full, &lock);
    
        int item = buffer[--count];
    
        pthread_cond_signal(&empty);
    
        pthread_mutex_unlock(&lock);
    
        printf("Consumed: %d\n", item);
    
        sleep(1);
    }
    return NULL;
}

int main() 
{
    pthread_t prod, cons;

    pthread_mutex_init(&lock, NULL);
    
    pthread_cond_init(&full, NULL);
    
    pthread_cond_init(&empty, NULL);
    
    pthread_create(&prod, NULL, producer, NULL);
    
    pthread_create(&cons, NULL, consumer, NULL);

    pthread_join(prod, NULL);
    
    pthread_join(cons, NULL);

    pthread_mutex_destroy(&lock);
    
    pthread_cond_destroy(&full);
    
    pthread_cond_destroy(&empty);

    return 0;
}
