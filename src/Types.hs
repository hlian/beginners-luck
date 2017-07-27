{-# LANGUAGE OverloadedStrings #-}
module Types where

import Coinbase.Exchange.Types.Core
import Coinbase.Exchange.MarketData

newtype NumCandles = NumCandles Int
newtype Minutes = Minutes Int

type CoinbaseCandle = Candle

-- | Useful constant 
ethUSDticker :: ProductId
ethUSDticker = ProductId "ETH-USD"