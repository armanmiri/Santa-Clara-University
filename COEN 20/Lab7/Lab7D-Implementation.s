        .syntax     unified
        .cpu        cortex-m4
        .text

// void PutNibble(void *nibbles, uint32_t index, uint32_t nibble) ;

        .global     PutNibble
        .thumb_func
        .align

PutNibble:
	//Implementation
        LSR         R12, R1, 1          // calc byte offset from index to index * 2
        LDRB        R3, [R0, R12]       // load byte that has nibble at calculated index
        AND         R1, R1, 1           // check if the nibble is in odd or even position
        CMP         R1, 1               // compare nibble with 1 position
        BNE         Else                // branch to else if its not equal thus even
        AND         R3, R3, 0xf         // extract the lowe nibble of r2
        AND         R2, R2, 0b00001111  // clearing of the bits
        LSL         R2, R2, 4           // shift the lower nibble of r2 by 4
        ORR         R3, R3, R2          // lower swap the of r3 with r2
        B           End                 // branch to end 
Else:   
        AND         R3,R3,0b11110000    // clear lower nibble of r3 keep higher bits
        AND         R2,R2,0b00001111    // extract lower nibble r2 clear higher bits
        ORR         R3,R3,R2            // or higher nibble of r3 with lower nibble of 42
End:
        STRB        R3,[R0,R12]         // store the modified byte back to the memory at the calculated index

        BX          LR                  // return 

// uint32_t GetNibble(void *nibbles, uint32_t index) ;

        .global     GetNibble
        .thumb_func
        .align

GetNibble:
	//Implementation
        LSR             R12, R1, 1      // calc byte offset from index to index * 2
        LDRB            R0, [R0,R12]    // load byte that has nibble at calculated index
        AND             R3, R1, 1       // check if the nibble is in odd or even position
        CMP             R3, 1           // compare nibble with 1 
        BNE             Else2           // branch to else 2 if not equal
        LSR             R0,R0,4         // shift r0 right by 4 positions to extract higher nibble
        B               End2            // branch to end 2
Else2:  
        AND             R0,R0,0b00001111    // extract lower nibble of r0
End2:   
        BX          LR                  // return 

        .end
