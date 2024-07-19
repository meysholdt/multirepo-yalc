#!/bin/bash

# set -x

cd "$(dirname "${BASH_SOURCE[0]}")"

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
  local mounted=()
  local unmounted=()

  # Ensure /workspace/peers/ directory exists
  mkdir -p /workspace/peers/

  # Mount new workspaces
  for workspace_id in "${running_workspaces[@]}"; do
    if [[ "$workspace_id" == "$current_workspace_id" ]]; then
      continue
    elif ! contains_element "$workspace_id" "${mounted_workspaces[@]}"; then
      ./ws-mount.sh "$workspace_id"
      mounted+=("$workspace_id")
    fi
  done

  # Unmount workspaces that are no longer running
  for workspace_id in "${mounted_workspaces[@]}"; do
    if ! contains_element "$workspace_id" "${running_workspaces[@]}"; then
      ./ws-umount.sh "$workspace_id"
      unmounted+=("$workspace_id")
    fi
  done

  # Prepare the summary
  local mounted_summary="none"
  local unmounted_summary="none"

  if [ ${#mounted[@]} -ne 0 ]; then
    mounted_summary="${mounted[*]}"
  fi

  if [ ${#unmounted[@]} -ne 0 ]; then
    unmounted_summary="${unmounted[*]}"
  fi

  # Log the summary with timestamp
  local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
  echo "$timestamp - Mounted workspaces: $mounted_summary; Unmounted workspaces: $unmounted_summary"
}

# Execute main function
main