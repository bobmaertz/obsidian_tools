#!/usr/bin/env bash

# Check if directory is provided, otherwise use current directory
DIR="${1:-.}"

if [ ! -d "$DIR" ]; then
    echo "Error: Directory '$DIR' does not exist."
    exit 1
fi

# If the script is run with the --dry-run flag, it will only print the files that would be modified
 if [ "$2" == "--dry-run" ]; then
    echo "dry-run enabled - files will not be modified" 
    DRY_RUN=true
else
    DRY_RUN=false
fi

# Change to the specified directory
cd "$DIR" || exit 1

# Process each file in the directory
for file in *; do
    # Skip if not a regular file
    if [ ! -f "$file" ]; then
        continue
    fi

    # Skip if file already has the metadata header 
    if head -n 10 "$file" | grep -q "^--*"; then 

       # echo "Skipping file with existing metadata: $file"
        continue
    fi

    # Skip modification if dry run is enabled
    if [ "$DRY_RUN" = true ]; then
        echo "Would add metadata to $file"
        continue
    fi



    # Add metadata header to the file
    {
        echo "date: [[$(basename "$file" | cut -c 1-4)-$(basename "$file" | cut -c 5-6)-$(basename "$file" | cut -c 7-8)]]"
        echo "tags: "
        echo "links: []" 
        echo "" 
        echo "---"
        echo ""
        echo "# $(basename "$file" | sed 's/^[^-]*-//; s/\.md$//')"
        echo ""
    } | cat - "$file" > temp && mv temp "$file" 
    # Output the file name being processed
    echo "Added metadata to $file" 
done; 
