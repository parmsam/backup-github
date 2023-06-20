#!/bin/bash

# Enable exit on error and print each command before executing it
set -ex

# Assign the first command-line argument to USER
USER="$1"
# Assign the PAGE_SIZE to 1000
PAGE_SIZE=1000

# Assign a default value to AUTHENTICATION_API_TOKEN using the GITHUB_AUTH_TOKEN environment variable
# if GITHUB_AUTH_TOKEN is not set or empty, print "must be set and non-empty" and exit
AUTHENTICATION_API_TOKEN="${GITHUB_AUTH_TOKEN:?"must be set and non-empty"}"

echo $AUTHENTICATION_API_TOKEN

# Construct the GitHub API URL for listing repositories of the user
REPOS_API_URL1="https://api.github.com/user/repos?&per_page=${PAGE_SIZE}&visibility=all&page=1"
REPOS_API_URL2="https://api.github.com/user/repos?&per_page=${PAGE_SIZE}&visibility=all&page=2"

# Get the current date in the format YYYYMMDD and assign it to DATE
DATE=$(date +"%Y%m%d")

# Construct the name of the temporary directory and assign it to TEMP_DIR
TEMP_DIR="github_${USER}_${DATE}"

# Construct the name of the backup file and assign it to BACKUP_FILE
BACKUP_FILE="${TEMP_DIR}.tgz"

# Create a directory named TEMP_DIR and then change to that directory
mkdir "$TEMP_DIR" && cd "$TEMP_DIR"

# Get the list of repositories in JSON format, extract the clone URL of each repository, and then clone each repository
curl -sfv -u "${USER}:${AUTHENTICATION_API_TOKEN}" "${REPOS_API_URL1}" |
    grep -Eo '"clone_url": "[^"]+"' | 
    awk '{print $2}' | 
    xargs -n 1 git clone --mirror

curl -sfv -u "${USER}:${AUTHENTICATION_API_TOKEN}" "${REPOS_API_URL2}" |
    grep -Eo '"clone_url": "[^"]+"' | 
    awk '{print $2}' | 
    xargs -n 1 git clone --mirror

# Go back to the previous directory
cd -

# Create a tarball of the TEMP_DIR and name it as BACKUP_FILE
tar -zcf "$BACKUP_FILE" "$TEMP_DIR"

# Remove the TEMP_DIR directory and its contents (optional)
# rm -rf "$TEMP_DIR"
