#!/bin/bash

# Enable debugging
#set -x

# Check if workspaceID is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <workspaceID>"
    exit 1
fi

workspaceID=$1
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
sshfs "$ssh_user_host:/workspace" "$mount_point" $ssh_options

# Check if the mount was successful
if [ $? -eq 0 ]; then
    echo "Workspace $workspaceID mounted successfully at $mount_point"
    code --add "$mount_point"
else
    echo "Failed to mount workspace $workspaceID"
    exit 1
fi

# Disable debugging
#set +x