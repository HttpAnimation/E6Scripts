#!/bin/bash

# Other script parts remain unchanged

# Loop through all favorite pages
while true; do
    # Make the API request
    RESPONSE=$(curl -s -A "$USER_AGENT" -u "$USER_ID:$API_KEY" "$FAVORITES_ENDPOINT?page=$PAGE")

    # Debug: Print the first item of the response to inspect its structure
    echo "Debug Response Structure:"
    echo "$RESPONSE" | jq '.[0]'
    echo "-------------------------"

    # Break if there are no more favorites to process or if the response is invalid
    if [[ "$RESPONSE" == "[]" || "$RESPONSE" == "null" ]]; then
        break
    fi

    # Assuming the correct structure is found and the jq query is adjusted accordingly
    # This line will need to be updated to match the correct path
    echo "$RESPONSE" | jq -r '.[].file.url' | while read -url; do
        if [[ ! -z "$url" ]]; then
            echo "Downloading $url..."
            curl -O -s -A "$USER_AGENT" "$url"
        fi
    done

    # Respect the API's rate limit
    sleep 1

    ((PAGE++))
done

echo "All favorites downloaded."
