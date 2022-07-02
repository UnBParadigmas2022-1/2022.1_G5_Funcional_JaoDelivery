module Main where

import Menu
import Structure

main :: IO ()
main = do
  file <- readFile "file.txt"
  let nodes = importText file
  menu