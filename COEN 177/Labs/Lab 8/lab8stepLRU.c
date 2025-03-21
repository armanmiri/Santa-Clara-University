// Name: Arman Miri  
// Date: 2/22/25
// Title: Lab 8 - Memory Management
// Description: LRU chance algorithim for page replacement


#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <stdbool.h>

typedef struct {//to 
    int pageno;
    int counter;   
} ref_page;


int main(int argc, char *argv[]){
	int CACHE_SIZE = atoi(argv[1]); // Size of Cache passed by user
    ref_page cache[CACHE_SIZE]; // Cache that stores pages
    char pageCache[100]; // Cache that holds the input from test file

    int time = 0; 

    int i;
    int totalFaults = 0; // keeps track of the total page faults
    
    for (i = 0; i < CACHE_SIZE; i++){//initialise cache array  
         cache[i].pageno = -1;
         cache[i].counter = -1;
    }

    while (fgets(pageCache, 100, stdin)) {
        int page_num = atoi(pageCache);
    
        bool foundInCache = false;
    
        for (i = 0; i < CACHE_SIZE; i++) {
    
            if (cache[i].pageno == page_num) {
    
                foundInCache = true;
    
                cache[i].counter = time++;
    
                break;
            }
        }
        if (foundInCache == false) {
    
            totalFaults++;
    
            printf("%d\n",page_num);
    
            int lruIndex = 0;
    
            for (i = 1; i < CACHE_SIZE; i++) {
    
                if (cache[i].counter < cache[lruIndex].counter) {
                    lruIndex = i;
                }
            }
            cache[lruIndex].pageno = page_num;
    
            cache[lruIndex].counter = time++;
        }
    }

    return 0;
}
