#!/bin/bash
read -p "Please enter the file or directory name:" path

## If the entered path is DIRECTORY then this block will execute
if [[ -d $path ]]
then
echo "Directory is present in the path"

## If the entered path is FILE then this block will execute
elif [[ -e $path ]]
then
echo "File is present in the path"

## If both FILE and DIRECTORY are not present in the path then this block will execute
else
echo "Directory or File is not present in the path"
fi

