#!/bin/sh
# Name: Arman Miri
# Date: 1/7/25
# Title: Lab1 - Unix/Linux Commands and Shell Programming
# Description: This script calculates the area of rectangles and circles. While reviewing basic linux commands in a shell script

# Display script information
echo "Executing $0"
echo "Number of files in directory: $(/bin/ls | wc -l)"
wc -l $(/bin/ls)
echo "HOME=$HOME"
echo "USER=$USER"
echo "PATH=$PATH"
echo "PWD=$PWD"
echo "\$\$=$$"
user=$(whoami)
numusers=$(who | wc -l)

echo "Hi $user! There are $numusers users logged on."
if [ "$user" = "arman" ]; then # Replace 'salagtash' with your username
    echo "Now you can proceed!"
else
    echo "Check who logged in!"
    exit 1
fi

# Rectangle area calculation
response="Yes"
while [ "$response" != "No" ]; do
    echo "Enter height of rectangle: "
    read height
    echo "Enter width of rectangle: "
    read width
    #area=$(expr $height \* $width)
    #Use bc for non integer
    area=$(echo "$height * $width" | bc)    
    echo "The area of the rectangle is $area"


    echo "Would you like to compute the area of another rectangle? [Yes/No]"
    read response
done

# Circle area calculation
response="Yes"
while [ "$response" != "No" ]; do
    echo "Enter radius of the circle: "
    read radius
    area=$(echo "3.14 * $radius * $radius" | bc)
    echo "The area of the circle is $area"

    echo "Would you like to compute the area of another circle? [Yes/No]"
    read response
done

# End of script
echo "Script execution completed."