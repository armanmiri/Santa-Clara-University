// Name: Arman Miri  
// Date: 3/1/25
// Title: Lab 9 - File Performance Measurement
// Description: Concurrently copies an input file with multiple threads, each writing to a unique output file, to measure parallel I/O performance.




#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>

#define NUM_THREADS 64  

#define BUFFER_SIZE 10000

void *copy_file(void *arg) 
{
    char buffer[BUFFER_SIZE];

    FILE *fp_in, *fp_out;

    char **files = (char **)arg;  

    fp_in = fopen(files[0], "rb");
    
    fp_out = fopen(files[1], "wb");
    
    if (fp_in == NULL || fp_out == NULL) 
    {
        perror("Error opening file");
    
        pthread_exit(NULL);
    }
    
    while (fread(buffer, sizeof(buffer), 1, fp_in)) 
    {
        fwrite(buffer, sizeof(buffer), 1, fp_out);
    }

    fclose(fp_in);
    
    fclose(fp_out);
    
    free(files);
    
    pthread_exit(NULL);
}

int main(int argc, char *argv[]) 
{
    pthread_t threads[NUM_THREADS];

    char *file_in = argv[1]; 

    int num_threads = atoi(argv[3]);  

    char file_names[num_threads][20];
    
    for (int i = 0; i < num_threads; i++) 
    {
        sprintf(file_names[i], "copy%d.out", i + 1);

        char **args = malloc(2 * sizeof(char *));

        args[0] = file_in;

        args[1] = file_names[i];

        pthread_create(&threads[i], NULL, copy_file, args);
    }

    for (int i = 0; i < num_threads; i++) 
    {
        pthread_join(threads[i], NULL);
    }

    printf("File copy completed with %d threads.\n", num_threads);

    return 0;
}

