        .syntax         unified
        .cpu            cortex-m4
        .text

// int32_t Add(int32_t a, int32_t b) ;

        .global         Add
        .thumb_func
        .align
Add:
        //Implementation
        ADD             R0, R0, R1      // adds x and y then saves to x
        BX              LR

// int32_t Less1(int32_t a) ;

        .global         Less1
        .thumb_func
        .align
Less1:
        //Implementation
        SUB             R0, R0, 1       // subtracts 1 from x and saves it to x
        BX              LR

// int32_t Square2x(int32_t x) ;

        .global         Square2x
        .thumb_func
        .align
Square2x:
        //Implementation
        ADD             R0, R0, R0      // Adds x + x (defined as square) and then saves to x
        B               Square

// int32_t Last(int32_t x) ;

        .global         Last
        .thumb_func
        .align
Last:
	//Implementation
        PUSH            {R4, LR}        // Preserves R4 for later
        MOV             R4, R0          // Makes R0 x or a copy of R4
        BL              SquareRoot      // Gets the squareroot of r0
        ADD             R0, R0, R4      // Adds x + squaroot of x and stores in r0
        POP             {R4, LR}        // Return 
        BX              LR              // Return

        .end


