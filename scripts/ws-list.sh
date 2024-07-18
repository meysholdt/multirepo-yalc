#!/bin/bash

#set -x

# Function to get the list of currently mounted workspaces
get_mounted_workspaces() {
  mount | grep "/workspace/peers/" | awk -F'/workspace/peers/' '{print $2}' | awk '{print $1}' | awk -F'/' '{print $1}'
}

get_mounted_workspaces