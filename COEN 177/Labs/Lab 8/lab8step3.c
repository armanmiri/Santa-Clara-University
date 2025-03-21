// Name: Arman Miri  
// Date: 2/22/25
// Title: Lab 8 - Memory Management
// Description: updated skeleton code for lab 8 implemnations

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
    
    for (i = 0; i < CACHE_SIZE; i++){//initialise cache array  
         cache[i].pageno = -1;
    }

    while (fgets(pageCache, 100, stdin)){
    	int page_num = atoi(pageCache); // Stores number read from file as an int

    	/*

		
		Page Replacement Implementation Goes Here 


    	*/

        printf("%d\n", page_num);
    }

    printf("%d Total Page Faults", totalFaults);
    return 0;



}
