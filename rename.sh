#!/bin/bash

# Script to rename files using creation timestamp in format: YYYYMMDDHHMMSS - filename.extension

# Check if directory is provided, otherwise use current directory
DIR="${1:-.}"

if [ ! -d "$DIR" ]; then
    echo "Error: Directory '$DIR' does not exist."
    exit 1
fi

# Change to the specified directory
cd "$DIR" || exit 1

# Process each file in the directory
for file in *; do
    # Skip if not a regular file
    if [ ! -f "$file" ]; then
        continue
    fi
    
    # Skip if file already has the timestamp format
    if [[ "$file" =~ ^[0-9]{14}\ -\ .* || "$file" =~ ^[0-9]{13}\ -\ .* || "$file" =~ ^[0-9]{12}\ -\ .* ]]; then
        echo "Skipping already formatted file: $file"
        continue
    fi
    
    # Get file creation time on macOS
    creation_time=$(stat -f "%SB" -t "%Y%m%d%H%M%S" "$file")
    
    # Get file extension and base name
    filename=$(basename -- "$file")
    if [[ "$filename" == *.* ]]; then
        extension="${filename##*.}"
        basename="${filename%.*}"
        new_name="${creation_time} - ${basename}.${extension}"
    else
        # No extension
        new_name="${creation_time} - ${filename}"
    fi
    
    # Rename the file
    if [ -e "$new_name" ]; then
        echo "Error: Cannot rename '$file' to '$new_name' - file already exists."
    else
        mv "$file" "$new_name"
        echo "Renamed: '$file' to '$new_name'"
    fi
done

echo "Renaming complete."
