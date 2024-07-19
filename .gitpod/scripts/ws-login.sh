#!/bin/bash

# Function to check if Gitpod is logged in
is_gitpod_logged_in() {
    gitpod whoami > /dev/null 2>&1
    return $?
}

# Check if Gitpod is already logged in
if ! is_gitpod_logged_in; then
    # Check if GITPOD_TOKEN environment variable is set
    if [ -z "$GITPOD_TOKEN" ]; then
        # If not set, prompt the user for the value of GITPOD_TOKEN
        read -p "To access other workspaces, please create a token at $GITPOD_HOST/user/tokens and enter it here: " GITPOD_TOKEN

        # Set the GITPOD_TOKEN environment variable using gp env
        gp env GITPOD_TOKEN="$GITPOD_TOKEN"
    fi

    # Call gitpod login with the provided token
    gitpod login --token "$GITPOD_TOKEN"
fi