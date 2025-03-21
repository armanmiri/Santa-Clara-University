// Name: Arman Miri  
// Date: 3/1/25
// Title: Lab 9 - File Performance Measurement
// Description: Reads a file using a user-specified buffer size to measure sequential I/O performance.


#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) 
{
    if (argc < 3) 
    {
        fprintf(stderr, "Usage: %s <filename> <buffersize>\n", argv[0]);

        return 1;
    }

    int bufsize = atoi(argv[2]);

    if (bufsize <= 0) 
    {
        fprintf(stderr, "Invalid buffer size: %s\n", argv[2]);
    
        return 1;
    }

    char *buffer = malloc(bufsize);

    if (!buffer) 
    {
        perror("malloc");
    
        return 1;
    }

    FILE *fp = fopen(argv[1], "rb");

    if (!fp) {
        perror("fopen");

        free(buffer);

        return 1;
    }

    while (fread(buffer, 1, bufsize, fp) > 0) 
    {
        
    }

    fclose(fp);
    
    free(buffer);
    
    return 0;
}

