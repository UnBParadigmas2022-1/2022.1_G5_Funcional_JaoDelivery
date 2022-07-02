module Util (printShortestPath) where

import Structure

printShortestPath :: [Node] -> String -> IO ()
printShortestPath [x] acc = do 
    putStrLn "Menor caminho:"
    putStrLn (acc ++ x)
printShortestPath (x:xs) acc = do
    let nacc = acc ++ x ++ " => "
    printShortestPath xs nacc