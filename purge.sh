#!/bin/bash

# The Cloudflare API endpoint for purging all caches for a zone
purge_url="https://api.cloudflare.com/client/v4/zones/${cf_zone_id}/purge_cache"

# The payload for the Cloudflare API request
payload='{"purge_everything":true}'

# Send the Cloudflare API request to purge all caches for the zone
response=$(curl -s -X DELETE "$purge_url" \
-H "Authorization: Bearer $cf_api_token" \
-H "Content-Type: application/json" \
--data-raw "$payload")

# Check if the request was successful
if [[ "$response" =~ "\"success\": true" ]]; then
    echo "All $website_name caches have been purged."
else
    # Extract the error message from the JSON response using a regular expression
    error_regex="\"message\":\"(.*)\""
    if [[ "$response" =~ $error_regex ]]; then
        error_message="${BASH_REMATCH[1]}"
        echo "An error occurred: $error_message"
    else
        echo "An unknown error occurred."
    fi
fi
