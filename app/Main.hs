{-# LANGUAGE CPP #-}
--{-# LANGUAGE MultilineStrings #-}

module Main where

import System.IO
import System.Exit
import Options.Applicative
import qualified Control.Exception.Safe as E
import Paths_pty_mcp_server (version)
import Data.Version (showVersion)

import qualified PMS.Application.Service.App.Control as A
import qualified PMS.Application.Service.DM.Type as A
import qualified PMS.UI.Request.App.Control as URQ
import qualified PMS.UI.Response.App.Control as URS
import qualified PMS.UI.Notification.App.Control as UNO
import qualified PMS.Infra.CmdRun.App.Control as ICR
import qualified PMS.Infra.ProcSpawn.App.Control as IPS
import qualified PMS.Infra.Serial.App.Control as SER
import qualified PMS.Infra.Socket.App.Control as SCK
import qualified PMS.Infra.Watch.App.Control as IWA
import qualified PMS.Domain.Service.App.Control as DSR

#ifdef mingw32_HOST_OS
#else
import qualified PMS.Infrastructure.App.Control as INF
#endif

-- |
--
main :: IO ()
main = getArgs >>= \args -> do
#ifdef mingw32_HOST_OS
  let apps = [URQ.run, URS.run, UNO.run, ICR.run, IPS.run, IWA.run, DSR.run, SCK.run, SER.run]
#else
  let apps = [URQ.run, URS.run, UNO.run, ICR.run, IPS.run, IWA.run, DSR.run, SCK.run, SER.run, INF.run]
#endif
  flip E.catchAny exception
     $ flip E.finally finalize
       $ A.run args apps

  where
    finalize = do
      hPutStrLn stderr "-----------------------------------------------------------------------------"
      hPutStrLn stderr "Finalize called."
      hPutStrLn stderr "-----------------------------------------------------------------------------"

    exception e = do
      hPutStrLn stderr "-----------------------------------------------------------------------------"
      hPutStrLn stderr "ERROR exit."
      hPutStrLn stderr $ show e
      hPutStrLn stderr "-----------------------------------------------------------------------------"
      exitFailure

-------------------------------------------------------------------------------
-- |
--   optparse-applicative
--
getArgs :: IO A.ArgData
getArgs = execParser parseInfo

-- |
--
parseInfo :: ParserInfo A.ArgData
parseInfo = info (helper <*> verOpt <*> options) $ mconcat
  [ fullDesc
  , header   "pty-mcp-server - Pseudo-terminal MCP Server"
  , footer   "Copyright (c) 2025 phoityne. All rights reserved."
  , progDesc "A minimal PTY-based server for running shell commands in MCP style.\n Designed for AI to control interactive programs like GHCi or bash."
  ]

-- |
--
verOpt :: Parser (a -> a)
verOpt = infoOption msg $ mconcat
  [ short 'v'
  , long  "version"
  , help  "Show version"
  ]
  where
    msg = "pty-mcp-server-" ++ showVersion version


-- |
--
options :: Parser A.ArgData
options = (<*>) helper
  $ A.ArgData
  <$> confOption

-- |
--
confOption :: Parser (Maybe FilePath)
confOption = optional $ strOption $ mconcat
  [ short 'y', long "yaml"
  , help "config file"
  , metavar "FILE"
  ]
