#!/bin/bash

# Script to find all instances of [[something]] in files within a directory
# and print both the filename and the content inside the brackets

# Check if directory is provided, otherwise use current directory
DIR="${1:-.}"

if [ ! -d "$DIR" ]; then
    echo "Error: Directory '$DIR' does not exist."
    exit 1
fi

echo "Searching for links in directory: $DIR"
echo "----------------------------------------"

# Find all files in the directory
find "$DIR" -type f | while read -r file; do
    # Skip binary files and hidden files
    if [[ -z "$(file "$file" | grep text)" || $(basename "$file") == .* ]]; then
        continue
    fi
    
    # Search for the pattern [[...]] in the file
    grep -o '\[\[[^]]*\]\]' "$file" 2>/dev/null | while read -r match; do
        # Extract the content between [[ and ]]
        link="${match:2:${#match}-4}"
        
        # Print the filename and the link
        echo "File: $(basename "$file") > $link"
    done
done

echo "Search complete."
