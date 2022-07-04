module Util (printShortestPath, formatInput) where

import System.Directory
import Structure
import qualified Data.Text as T
import Data.Text.ICU.Char
import Data.Text.ICU.Normalize
import Data.Char (toLower) 
import Data.List.Utils (replace)
import Data.String.Utils

printShortestPath :: [Node] -> String -> IO ()
printShortestPath [x] acc = do 
    putStrLn "Menor caminho:"
    putStrLn (acc ++ x)
printShortestPath (x:xs) acc = do
    let nacc = acc ++ x ++ " => "
    printShortestPath xs nacc


formatInput :: String -> String
formatInput address = replace " " "_" $ map toLower $ removeAccets $ strip address 

removeAccets :: String -> String
removeAccets s = T.unpack noAccents
  where
    noAccents = T.filter (not . property Diacritic) normalizedText
    normalizedText = normalize NFD (T.pack s)