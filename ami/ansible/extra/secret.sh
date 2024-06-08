#!/bin/bash

# Fetch secret values from AWS Secrets Manager
SECRET_JSON=$(aws secretsmanager get-secret-value --secret-id arn:aws:secretsmanager:us-west-1:730335274738:secret:portfolio-secret-4o7xTQ --query SecretString --output text)

# Unescape the JSON string
SECRET_JSON=$(echo "$SECRET_JSON" | sed 's/\\//g')

# Parse JSON response to get key-value pairs and store them in a file
OUTPUT_FILE="secrets.txt"
jq -r 'to_entries|map("\(.key)=\(.value)")|.[]' <<< "$SECRET_JSON" > "$OUTPUT_FILE"

# Remove temporary file after starting the container
#rm "$OUTPUT_FILE"
