module Main where

import Menu
import Util

main :: IO ()
main = do
  file <- readFile "graph.txt"
  menu
