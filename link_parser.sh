#!/usr/bin/env bash

# This script parses the standard input in the format of File > Link and will drop any links that are the format YYYY-MM-DD or start with over 10 characters of numbers. 
#
# Usage:
# cat input.txt | ./link_parser.sh > output.txt
#   
#   # Example input:
#   #   file1.txt > 2023-10-01
#   #   # Example output:
#   #   #   file1.txt > 2023-10-01
#       
#       #   # Example input:
#       #   file2.txt > 1234567890-some-link
#       #   # Example output:
#       #       #   file2.txt > 1234567890-some-link


while IFS= read -r line; do
    # Extract the link part after the '>'
    link=$(echo "$line" | cut -d '>' -f2 | xargs)

    # Check if the link is in the format YYYY-MM-DD or starts with more than 10 digits
    if echo "$link" | grep -qE '^[0-9]{4}-[0-9]{2}-[0-9]{2}$' || echo "$link" | grep -qE '^[0-9]{10,}'; then
        continue  # Skip this line
    fi

    # If it passes the checks, print the line
    echo "$line"
done
