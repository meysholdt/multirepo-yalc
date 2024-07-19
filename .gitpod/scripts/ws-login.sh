#!/bin/bash

# Function to check if Gitpod is logged in
is_gitpod_logged_in() {
    gitpod whoami > /dev/null 2>&1
    return $?
}

# Check if Gitpod is already logged in
if ! is_gitpod_logged_in; then
    # Check if WS_TOKEN environment variable is set
    if [ -z "$WS_TOKEN" ]; then
        # If not set, prompt the user for the value of WS_TOKEN
        read -p "To access other workspaces, please create a token at $GITPOD_HOST/user/tokens and enter it here: " WS_TOKEN

        # Set the WS_TOKEN environment variable using gp env
        gp env WS_TOKEN="$WS_TOKEN"
    fi

    # Call gitpod login with the provided token
    gitpod login --token "$WS_TOKEN"
fi