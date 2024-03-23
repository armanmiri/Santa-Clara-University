.syntax         unified
.cpu            cortex-m4
.text

// -----------------------------------------------------------------------------------------
// FLOAT2 QuickTwoSum(float a32, float b32) ;
// -----------------------------------------------------------------------------------------
            .global         QuickTwoSum
            .thumb_func
            .align
QuickTwoSum:                                    // Input: S0 = a32, S1 = b32
	    // Implementation
            VADD.F32    S2, S0, S1              // s32 = a32 + b32
            VSUB.F32    S3, S2, S0              // e32 = b32 - (s32 - a32)
            VMOV        S0, S2                  // Copy s32 to S0
            VSUB.F32    S1, S1, S3              // Adjust b32 by e32

            BX              LR                  // Return (FLOAT2) {s32, e32}

// -----------------------------------------------------------------------------------------
// FLOAT2 TwoSum(float a32, float b32) ;
// -----------------------------------------------------------------------------------------
            .global         TwoSum
            .thumb_func
            .align
TwoSum:                                         // Input: S0 = a32, S1 = b32
 	    // Implementation
            VMOV        S2, S0                  // Copy a32 to S2
            VADD.F32    S0, S0, S1              // s32 = a32 + b32
            VSUB.F32    S3, S0, S2              // v32 = s32 - a32
            VSUB.F32    S4, S0, S3              // v32 = s32 - a32
            VSUB.F32    S1, S1, S3              // Adjust b32 by (a32 - (s32 - v32))
            VSUB.F32    S2, S2, S4              // v32 = s32 - a32
            VADD.F32    S1, S2, S1              // Adjust e32 by (a32 - (s32 - v32)) + (b32 - v32)

            BX              LR                  // Return (FLOAT2) {s32, e32}

// -----------------------------------------------------------------------------------------
// FLOAT2 Split(float a32) ;
// -----------------------------------------------------------------------------------------
            .global         Split
            .thumb_func
            .align
Split:                                      // Input: S0 = a32
 	    // Implementation
            LDR         R0, =mpier
            VLDR        S2, [R0]
            
            VMUL.F32    S2, S0, S2            // Calculate ahi32 = mpier * a32
            VMOV        S1, S0
            VSUB.F32    S0, S2, S0            // Calculate alo32 = ahi32 - a32
            VSUB.F32    S0, S2, S0            // Calculate alo32 = ahi32 - a32
            VSUB.F32    S1, S1, S0            // Calculate alo32 = ahi32 - a32
            
            BX              LR              // Return (FLOAT2) {alo32, ahi32}

mpier:      .float      4097.0

             .end
