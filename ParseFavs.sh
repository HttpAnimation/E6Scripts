#!/bin/bash

# Load user ID and API key from Config.json
CONFIG_FILE="Config.json"
USER_ID=$(jq -r '.USER_ID' $CONFIG_FILE)
API_KEY=$(jq -r '.API_KEY' $CONFIG_FILE)

# API endpoint for fetching favorites. Modify if the endpoint changes.
FAVORITES_URL="https://e621.net/favorites.json"

# Descriptive User-Agent header value
USER_AGENT="E621FavoritesDownloader/1.0 (by YOUR_USERNAME on e621)"

# Perform the API request using basic authentication
curl -u "$USER_ID:$API_KEY" \
     -A "$USER_AGENT" \
     "$FAVORITES_URL" \
     -o favorites_urls.json

echo "Downloaded JSON with favorite image URLs to favorites_urls.json"
