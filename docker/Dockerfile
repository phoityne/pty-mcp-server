FROM almalinux:latest 

RUN env

ENV HOME=/root
WORKDIR /root

# avoid interactive mode when installing ghcup
ENV BOOTSTRAP_HASKELL_NONINTERACTIVE=1
# GHC version
ENV BOOTSTRAP_HASKELL_GHC_VERSION=9.12.2
# Cabal version
ENV BOOTSTRAP_HASKELL_CABAL_VERSION=3.12.1.0

RUN dnf update
RUN dnf -y install gcc gcc-c++ gmp gmp-devel make ncurses xz perl g++ pkg-config zlib zlib-devel

RUN bash -c "curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh"

RUN echo "export PATH=$PATH:/root/.local/bin:/root/.ghcup/bin" >> /root/.bashrc

RUN PATH="$PATH:/root/.local/bin:/root/.ghcup/bin" cabal update
# RUN PATH="$PATH:/root/.local/bin:/root/.ghcup/bin" cabal install pty-mcp-server --overwrite-policy=always

# ENTRYPOINT ["pty-mcp-server", "-y"]

COPY initialize.sh /root/initialize.sh
RUN chmod 755 /root/initialize.sh
RUN mkdir /work
WORKDIR /work

ENTRYPOINT ["/bin/bash", "--login", "/root/initialize.sh"]
