// Name: Arman Miri  
// Date: 2/22/25
// Title: Lab 8 - Memory Management
// Description: 2nd chance algorithim for page replacement


#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <stdbool.h>

typedef struct {//to 
    int pageno;
    int ref;   
} ref_page;


int main(int argc, char *argv[]){
	int CACHE_SIZE = atoi(argv[1]); // Size of Cache passed by user
    ref_page cache[CACHE_SIZE]; // Cache that stores pages
    char pageCache[100]; // Cache that holds the input from test file

    int clock_hand = 0; 

    int i;
    int totalFaults = 0; // keeps track of the total page faults
    
    for (i = 0; i < CACHE_SIZE; i++){//initialise cache array  
         cache[i].pageno = -1;
    }

    while (fgets(pageCache, 100, stdin)) {
        int page_num = atoi(pageCache);
        
        bool foundInCache = false;
        
        for (i = 0; i < CACHE_SIZE; i++) {
        
            if (cache[i].pageno == page_num) {
        
                foundInCache = true;
        
                cache[i].ref = 1;
        
                break;
            }
        }
        if (!foundInCache) {
        
            totalFaults++;
        
            printf("%d\n", page_num);
        
            bool emptyFound = false;
        
            for (i = 0; i < CACHE_SIZE; i++) {
        
                if (cache[i].pageno == -1) {
        
                    cache[i].pageno = page_num;
        
                    cache[i].ref = 1;
        
                    emptyFound = true;
        
                    break;
                }
            }
            if (!emptyFound) {
        
                while (true) {
        
                    if (cache[clock_hand].ref == 0) {
        
                        cache[clock_hand].pageno = page_num;
        
                        cache[clock_hand].ref = 0;
        
                        clock_hand = (clock_hand + 1) % CACHE_SIZE;
        
                        break;
        
                    } else {
        
                        cache[clock_hand].ref = 0;
                        clock_hand = (clock_hand + 1) % CACHE_SIZE;
        
                    }
                }
            }
        }
    }
    
    return 0;
}
