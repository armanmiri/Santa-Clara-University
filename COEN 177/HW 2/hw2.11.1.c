#include <stdio.h>
#include <sys/time.h>
#include <unistd.h>
#include <sys/wait.h>

int main(int argc, char *argv[]) 
{

    int pipefd[2];

    struct timeval start, end;

    pipe(pipefd);

    if (fork() == 0) 
    {
        close(pipefd[0]);
    
        gettimeofday(&start, NULL);
    
        write(pipefd[1], &start, sizeof(start));
    
        close(pipefd[1]);
    
        execvp(argv[1], &argv[1]);
    } 
    else 
    {
        close(pipefd[1]);
    
        read(pipefd[0], &start, sizeof(start));
        
        close(pipefd[0]);
    
        wait(NULL);
    
        gettimeofday(&end, NULL);
    
        printf("Elapsed time: %.6f seconds\n", (end.tv_sec - start.tv_sec) + (end.tv_usec - start.tv_usec) / 1e6);
    }
    
    return 0;
}
