# Name: Arman Miri  
# Date: 3/1/25
# Title: Lab 9 - File Performance Measurement
# Description: A shell script that measures and displays how long each file takes to be read by the program.


for file in file1.bin file2.bin file3.bin file4.bin
do
    echo "Step2 reading $file"
    time ./Step2 $file
    echo " "
done
