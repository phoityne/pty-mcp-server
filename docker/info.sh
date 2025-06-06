#!/bin/bash

 podman run --rm --name pty-mcp-server-container --mount type=bind,src=./,dst=/work pty-mcp-server-image /work

 #podman run -it --rm --name pty-mcp-server-container pty-mcp-server-image /bin/bash
