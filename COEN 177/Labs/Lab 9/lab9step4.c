// Name: Arman Miri  
// Date: 3/1/25
// Title: Lab 9 - File Performance Measurement
// Description: Copies each file to copy.out using a specified buffer size, measuring sequential read+write performance.


#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) 
{
    if (argc < 3) 
    {
        fprintf(stderr, "Usage: %s <input_file> <buffer_size>\n", argv[0]);
    
        return 1;
    }

    int bufferSize = atoi(argv[2]);

    if (bufferSize <= 0) 
    {
        fprintf(stderr, "Invalid buffer size: %s\n", argv[2]);
    
        return 1;
    }

    FILE *fin = fopen(argv[1], "rb");

    if (!fin) 
    {
        perror("fopen input");
        return 1;
    }

    FILE *fout = fopen("copy.out", "wb");

    if (!fout) 
    {
        perror("fopen output");
    
        fclose(fin);
    
        return 1;
    }

    char *buffer = (char *)malloc(bufferSize);

    if (!buffer) 
    {
        perror("malloc");
    
        fclose(fin);
    
        fclose(fout);
    
        return 1;
    }

    size_t bytesRead;

    while ((bytesRead = fread(buffer, 1, bufferSize, fin)) > 0) 
    {
        fwrite(buffer, 1, bytesRead, fout);
    }

    free(buffer);

    fclose(fin);

    fclose(fout);

    return 0;
}
