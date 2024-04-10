#!/bin/bash

# Configuration parameters
CONFIG_FILE="Config.json"
USER_ID=$(jq -r '.USER_ID' "$CONFIG_FILE")
API_KEY=$(jq -r '.API_KEY' "$CONFIG_FILE")
USER_AGENT="YourScriptName/1.0 (by $USER_ID on e621)"
FAVORITES_ENDPOINT="https://e621.net/favorites.json"
DOWNLOADS_FOLDER="/Users/yourusername/Downloads" # Adjust this path

# Ensure jq is installed
if ! command -v jq &> /dev/null; then
    echo "jq could not be found. Please install jq to run this script."
    exit 1
fi

# Ensure the Downloads folder exists
if [ ! -d "$DOWNLOADS_FOLDER" ]; then
    echo "Downloads folder does not exist. Please check the path."
    exit 1
fi

# Initial page
PAGE=1

# Loop through all favorite pages
while true; do
    # Make the API request
    RESPONSE=$(curl -s -A "$USER_AGENT" -u "$USER_ID:$API_KEY" "${FAVORITES_ENDPOINT}?page=$PAGE&login=$USER_ID&api_key=$API_KEY")

    # Debug: Print the raw response to inspect its structure
    # Remove or comment out the next two lines in the final script version
    echo "Debug Raw Response:"
    echo "$RESPONSE"
    echo "-------------------------"

    # Check for an empty response
    if [[ "$RESPONSE" == "[]" || "$RESPONSE" == "null" ]]; then
        echo "No more favorites to download or received a null response."
        break
    fi

    # Parse URLs and download files
    echo "$RESPONSE" | jq -r '.posts[].file.url' | while read -r url; do
        if [[ ! -z "$url" ]]; then
            FILENAME=$(basename "$url")
            FULL_PATH="$DOWNLOADS_FOLDER/$FILENAME"
            echo "Downloading $url to $FULL_PATH..."
            curl -s -A "$USER_AGENT" -o "$FULL_PATH" "$url"
        else
            echo "URL is null, skipping..."
        fi
    done

    # Respect the API's rate limit
    sleep 1

    ((PAGE++))
done

echo "All favorites downloaded to $DOWNLOADS_FOLDER."
