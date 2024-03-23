        .syntax     unified
        .cpu        cortex-m4
        .text

// uint64_t TireDiam(uint32_t W, uint32_t A, uint32_t R) ;

        .global     TireDiam
        .thumb_func

        .align
TireDiam:       // R0 = W, R1 = A, R2 = R
	//Implementation
        MUL     R0, R0, R1      // multiply a * w and save to R0
        LDR     R1, =1270       // setting up r1 wiht 1270 to load for divison
        UDIV    R3, R0, R1      // divides a * w by 1270 saves to R3
        MLS     R0, R1, R3, R0  // gets the reminder of r0 - r1*r3 to solve and stores in r1
        Add     R1, R2, R3      // adds the reminder to w*a / 1270 and saves to r0

        BX          LR          // returns result

// uint64_t TireCirc(uint32_t W, uint32_t A, uint32_t R) ;

        .global     TireCirc
        .thumb_func

        .align
TireCirc:       // R0 = W, R1 = A, R2 = R
	//Implementation
        Push    {LR}            // stores content
        BL      TireDiam        // loads the tirediam function
        LDR     R2, =4987290    // loads the value 4987290 into r2 for calc
        LDR     R3, =3927       // loads the value 3927 into r3 for calc
        MUL     R2, R1, R2      // multitples d63-32*4987290 part of top of function needed
        MUL     R3, R0, R3      // multitples d31-0*3927 part of top of function needed
        Add     R2, R2, R3      // Adds the two parts just multiploed for the top of the function and stores
        LDR     R3, =1587500    // Loads value 1587500 to R3
        UDIV    R1, R2, R3      // solves the quotient
        MLS     R0, R1, R3, R2  // solves the remainder for the function
        POP     {PC}            // retores content 

        BX          LR // returns result

        .end

