#!/bin/bash

echo "[INFO] --------------------------------------------------------------" >&2
echo "[INFO] start $0 $*" >&2

echo "[INFO] os version" >&2
cat /etc/os-release >&2
uname -a >&2

echo "[INFO] set HOME $1" >&2
export HOME=$1

echo "[INFO] cd $HOME" >&2
cd $HOME

echo "[INFO] run startup.sh" >&2
echo "[INFO] --------------------------------------------------------------" >&2

./startup.sh
