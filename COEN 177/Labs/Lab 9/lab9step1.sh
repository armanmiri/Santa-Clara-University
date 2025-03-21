# Name: Arman Miri  
# Date: 3/1/25
# Title: Lab 9 - File Performance Measurement
# Description: This script uses /dev/urandom and head -c to generate four random binary files of sizes 100KB, 1MB, 10MB, and 100MB.


#!/bin/bash
cat /dev/urandom | head -c 100000 > file1.bin
cat /dev/urandom | head -c 1000000 > file2.bin
cat /dev/urandom | head -c 10000000 > file3.bin
cat /dev/urandom | head -c 100000000 > file4.bin
