.syntax     unified
.cpu        cortex-m4
.text

// Function: uint32_t Time2Msecs(uint32_t hour, uint32_t mins, uint32_t secs);
// Converts time given in hours, minutes, and seconds to milliseconds.

        .global     Time2Msecs
        .thumb_func

        .align 
        
Time2Msecs:

        // R0 = hour
        // R1 = mins
        // R2 = secs

	// Implementation
        LSL     R3, R0, 6          // Multiply hour by 64 (hour * 64)
        SUB     R3, R3, R0, LSL 2  // Subtract (hour << 2) from the result
        ADD     R3, R3, R1         // Add minutes to the result
        LSL     R0, R3, 6          // Multiply the intermediate result by 64 ((hour * 64 + minutes) * 64)
        SUB     R0, R0, R3, LSL 2  // Subtract ((hour * 64 + minutes) << 2) from the result
        ADD     R0, R0, R2         // Add seconds to the final result
        LSL     R1, R0, 10         // Multiply the final result by 1024 (result * 1024)
        SUB     R1, R1, R0, LSL 5  // Subtract (result << 5) from the multiplied result
        ADD     R0, R1, R0, LSL 3  // Add the multiplied result to (result << 3)

        BX      LR                  // Return

// Function: void Msecs2Time(uint32_t msec, uint32_t *hour, uint32_t *mins, uint32_t *secs);
// Converts milliseconds to time in hours, minutes, and seconds.

        .global     Msecs2Time
        .thumb_func

    .align
Msecs2Time:

        // R0 = msec
        // R1 = ptr to hour
        // R2 = ptr to mins
        // R3 = ptr to secs

	// Implementation
        PUSH    {R4, LR}            // Preserve R4 and LR

        LDR     R12,=274877907      // Load constant for division by 1000 (2^38 / 1000)
        UMULL   R12, R0, R12, R0    // Multiply msec by 2^38 / 1000 and store the result in R0 and R12
        LSRS    R0, R0, 6           // Divide the result by 64 (result >> 6)

        LDR     R12,=2443359173     // Load constant for division by 3600000 (2^32 / 3600000)
        UMULL   R12, R4, R12, R0    // Multiply the result by 2^32 / 3600000 and store the result in R0 and R12
        LSRS    R4, R4, 11          // Divide the result by 2048 (result >> 11)
        STR     R4, [R1]            // Store the hour value in the memory location pointed by R1

        LDR     R12, =3600          // Load constant for division by 3600
        MLS     R0, R12, R4, R0     // Multiply 3600 by the hour value and subtract the product from the original milliseconds
                                    // Store the result in R0 (remaining milliseconds)

        LDR     R12,=2290649225     // Load constant for division by 60000 (2^32 / 60000)
        UMULL   R12, R4, R12, R0    // Multiply the remaining milliseconds by 2^32 / 60000 and store the result in R0 and R12
        LSRS    R4, R4, 5           // Divide the result by 32 (result >> 5)
        STR     R4, [R2]            // Store the minute value in the memory location pointed by R2

        LDR     R12, =60            // Load constant for division by 60
        MLS     R0, R12, R4, R0     // Multiply 60 by the remaining milliseconds and subtract the product from the remaining milliseconds
                                    // Store the result in R0 (remaining seconds)
        STR     R0, [R3]            // Store the remaining seconds in the memory location pointed by R3

        POP     {R4, LR}            // Restore R4 and LR
	BX	    LR              // Return

        .end
