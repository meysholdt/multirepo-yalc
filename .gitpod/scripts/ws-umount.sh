#!/bin/bash

#set -x

workspace_id="$1"

# Function to remove the path entry from the code-workspace file
remove_path_entry() {
  local workspace_file="/workspace/multirepo-yalc/.gitpod/ws-default.code-workspace"
  if [ -f "$workspace_file" ]; then
    local tmp_file=$(mktemp)
    jq --arg workspace_id "$workspace_id" 'del(.folders[] | select(.path | test($workspace_id)))' "$workspace_file" > "$tmp_file" && mv "$tmp_file" "$workspace_file"
    echo "Removed path entry for $workspace_id from $workspace_file"
  else
    echo "Workspace file $workspace_file does not exist"
  fi
}

# Function to unmount a workspace
unmount_workspace() {
  local mount_point="/workspace/peers/$workspace_id"
  local retries=10
  local count=0
  while (( count < retries )); do
    if mountpoint -q "$mount_point"; then
      if fusermount -u "$mount_point"; then
        echo "Unmounted $mount_point"
        return 0
      else
        echo "Failed to unmount $mount_point. Retrying... ($((count+1))/$retries)"
        sleep 1
      fi
    else
      echo "$mount_point is not mounted"
      return 0
    fi
    ((count++))
  done
  echo "Failed to unmount $mount_point after $retries attempts"
  return 1
}

# Function to delete the workspace folder
delete_workspace_folder() {
  local folder="/workspace/peers/$workspace_id"
  local retries=10
  local count=0
  while (( count < retries )); do
    if [ -d "$folder" ]; then
      if rm -rf "$folder"; then
        echo "Deleted folder $folder"
        return 0
      else
        echo "Failed to delete $folder. Retrying... ($((count+1))/$retries)"
        sleep 1
      fi
    else
      echo "Folder $folder does not exist"
      return 0
    fi
    ((count++))
  done
  echo "Failed to delete $folder after $retries attempts"
  return 1
}

remove_path_entry
unmount_workspace
delete_workspace_folder