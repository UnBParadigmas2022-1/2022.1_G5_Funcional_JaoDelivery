module Main where

import Menu
import Structure

main :: IO ()
main = do
  file <- readFile "file.csv"
  let nodes = importFile file
  menu