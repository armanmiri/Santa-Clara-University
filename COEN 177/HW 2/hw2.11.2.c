#include <stdio.h>
#include <sys/time.h>
#include <unistd.h>
#include <sys/wait.h>
#include <sys/shm.h>

int main(int argc, char *argv[]) 
{
    int shmid = shmget(IPC_PRIVATE, sizeof(struct timeval), IPC_CREAT | 0666);

    struct timeval *start = (struct timeval *)shmat(shmid, NULL, 0);

    if (fork() == 0) 
    {
        gettimeofday(start, NULL);
       
        execvp(argv[1], &argv[1]);
    } 
    else 
    {
        wait(NULL);
        
        struct timeval end;
        
        gettimeofday(&end, NULL);
        
        printf("Elapsed time: %.6f seconds\n", (double)(end.tv_sec - start->tv_sec) + (double)(end.tv_usec - start->tv_usec) / 1000000);
        
        shmdt(start);
        
        shmctl(shmid, IPC_RMID, NULL);
    }
    
    return 0;
}
