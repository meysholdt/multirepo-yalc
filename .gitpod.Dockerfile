FROM gitpod/workspace-node

RUN apt-get update && apt-get install -yq \
 sshfs \
 && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/*

RUN printf '%s\n' '#!/bin/bash' '$BROWSER "$1"' | sudo tee /usr/bin/xdg-open \
 && chmod +x /usr/bin/xdg-open

RUN curl -o /usr/bin/gitpod https://gitpod.io/static/bin/gitpod-cli-linux-amd64 \
 && sudo chmod +x /usr/bin/gitpod

USER gitpod

RUN npm install -g yalc