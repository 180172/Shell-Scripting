#!/usr/bin/env bash

# Define the file containing the list of files and directories to back up
FILES_FOR_BACKUP=backup_test.txt

# Get the current date in YYYYMMDD format
DATE=$(date +'%Y%m%d')

# Define the backup path, including the date in the directory name
BACKUP_PATH="/tmp/Backup_$DATE"

# Define the email recipient and subject for notifications
EMAIL="<ENTER YOUR MAIL ID>"
MAIL_SUBJECT="Backup Notification for $DATE"

# Define the log files
ZIPPED_FILES="/tmp/zipped_files.log"
FILE_NOT_FOUND="/tmp/file_not_found.log"

# Function to send an email notification
SEND_MAIL() {
    local message="$1"
    # Send an email with the given message
    echo "$message" | mailx -s "$MAIL_SUBJECT" -a "$ZIPPED_FILES" -a "$FILE_NOT_FOUND" "$EMAIL"
}

# Function to perform the backup
BACK_UP(){
    # Check if the backup directory already exists
    if [[ -d $BACKUP_PATH ]]; then
        message="Backup directory $BACKUP_PATH already exists. Skipping backup."
        echo "$message"
        # Send a notification and exit if the backup directory already exists
        SEND_MAIL "$message"
        exit 0
    fi

    # Create the backup directory
    mkdir -p $BACKUP_PATH

    # Initialize the log files
    > $ZIPPED_FILES
    > $FILE_NOT_FOUND

    # Read each line from the files for backup list
    while IFS= read -r script; do
        # Skip empty lines and lines starting with "##"
        if [[ -z $script || $script == \#\#* ]]; then
            continue
        fi

        # Remove carriage return characters (useful for Windows-formatted files)
        script=$(echo "$script" | tr -d '\r')

        # Check if the path exists
        if [[ -e $script ]]; then
            # If it's a file, create a zip archive
            if [[ -f $script ]]; then
                zip -q "$BACKUP_PATH/$(basename "$script").zip" "$script" && echo "$script" >> $ZIPPED_FILES
            # If it's a directory, create a tar.gz archive
            elif [[ -d $script ]]; then
                tar -czf "$BACKUP_PATH/$(basename "$script").tar.gz" "$script" && echo "$script" >> $ZIPPED_FILES
            else
                # If it exists but is neither a file nor a directory, print a message
                echo "$script exists but is neither a file nor a directory"
            fi
        else
            # Print a message if the path does not exist
            echo "$script is not present in the path" >> $FILE_NOT_FOUND
        fi
    done < "$FILES_FOR_BACKUP"

    # Send a notification that the backup completed successfully
    SEND_MAIL "Backup completed successfully."
}

# Execute the backup function
BACK_UP

