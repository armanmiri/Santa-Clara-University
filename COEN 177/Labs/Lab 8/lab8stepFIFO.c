// Name: Arman Miri  
// Date: 2/22/25
// Title: Lab 8 - Memory Management
// Description: FIFO algorithim for page replacement 


#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

typedef struct {//to 
    int pageno;
} ref_page;

int main(int argc, char *argv[]){
    int CACHE_SIZE = atoi(argv[1]); // Size of Cache passed by user
    ref_page cache[CACHE_SIZE]; // Cache that stores pages
    char pageCache[100]; // Cache that holds the input from test file

    int i;
    int totalFaults = 0; // keeps track of the total page faults
    int placeInArray = 0; // index for FIFO replacement
    
    for (i = 0; i < CACHE_SIZE; i++){//initialise cache array  
         cache[i].pageno = -1;
    }

    while (fgets(pageCache, 100, stdin)){
    
        int page_num = atoi(pageCache); // Stores number read from file as an int
        {
    
            int foundInCache = 0;
    
            for (i = 0; i < CACHE_SIZE; i++){
    
                if (cache[i].pageno == page_num){
    
                    foundInCache = 1;
    
                    break; 
                }
            }
            if (foundInCache == 0){
    
                printf("%d\n", page_num); 
    
                cache[placeInArray].pageno = page_num;
    
                totalFaults++;
    
                placeInArray++;
    
                if (placeInArray == CACHE_SIZE){
                    placeInArray = 0;
                }
            }
        }
    }
    
    return 0;
}
