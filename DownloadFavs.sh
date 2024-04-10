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

    # Debug: Print the raw response to inspect its structure
    echo "Debug Raw Response:"
    echo "$RESPONSE"
    echo "-------------------------"

    # Determine if the response structure is as expected
    # This is a placeholder for your adjusted jq commands
    # For example, to check if the response is an object and has a certain key:
    IS_VALID=$(echo "$RESPONSE" | jq 'has("posts")') # Adjust based on actual key
    
    # Adjust this conditional based on the structure you're expecting
    if [[ "$IS_VALID" != "true" ]]; then
        echo "Unexpected response structure, exiting."
        exit 1
    fi

    # Adjusted logic to correctly parse the JSON based on its actual structure
    # This is where you'll use the correct jq path
    echo "$RESPONSE" | jq -r '.posts[].file.url' | while read -r url; do # Adjust '.posts[].file.url' as needed
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
