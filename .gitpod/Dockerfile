FROM gitpod/workspace-node

ENV REBUILD=38c601f77d73fa47ca75d5e18f6f6705f994c9482517a09081e7640b5a99fcesdswddsd

USER root

COPY scripts/* /usr/bin/

RUN apt-get update && apt-get install -yq \
 sshfs \
 && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/*

RUN curl -o /usr/bin/gitpod https://gitpod.io/static/bin/gitpod-cli-linux-amd64 \
 && sudo chmod +x /usr/bin/gitpod

USER gitpod

RUN npm install -g yalc \
 && ln -s /workspace/.yalc /home/gitpod/.yalc \
 && printf '%s\n' '[[ -d /workspace/.yalc ]] || mkdir /workspace/.yalc' > $HOME/.bashrc.d/51-yalc