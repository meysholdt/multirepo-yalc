FROM gitpod/workspace-node

USER root

COPY scripts/* /usr/bin/

RUN apt-get update && apt-get install -yq \
 sshfs \
 && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/*

RUN curl -o /usr/bin/gitpod https://gitpod.io/static/bin/gitpod-cli-linux-amd64 \
 && sudo chmod +x /usr/bin/gitpod

USER gitpod

RUN npm install -g yalc

ENV YALC_STORE_FOLDER=/workspace/.yalc