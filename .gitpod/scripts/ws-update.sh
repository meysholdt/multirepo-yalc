#!/bin/bash

# set -x

cd "$(dirname "${BASH_SOURCE[0]}")"

./ws-login.sh

# Function to get the list of running workspaces
get_running_workspaces() {
  gitpod workspace list -r --field id
}

# Function to check if an element is in an array
contains_element() {
  local element
  for element in "${@:2}"; do
    if [[ "$element" == "$1" ]]; then
      return 0
    fi
  done
  return 1
}

# Main script execution
main() {
  local current_workspace_id="$GITPOD_WORKSPACE_ID"
  local running_workspaces=($(get_running_workspaces))
  local mounted_workspaces=($(./ws-list.sh))

  # Ensure /workspace/peers/ directory exists
  mkdir -p /workspace/peers/

  # Mount new workspaces
  for workspace_id in "${running_workspaces[@]}"; do
    if [[ "$workspace_id" == "$current_workspace_id" ]]; then
      echo "Skipping mount for current workspace: $workspace_id"
    elif ! contains_element "$workspace_id" "${mounted_workspaces[@]}"; then
      echo "Mounting new workspace: $workspace_id"
      ./ws-mount.sh "$workspace_id"
    else
      echo "Workspace already mounted: $workspace_id"
    fi
  done

  # Unmount workspaces that are no longer running
  for workspace_id in "${mounted_workspaces[@]}"; do
    if ! contains_element "$workspace_id" "${running_workspaces[@]}"; then
      echo "Unmounting workspace no longer running: $workspace_id"
      ./ws-umount.sh "$workspace_id"
    else
      echo "Workspace still running: $workspace_id"
    fi
  done
}

# Execute main function
main