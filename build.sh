#!/bin/sh

cabal update
cabal clean
cabal configure
# cabal build --enable-executable-static
cabal build
cabal install --overwrite-policy=always
cabal sdist
# cabal run pty-mcp-server -- -y ./configs/pty-mcp-server.yaml 

