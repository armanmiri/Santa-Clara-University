        .syntax     unified
        .cpu        cortex-m4
        .text

// ----------------------------------------------------------
// unsigned HalfWordAccess(int16_t *src) ;
// ----------------------------------------------------------

        .global     HalfWordAccess
        .thumb_func
        .align
HalfWordAccess:
	//Implementation
        .rept           100
        LDRH            R1,[R0]
        .endr
        BX              LR

// half word accces if the adrress ends in 00 or 10 it takes 101 cycles isntead of 200 cycles becase the data is half word aligned

// ----------------------------------------------------------
// unsigned FullWordAccess(int32_t *src) ;
// ----------------------------------------------------------

        .global     FullWordAccess
        .thumb_func
        .align
FullWordAccess:
	//Implementation
        .rept           100
        LDR             R1,[R0]
        .endr
        BX              LR

// if it ends in 00 then it is full word aligned, if it is any other response then the word needs more than one cycle to write the full word

// ----------------------------------------------------------
// unsigned NoAddressDependency(uint32_t *src) ;
// ----------------------------------------------------------

        .global     NoAddressDependency
        .thumb_func
        .align
NoAddressDependency:
	//Implementation
        .rept           100
        LDR             R1,[R0]
        LDR             R2,[R0]
        .endr
        BX              LR

// takes 200 cycles beacsue it directly writes to the diffrernt registers

// ----------------------------------------------------------
// unsigned AddressDependency(uint32_t *src) ;
// ----------------------------------------------------------

        .global     AddressDependency
        .thumb_func
        .align
AddressDependency:
	//Implementation
        .rept           100
        LDR             R1,[R0]
        LDR             R0,[R1]
        .endr
        BX              LR

// takes 400 cycles, needs to read write and transfer before it can get to the same registers

// ----------------------------------------------------------
// unsigned NoDataDependency(float f1) ;
// ----------------------------------------------------------

        .global     NoDataDependency
        .thumb_func
        .align
NoDataDependency:
	//Implementation
        .rept           100
        VADD.F32        S1,S0,S0
        VADD.F32        S2,S0,S0
        .endr
        VMOV            S1,S0
        BX              LR

// same as address dependancy when not dependant takes half as many cycles 200 in this case as it has diffrernt registers

// ----------------------------------------------------------
// unsigned DataDependency(float f1) ;
// ----------------------------------------------------------

        .global     DataDependency
        .thumb_func
        .align
DataDependency:
	//Implementation
        .rept           100
        VADD.F32        S1,S0,S0
        VADD.F32        S0,S1,S1
        .endr
        VMOV            S1,S0
        BX              LR

// same as address dependancy when dependand it is passing writing and manipualting so multiple steps takes 400 cycles uses the same registers

// ----------------------------------------------------------
// void VDIVOverlap(float dividend, float divisor) ;
// ----------------------------------------------------------

        .global     VDIVOverlap
        .thumb_func
        .align
VDIVOverlap:
	//Implementation
        VDIV.F32        S2,S1,S0
        .rept           1
        NOP
        .endr
        VMOV            S3,S2
        BX              LR

        .end

// the number of cycles it takes the floating point processer to return the result
// or the number of cycles needed to free the floating pointerss