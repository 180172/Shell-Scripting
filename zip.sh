#!/bin/bash
## This block will zip the Files
function file() {
read -p "Please enter the file name:" name
        gzip "${name}"
if [[ $? == 0 ]]
then
result=$(stat ${name}.gz)
## "stat" command displays the full details of one file
echo -e "This file is successfully zipped. The details of the file are shown below\n$result"
else
echo -e "This file is not successfully zipped. Please try again"
fi
}

# This block will zip the Directory
function directory() {
read -p "Please enter directory name:" dire
tar -czvf ${dire}.tar ${dire} > /dev/null >1
## The "> /dev/null >1"  will not display any unnecessary outputs
## The "-z" in "tar -czvf" will convert the .tar file into a .gz file
if [[ $? == 0 ]]
then
result=$(stat ${dire}.tar)
echo -e "This directory is successfully zipped. The details of the file are shown below\n$result"
else
echo -e "This directory is not successfully zipped. Please try again"
fi

}


        echo "To zip the file press 1"
        echo "To zip the directory press 2"
	echo "To exit the menu press 3"

read -p "Please token number:" token

case $token in

1)      file
        ;;

2)      directory
        ;;

3)      break
        ;;


esac
