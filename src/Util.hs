module Util (printShortestPath, formatInput, formatOutput) where

import System.Directory
import Structure
import qualified Data.Text as T
import Data.Text.ICU.Char
import Data.Text.ICU.Normalize
import Data.Char (toLower) 
import Data.List.Utils (replace)
import Data.String.Utils
import Data.Char

printShortestPath :: [Node] -> String -> IO ()
printShortestPath [x] acc = do 
    putStrLn "Menor caminho:"
    putStrLn (acc ++ x)
printShortestPath (x:xs) acc = do
    let nacc = acc ++ x ++ " => "
    printShortestPath xs nacc

-- | Formt a string to be used as input for the program.
formatInput :: String -> String
formatInput address = replace " " "_" $ map toLower $ removeAccets $ strip address 

-- | Remove accents from a string
removeAccets :: String -> String
removeAccets string = T.unpack noAccents
  where
    noAccents = T.filter (not . property Diacritic) normalizedText
    normalizedText = normalize NFD (T.pack string)

-- | Format a string to be used as output for the program.
formatOutput :: String -> String
formatOutput s = capitalize $ replace "_" " " s

-- | Upper case first letter of a string
upperFirst :: String -> String
upperFirst (c1:c2:rest) =
    if isSpace c1 && isLower c2
        then c1 : toUpper c2 : upperFirst rest
        else c1 : upperFirst (c2:rest)
upperFirst s = s

-- | Capitalize all words in a string
capitalize :: String -> String
capitalize [] = []
capitalize [c] = [toUpper c]
capitalize (s:str) = upperFirst (toUpper s:str)
