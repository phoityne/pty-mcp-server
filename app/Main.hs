module Main where

import System.IO
import System.Exit
import Options.Applicative
import qualified Control.Exception.Safe as E

import qualified PMS.Application.Service.App.Control as A
import qualified PMS.Application.Service.DM.Type as A
import qualified PMS.UI.Request.App.Control as URQ
import qualified PMS.UI.Response.App.Control as URS
import qualified PMS.Infrastructure.App.Control as INF
import qualified PMS.Domain.Service.App.Control as DSR

-- |
--
main :: IO ()
main = getArgs >>= \args -> do
  let apps = [URQ.run, URS.run, INF.run, DSR.run]
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
parseInfo = info options $ mconcat
  [ fullDesc
  , header   "This is app program."
  , footer   "Copyright 2025. All Rights Reserved."
  , progDesc "This is app program description."
  ]

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
