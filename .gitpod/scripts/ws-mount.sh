#!/bin/bash

# Enable debugging
#set -x

# Check if workspaceID is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <workspaceID>"
    exit 1
fi

workspaceID=$1

# Obtain the repository name
repo_info=$(gitpod workspace get "$workspaceID")
repo_name=$(echo "$repo_info" | grep -oP '(?<=Repository: ).*/\K.*')

if [ -z "$repo_name" ]; then
    echo "Failed to obtain repository name for workspace $workspaceID"
    exit 1
fi

mount_point="/workspace/peers/${workspaceID}"

# Create the mount point directory if it doesn't exist
if [ ! -d "$mount_point" ]; then
    mkdir -p "$mount_point"
fi

# Obtain the SSH credentials
credentials_command=$(gitpod workspace ssh --dry-run "$workspaceID")

# Extract the SSH command from the credentials_command
ssh_command=$(echo "$credentials_command" | grep -oP '(?<=^ssh ).*')
ssh_user_host=$(echo "$ssh_command" | awk '{print $1}')
ssh_options=$(echo "$ssh_command" | awk '{for (i=2; i<=NF; i++) printf $i " "}')

# Mount the filesystem using sshfs
sshfs "$ssh_user_host:/workspace/$repo_name" "$mount_point" $ssh_options

# Check if the mount was successful
if [ $? -eq 0 ]; then
    echo "Workspace $workspaceID mounted successfully at $mount_point"

    # Update the git.ignoredRepositories in /workspace/multirepo-yalc/.gitpod/ws-default.code-workspace
    workspace_file="/workspace/multirepo-yalc/.gitpod/ws-default.code-workspace"

    if [ -f "$workspace_file" ]; then
        # Backup the original file
        cp "$workspace_file" "$workspace_file.bak"

        # Add mount_point to git.ignoredRepositories using jq
        jq --arg mp "$mount_point" '.settings["git.ignoredRepositories"] += [$mp]' "$workspace_file" > "${workspace_file}.tmp" && mv "${workspace_file}.tmp" "$workspace_file"
        
        echo "Added $mount_point to git.ignoredRepositories in $workspace_file"
    else
        echo "Workspace file $workspace_file does not exist"
    fi

    code --add "$mount_point"
else
    echo "Failed to mount workspace $workspaceID"
    exit 1
fi

# Disable debugging
#set +x