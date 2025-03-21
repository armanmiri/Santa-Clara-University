# Name: Arman Miri  
# Date: 3/1/25
# Title: Lab 9 - File Performance Measurement
# Description: Runs Step4 with multiple files and buffer sizes, timing each copy and removing copy.out afterwards.


for file in file1.bin file2.bin file3.bin file4.bin
do
    for buffer in 100 1000 10000 100000
    do
    echo "Step4 $file $buffer"
    time ./Step4 $file $buffer
    rm -f copy.out
    echo " "
    done
done
