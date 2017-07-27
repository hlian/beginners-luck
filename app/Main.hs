{-# LANGUAGE OverloadedStrings #-}

module Main where

-- Web request stuff
import Network.HTTP.Client
import Network.HTTP.Client.TLS

-- Coinbase stuff
import Coinbase.Exchange.Types

-- Haskell stuff
import Data.Either
import Control.Concurrent
import Control.Monad

import Lib
import Types

-- | Must use this for getting candles or historical data
liveConf :: Manager -> ExchangeConf
liveConf mgr = ExchangeConf mgr Nothing Live

-- | Use this for trades etc. so you don't lose money 
sandboxConf :: Manager -> ExchangeConf
sandboxConf mgr = ExchangeConf mgr Nothing Sandbox

-- | Helper for what to do if the rest of the computations in the program depend on this success
failEither :: Show a => Either a b -> IO b
failEither (Left err) = fail (show err)
failEither (Right b) = return b

period :: Minutes
period = Minutes 2

main :: IO ()
main = do
  {- GDAX API setup stuff -}
  -- liveConfig <- liveConf <$> newManager tlsManagerSettings
  mgr <- newManager tlsManagerSettings
  let liveConfig = liveConf mgr
  let sandboxConfig = sandboxConf mgr

  {- Request info from GDAX API -}
  tenCandles <- failEither =<< getMostRecentCandles liveConfig (NumCandles 10) period
  thirtyCandles <- failEither =<< getMostRecentCandles liveConfig (NumCandles 30) period
  
  {- Plot/display the data -}
  print (length tenCandles)
  displayCandles "TenCandlesticks.svg" tenCandles

  -- threadDelay (15000000 :: Int)

  case length tenCandles of
    0 -> putStrLn "Did not get any candles"
    _ -> print (sma tenCandles)
