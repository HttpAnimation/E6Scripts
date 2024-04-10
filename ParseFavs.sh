#!/bin/bash

# Replace these with your actual user ID and API key
USER_ID="<your_user_id>"
API_KEY="<your_api_key>"

# API endpoint for the user's favorites. Adjust if the API has changed.
FAVORITES_URL="https://e621.net/users/$USER_ID/favorites.json"

# Use curl to fetch the favorites JSON, authenticate with your API key.
# jq is used to parse the JSON and extract image URLs.
# Make sure jq is installed (`brew install jq` on macOS).
curl -H "User-ID: $USER_ID" -H "API-Key: $API_KEY" "$FAVORITES_URL" | \
jq '.posts[].file.url' > favorites_urls.json

echo "Downloaded JSON with favorite image URLs to favorites_urls.json"
