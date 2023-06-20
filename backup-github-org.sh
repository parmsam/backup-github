#!/bin/bash

# Enable exit on error and print each command before executing it
set -ex

# Assign the first command-line argument to ORG
ORG="$1"
# Assign the PAGE_SIZE to 1000
TYPE=all
# TYPE=ALL
PAGE_SIZE=1000

# Assign a default value to AUTHENTICATION_API_TOKEN using the GITHUB_AUTH_TOKEN environment variable
# if GITHUB_AUTH_TOKEN is not set or empty, print "must be set and non-empty" and exit
AUTHENTICATION_API_TOKEN="${GITHUB_AUTH_TOKEN:?"must be set and non-empty"}:x-oauth-basic"

# Construct the GitHub API URL for listing repositories of the organization
REPOS_API_URL="https://api.github.com/orgs/${ORG}/repos?type=${TYPE}&per_page=${PAGE_SIZE}"

# Get the current date in the format YYYYMMDD and assign it to DATE
DATE=$(date +"%Y%m%d")

# Construct the name of the temporary directory and assign it to TEMP_DIR
TEMP_DIR="github_${ORG}_${DATE}"

# Construct the name of the backup file and assign it to BACKUP_FILE
BACKUP_FILE="${TEMP_DIR}.tgz"

# Create a directory named TEMP_DIR and then change to that directory
mkdir "$TEMP_DIR" && cd "$TEMP_DIR"

# Get the list of repositories in JSON format, extract the clone URL of each repository, and then clone each repository
curl -u $AUTHENTICATION_API_TOKEN -s "$REPOS_API_URL" | grep -Eo '"clone_url": "[^"]+"' | awk '{print $2}' | xargs -n 1 git clone --mirror

# Go back to the previous directory
cd -

# Create a tarball of the TEMP_DIR and name it as BACKUP_FILE
tar -zcf "$BACKUP_FILE" "$TEMP_DIR"

# Remove the TEMP_DIR directory and its contents (optional)
# rm -rf "$TEMP_DIR"
