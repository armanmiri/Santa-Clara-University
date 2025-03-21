// Name: Arman Miri  
// Date: 1/26/25
// Title: Lab 4 - Developing multi-threaded applications 
// Description: Multi-threaded matrix multiplication program implementation.


#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <sys/wait.h>
#include <pthread.h>

#define N 256

#define M 256 

#define L 256

int matrixA[N][M];

int matrixB[M][L];

int matrixC[N][L];

void *multiply(void *arg) 
{
    int i = *(int *)arg;

    free(arg); 

    for (int j = 0; j < L; j++) {
        int temp = 0;
        for (int k = 0; k < M; k++) {
            temp += matrixA[i][k] * matrixB[k][j];
        }
        matrixC[i][j] = temp;
    }
    
    pthread_exit(0);
}

int main() 
{
    pthread_t threads[N];

    srand(time(NULL));

    for (int i = 0; i < N; i++) {
        for (int j = 0; j < M; j++) {
            matrixA[i][j] = rand() % 10;
        }
    }
    for (int i = 0; i < M; i++) {
        for (int j = 0; j < L; j++) {
            matrixB[i][j] = rand() % 10;
        }
    }

    printf("Matrix A:\n");

    for (int i = 0; i < N; i++) 
    {
        for (int j = 0; j < M; j++) 
        {
            printf("%d ", matrixA[i][j]);
        }
        
        printf("\n");
    }

    printf("\nMatrix B:\n");

    for (int i = 0; i < M; i++) 
    {
        for (int j = 0; j < L; j++) 
        {
            printf("%d ", matrixB[i][j]);
        }
        
        printf("\n");
    }

    for (int i = 0; i < N; i++) 
    {
        int *row = malloc(sizeof(int));
    
        *row = i;
    
        pthread_create(&threads[i], NULL, multiply, row);
    }

    for (int i = 0; i < N; i++) 
    {
        pthread_join(threads[i], NULL);
    }

    printf("\n Matrix C (A x B):\n");

    for (int i = 0; i < N; i++)
    {
        for (int j = 0; j < L; j++) 
        {
            printf("%d ", matrixC[i][j]);
        }
        
        printf("\n");
    }

    return 0;
}