#!/bin/bash

# Default interval in seconds
INTERVAL=10

# Function to display usage
usage() {
  echo "Usage: $0 [--interval seconds]"
  exit 1
}

# Parse command line arguments
while [[ "$#" -gt 0 ]]; do
  case $1 in
    --interval)
      INTERVAL="$2"
      shift 2
      ;;
    *)
      usage
      ;;
  esac
done

# Check if INTERVAL is a positive integer
if ! [[ "$INTERVAL" =~ ^[0-9]+$ ]]; then
  echo "Error: Interval must be a positive integer."
  usage
fi

# Navigate to the script's directory
cd "$(dirname "${BASH_SOURCE[0]}")"

# Run ws-login.sh
./ws-login.sh

# Check the return code of ws-login.sh
if [ $? -eq 0 ]; then
  echo "Login successful. Starting ws-update.sh every $INTERVAL seconds."
  
  # Infinite loop to run ws-update every INTERVAL seconds
  while true; do
    ./ws-update.sh
    sleep "$INTERVAL"
  done

else
  echo "Login failed. Exiting script."
  exit 1
fi