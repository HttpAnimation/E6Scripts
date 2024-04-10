#!/bin/bash

# Assuming Config.json is in the same directory as this script.
CONFIG_FILE="Config.json"

# Use jq to read the user ID and API key from Config.json
USER_ID=$(jq -r '.USER_ID' $CONFIG_FILE)
API_KEY=$(jq -r '.API_KEY' $CONFIG_FILE)

# API endpoint for the user's favorites. Adjust if the API has changed.
FAVORITES_URL="https://e621.net/users/$USER_ID/favorites.json"

# Use curl to fetch the favorites JSON, authenticate with your API key.
# jq is used to parse the JSON and extract image URLs.
# Make sure jq is installed (`brew install jq` on macOS).
curl -H "User-ID: $USER_ID" -H "API-Key: $API_KEY" "$FAVORITES_URL" | \
jq '.posts[].file.url' > favorites_urls.json

echo "Downloaded JSON with favorite image URLs to favorites_urls.json"
