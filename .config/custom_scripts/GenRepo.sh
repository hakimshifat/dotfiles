#!/bin/bash

#Prompt user for repository details
read -p “Enter the repository name: “ repo_name
read -p “Enter the repository description: “ repo_description
read -p “Is the repository private? (yes/no): “ repo_private

# Convert yes/no to true/false for the GitHub API
if [ “$repo_private” = “yes” ]; then
 repo_private=”true”
else
 repo_private=”false”
fi

# Set your GitHub personal access token here
GITHUB_TOKEN=”YOUR_GITHUB_TOKEN”
# GitHub API URL
API_URL='https://api.github.com/user/repos'

# Make the API call to create the repository
curl -X POST $API_URL \
 -H “Accept: application/vnd.github+json” \
 -H “Authorization: Bearer $GITHUB_TOKEN” \
 -H “Content-Type: application/json” \
 -d “{\”name\”: \”$repo_name\”, \”description\”: \”$repo_description\”, \”private\”: $repo_private}”

# Check if the repository was created successfully
if [ $? -eq 0 ]; then
 echo “Repository ‘$repo_name’ created successfully.”
else
 echo “Failed to create the repository.”
fi
