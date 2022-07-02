module Delivery where

import System.IO
import Data.List.Split (splitOn)

data Delivery = {
    id       :: Int,
    packages :: [Int],
    status   :: String
}

-- registerDelivery :: IO ()
-- registerDelivery = Empty