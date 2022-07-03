module Delivery where

import System.IO
import Data.List (intercalate)
import Data.List.Split (splitOn)
import Util

data Delivery = Delivery {
  id       :: Int,
  packages :: [Int],
  status   :: String
} deriving (Show)

readDeliveriesFromFile :: IO [Delivery]
readDeliveriesFromFile = do
  arq <- openFile "deliveries.txt" ReadMode
  fileContents <- hGetContents arq
  let readData [id, packages, status] = Delivery (read id :: Int) (map (read::String->Int) (splitOn "," packages)) status
  let deliveries = map words $ lines fileContents
  return (map readData deliveries)

deliveryToString :: Delivery -> String
deliveryToString (Delivery id packages status) =
  (show id) ++ " " ++ (intercalate "," (map show packages)) ++ " " ++ status

createFileFromDeliveries :: [Delivery] -> IO ()
createFileFromDeliveries deliveries = do
  arq <- openFile "deliveries.txt" WriteMode
  let deliveryStrings = map deliveryToString deliveries
  hPutStr arq (unlines deliveryStrings)
  hClose arq
