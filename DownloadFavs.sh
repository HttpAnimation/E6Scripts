#!/bin/bash

# Read configuration
USER_ID=$(jq -r '.USER_ID' Config.json)
API_KEY=$(jq -r '.API_KEY' Config.json)

# Set User Agent to identify the script (Replace 'YourScriptName' with a name for your script)
USER_AGENT="YourScriptName/1.0 (by $USER_ID on e621)"

# API endpoint for listing favorites
FAVORITES_ENDPOINT="https://e621.net/favorites.json"

# Initial page
PAGE=1

# Loop through all favorite pages
while true; do
    # Make the API request
    RESPONSE=$(curl -s -A "$USER_AGENT" -u "$USER_ID:$API_KEY" "${FAVORITES_ENDPOINT}?page=$PAGE&login=$USER_ID&api_key=$API_KEY")

    # Debug: Print the first item of the response to inspect its structure
    echo "Debug Response Structure:"
    echo "$RESPONSE" | jq '.[0]'
    echo "-------------------------"

    # Extract the number of posts in the response for the loop break condition
    POST_COUNT=$(echo "$RESPONSE" | jq 'length')

    # Break if there are no more favorites to process
    if [[ "$POST_COUNT" -eq 0 ]]; then
        echo "No more favorites to download."
        break
    fi

    # Assuming the correct JSON path to file URLs is found, update the jq query accordingly
    # This line is an example and might need to be updated based on the actual JSON structure
    echo "$RESPONSE" | jq -r '.[].file.url' | while read -r url; do
        if [[ ! -z "$url" ]]; then
            echo "Downloading $url..."
            curl -O -s -A "$USER_AGENT" "$url"
        else
            echo "URL is null, skipping..."
        fi
    done

    # Respect the API's rate limit
    sleep 1

    ((PAGE++))
done

echo "All favorites downloaded."
