# GitHub Repositories Backup Scripts

This project contains shell scripts to backup all the repositories of a specific GitHub user or organization.

## Getting Started

These instructions will guide you on how to use the scripts to backup repositories.

### Prerequisites

- bash
- curl
- git
- tar
- awk, grep, and other standard Unix utilities

### Scripts

There are two scripts in the project:

1. `backup_github_org.sh` - This script backs up all the repositories of a given GitHub organization.
2. `backup_github_user.sh` - This script backs up all the repositories of a given GitHub user.

Both scripts take a single command-line argument: the name of the user or organization to backup.

### Usage

To use the scripts, you will first need to obtain a GitHub access token and set it as an environment variable:

```bash
export GITHUB_AUTH_TOKEN=your_github_access_token
```

You can then run the scripts like so:

```bash
./backup_github_org.sh OrganizationName
./backup_github_user.sh UserName
```
Replace OrganizationName and UserName with the actual name of the GitHub organization or user that you want to backup, and your_github_access_token with your actual GitHub access token. Ensure the PAT token it setup with full repo access.

Finally, remember to make the script files executable by using the chmod command if they are not already. You can do this with the following command: 
    `chmod +x backup_github_org.sh` or `chmod +x backup_github_user.sh`.

# Troubleshooting

- Make sure you firewall is not blocking the connection to GitHub via curl.
