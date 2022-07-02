module Main where

import Menu
import Structure
import Util

main :: IO ()
main = do
  file <- readFile "file.txt"
  let graph = importText file
  -- let solution = dijkstra graph "Central"
  -- printShortestPath (pathToNode solution "Joaolandia") ""
  menu
