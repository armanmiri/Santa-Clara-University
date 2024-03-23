#include <stdint.h>

uint32_t Bits2Unsigned(int8_t bits[8])
    {
    // To be implemented by student
    // Input:   bits[0] = Least significant bit
    //          bits[7] = Most significant bit
    // Output:  0 <= return value < 255
    
    uint32_t value ;

    //Implementation

    value = 0;

    // lopps through the bits form most to least significant
    for(int i = 7; i >= 0; i--)
    {
        // shfits the value to the left and adds in the new bit uses polynomial expansion
        value = 2 * value + bits[i];
    }

    // returns final unsigned value
    return value ;
    
    }

int32_t Bits2Signed(int8_t bits[8])
    {
    // To be implemented by student
    // Input:   bits[0] = Least significant bit
    //          bits[7] = Most significant bit
    // Output: -128 <= return value <= +127
    int32_t value ;
    
    //Implementation

    value = 0;

    // Check if the most significant bit is 1 thus a negative number
    if (bits[7] == 1)
    {
        // get the value
        value = Bits2Unsigned(bits);

        // convert the value 
        value = (value - 256);
    }
    else
    {
        // If most significant bit is 0 it as a positive number
        value = Bits2Unsigned(bits);
    }

    // returns the final signed integer value
    return value ;
    }

void Increment(int8_t bits[8])
    {
    // To be implemented by student
    // Adds 1 to the number represented by bits
    // Where:   bits[0] = Least significant bit
    //          bits[7] = Most significant bit
    int32_t bit, carry, sum ;
    carry = 1 ;

    //Implementation

    bit = 0;

    // Loop through the bits from least significant to most significant
    for(int i = 0; i < 8; i++)
    {
        // Calculate sum of the current bit, carry, and existing bit value
        sum = bits[i] + carry;
        
        // Determine new bit value and update the carry for the next iteration
        bits[i] = sum % 2;
        
        carry = sum / 2;

        // Breaks loop if there is no carry left
        if (carry == 0)
        {
            break;
        }
    }
    }

void Unsigned2Bits(uint32_t n, int8_t bits[8])
    {
    // To be implemented by student
    // Input:   0 <= n <= 255
    // Output:  Converts n to an array of bits
    // Where:   bits[0] = Least significant bit
    //          bits[7] = Most significant bit
    int32_t bit ;

    //Implementation

    bit = 0;

    // Loop through the bits from least significant to most significant
    for(int i = 0; i < 8; i++)
    {
        // Extract rightmost bit of the number and store it in array
        bits[i] = n % 2;
        
        // Right shift number to get the next bit
        n = n / 2;
    }

    }

