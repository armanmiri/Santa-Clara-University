# Name: Arman Miri  
# Date: 3/1/25
# Title: Lab 9 - File Performance Measurement
# Description: Runs Step5 for all file, buffer size, and thread count combinations, measuring and reporting total copy times.


for file in file1.bin file2.bin file3.bin file4.bin; 
do
    for buffer in 100 1000 10000 100000; 
    do
        for thread in 2 8 32 64; 
        do
            echo "Step5 $file $buffer $thread"
            time ./step5 $file $buffer $thread
            rm -f copy*.out
            echo " "        
        done
    done
done
