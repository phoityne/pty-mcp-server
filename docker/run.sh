#!/bin/bash

podman run --rm -v /path/to/config:/work pty-mcp-server-image ./config.yaml

# docker run --rm --name pty-mcp-server--con --mount type=bind,src=/path/to/config,dst=/work pty-mcp-server-image ./config.yaml
