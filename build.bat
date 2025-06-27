@echo off

cabal update
cabal clean
cabal configure
cabal build
cabal install --overwrite-policy=always
cabal sdist