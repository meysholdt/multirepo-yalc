#!/bin/bash

#set -x

# Function to get the list of currently mounted workspaces
get_mounted_workspaces() {
  find /workspace/peers -mindepth 1 -maxdepth 1 -type d -exec basename {} \;
}

get_mounted_workspaces