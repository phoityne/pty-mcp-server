#!/bin/sh

podman build . -t pty-mcp-server-image --progress=plain
# podman build . -t pty-mcp-server-image --progress=plain --no-cache

