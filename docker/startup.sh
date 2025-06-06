#!/bin/bash

echo ""
echo "[INFO] env"
env

echo ""
echo "[INFO] haskell versions"
ghc --version
cabal --version

echo ""
echo "do something within the container environment."
echo ""


