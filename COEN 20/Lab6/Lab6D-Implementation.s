        .syntax     unified
        .cpu        cortex-m4
        .text

// void Hanoi(int num, int fm, int to, int aux) ;

        .global     Hanoi
        .thumb_func
        .align

Hanoi:  
	//Your code
        PUSH            {R4, R5, R6, R7, R8, LR}        // Saves R4 and LR to stack
        
        
 	//Your code
        MOV             R4, R0                          // copy num to r4
        MOV             R5, R1                          // copy fm to R5
        MOV             R6, R2                          // copy aux to R6
        MOV             R7, R3                          // copy to too R7 
        CMP             R4, 1                           // check if num is less than or equal to 1
        BLE             Hanoi1                          // branch to hanoi 1 if condition met
        SUB             R0, R4, 1                       // sub 1 from num
        MOV             R1, R5                          // copy fm to R1
        MOV             R3, R6                          // copy aux to r3
        MOV             R2, R7                          // copy to too r2
        BL              Hanoi                           // Yes --> Hanoi(num - 1, fm, aux, to)

Hanoi1: 
	//Your code
        MOV             R0, R5                          // copy fm to r0
        MOV             R1, R6                          // copy aux to r1
        BL              Move1Disk                       // Move1Disk(fm, to)
        CMP             R4, 1                           // compare if num less than or equal to 1
        BLE             Hanoi2                          // Yes --> Hanoi(num - 1, fm, aux, to)
        SUB             R0, R4, 1                       //if num greater than 1 num - 1 
        MOV             R3, R5                          // Copy aux to r5
        MOV             R2, R6                          // Copy to to r6
        MOV             R1, R7                          // Copy fm to r7

 	//Your code
        BL              Hanoi                           // Yes --> Hanoi(num - 1, aux, to, fm)

Hanoi2: 

        pop             {R4-R8, LR}                     // restore registers
        BX      LR                                      // return

        .end


