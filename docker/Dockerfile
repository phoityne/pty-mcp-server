FROM almalinux:latest 

RUN dnf -y update
RUN dnf -y install gcc gcc-c++ gmp gmp-devel make ncurses xz perl g++ pkg-config zlib zlib-devel openssh-clients procps-ng

ENV BOOTSTRAP_HASKELL_NONINTERACTIVE=1
ENV BOOTSTRAP_HASKELL_GHC_VERSION=9.12.2
ENV BOOTSTRAP_HASKELL_CABAL_VERSION=3.12.1.0
RUN bash -c "curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh"

RUN echo "export PATH=$PATH:/root/.local/bin:/root/.ghcup/bin:/root/.cabal/bin" >> /root/.bashrc

RUN PATH="$PATH:/root/.local/bin:/root/.ghcup/bin" cabal update
RUN PATH="$PATH:/root/.local/bin:/root/.ghcup/bin" cabal install pty-mcp-server --overwrite-policy=always

ENTRYPOINT ["/root/.cabal/bin/pty-mcp-server"]

# COPY initialize.sh /root/initialize.sh
# RUN chmod 755 /root/initialize.sh
# RUN mkdir /work
# WORKDIR /work
# ENTRYPOINT ["/bin/bash", "--login", "/root/initialize.sh"]
