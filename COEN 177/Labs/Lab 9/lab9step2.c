// Name: Arman Miri  
// Date: 3/1/25
// Title: Lab 9 - File Performance Measurement
// Description: a c program reads each binary file (from Step 1) using a fixed 10,000-byte buffer.


#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) 
{
    if (argc < 2) 
    {
        fprintf(stderr, "Usage: %s <input_file>\n", argv[0]);
    
        return -1;
    }

    char buffer[10000];
    
    FILE *fp = fopen(argv[1], "rb");

    if (fp == NULL) 
    {
        perror("Error opening input file");
    
        return -1;
    }

    size_t bytes;
    
    while ((bytes = fread(buffer, 1, sizeof(buffer), fp)) > 0) 
    {
    }

    fclose(fp);
    
    printf("File %s read successfully.\n", argv[1]);
    
    return 0;
}