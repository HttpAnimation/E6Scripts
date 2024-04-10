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
    RESPONSE=$(curl -s -A "$USER_AGENT" -u "$USER_ID:$API_KEY" "$FAVORITES_ENDPOINT?page=$PAGE")

    # Break if there are no more favorites to process
    if [[ "$RESPONSE" == "[]" ]]; then
        break
    fi

    # Extract post URLs and download each one
    echo "$RESPONSE" | jq -r '.[].file.url' | while read -r url; do
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
