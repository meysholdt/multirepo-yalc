#!/bin/bash

#set -x

workspace_id="$1"

# Function to unmount a workspace
unmount_workspace() {
  local workspace_id="$1"
  local mount_point="/workspace/peers/$workspace_id"
  fusermount -u "$mount_point"
}

unmount_workspace "$workspace_id"