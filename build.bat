@echo off

@rem cabal update
cabal clean
cabal configure
cabal build --enable-executable-static
cabal install --overwrite-policy=always
cabal sdist

@rem dumpbin.exe /DEPENDENTS pty-mcp-server.exe
