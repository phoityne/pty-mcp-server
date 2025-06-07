#!/bin/bash

#!/bin/bash

echo "[INFO] start run.sh" >&2

SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"

echo "[INFO] SCRIPT_PATH:$SCRIPT_PATH" >&2
echo "[INFO] SCRIPT_DIR:$SCRIPT_DIR" >&2

podman run --rm -i \
--name pty-mcp-server-container \
-v $SCRIPT_DIR:$SCRIPT_DIR \
--hostname pms-docker-container \
pty-mcp-server-image \
-y $SCRIPT_DIR/config.yaml


# docker run --rm -i \
# --name pty-mcp-server-container \
# --mount type=bind,src=$SCRIPT_DIR,dst=$SCRIPT_DIR \
# --hostname pms-docker-container \
# pty-mcp-server-image \
# -y $SCRIPT_DIR/config.yaml

# podman exec -it pty-mcp-server-container /bin/bash
# ssh phoityne@host.docker.internal
