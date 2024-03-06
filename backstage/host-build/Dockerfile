FROM node:18-bookworm-slim

RUN apt-get update
RUN apt-get install -y --no-install-recommends git wget libsqlite3-dev build-essential python3 ca-certificates
#RUN wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/bin/yq &&\
#    chmod +x /usr/bin/yq

# Create a user
ARG USERNAME=user
ARG USER_UID=1001
ARG USER_GID=$USER_UID

RUN (groupadd --gid $USER_GID $USERNAME || echo "GID ALREADY EXISTS") \
    && (useradd --uid $USER_UID --gid $USER_GID -m $USERNAME) \
    || (export OLD_USERNAME=`id -nu $USER_UID` && usermod --login $USERNAME $OLD_USERNAME \
    && echo "UID $USER_UID ALREADY EXISTS $OLD_USERNAME renamed to $USERNAME")

# Set Python interpreter for `node-gyp` to use
ENV PYTHON /usr/bin/python3

COPY --chown=$USER_UID:$USER_GID .npmrc /home/${USERNAME}/.npmrc
COPY --chown=$USER_UID:$USER_GID .yarnrc /home/${USERNAME}/.yarnrc
COPY --chown=$USER_UID:$USER_GID default-app-config.yaml /home/${USERNAME}/default-app-config.yaml

RUN mkdir -p /usr/local/lib/node_modules/ && chown $USER_UID:$USER_GID /usr/local/lib/node_modules/

# set default user
USER ${USERNAME}
WORKDIR /home/${USERNAME}
