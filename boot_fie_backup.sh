#!/usr/bin/env bash

# This script is written to backup the boot files inside the server once every m                                                      onth.

# Date of Backup.
# Boot File path.
# Compressed Boot file path with Date.
# Final Archive Path.
DATE=$(date +'%Y%m%d')
BOOT_FILE="/var/log/boot.log-*"
BACKUP_PATH="/tmp/Backup_$DATE"
ARCHIVE_PATH=$BACKUP_PATH.tar.gz

# Sending Mail to user according to events.
GMAIL_ID="shriramrao33@gmail.com"
SUBJECT_SUCCESS="Backup Successful - $DATE"
SUBJECT_FAIL="Backup Failed - $DATE"
SUBJECT_NO_FILES="No Boot Files to Backup - $DATE"
BODY_SUCCESS="The backup was archived successfully on $DATE."
BODY_FAIL="The backup archive failed on $DATE."
BODY_NO_FILES="There were no boot files to backup on $DATE."

# Enable nullglob to ensure non-matching patterns expand to empty string.
# Expand the pattern.
shopt -s nullglob
files=($BOOT_FILE)

# Check weather Bootfile is present in the given path.
# If Bootfile is not present in the path then send mail to Admin
# ${#files[@]} gets the total number of elements in the files array.
if [[ ${#files[@]} -eq 0 ]]; then

        echo "Bootfiles don't present in the path"
        sudo echo "$BODY_NO_FILES" | mail -s "$SUBJECT_NO_FILES" "$GMAIL_ID"
else
        echo "Bootfile present in the path"

# If present in the path then check it is allready Archived or not.
# If Archive is all ready present then dont archive.
# If Archive is not present then
#       1.Create an folder.
#       2.Copy All the files to Folder.
#       3.Create .tar.gz files to compress.
        if [[ -e $ARCHIVE_PATH ]]; then
                echo "Backup file is all ready present in the path"
        else
                mkdir -p $BACKUP_PATH > /dev/null 2>&1
                sudo cp -rf ${files[@]} $BACKUP_PATH > /dev/null 2>&1
                sudo tar -cvzf $ARCHIVE_PATH -C $BACKUP_PATH . > /dev/null 2>&1
# Send mail after sucess full backup
# If Operation is performd sucessfully then Delete the Directory and keep Archive file.
# If Operation is not sucessfull show exit code.
                if [[ $? -eq 0 ]]; then
                        echo "Backup Archived sucessfully"
                        sudo rm -rvf $BACKUP_PATH > /dev/null 2>&1
                        echo "$BODY_SUCCESS" | mailx -s "$SUBJECT_SUCCESS" "$GMAIL_ID"
                else
                        echo "Backup Archive is not Achived"
                        echo "$BODY_FAIL" | mailx -s "$SUBJECT_FAIL" "$GMAIL_ID"
                fi
        fi
fi
