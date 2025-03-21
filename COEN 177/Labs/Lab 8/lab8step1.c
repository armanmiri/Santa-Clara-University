// Name: Arman Miri  
// Date: 2/22/25
// Title: Lab 8 - Memory Management
// Description: Generates a testInput.txt file 


#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
        FILE *fp;
        char buffer [sizeof(int)];
        int i;
        fp = fopen("testInput.txt", "w");
        for (i=0; i < 10; i++){
                sprintf(buffer, "%d\n", rand()%50);
                fputs(buffer, fp);
        }
        fclose(fp);
        return 0;
}