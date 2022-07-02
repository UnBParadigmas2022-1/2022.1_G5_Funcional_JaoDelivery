module Structure (
  importFile
) where

import Data.List

data Edge = Edge { node::Node, weight::Float } deriving (Show)
type Node = String
type Graph = [(Node, [Edge])]
type Dnode = (Node, (Float, Node))

importFile :: String -> Graph
importFile strLines = 
  let parseData [n1, n2, w] = ((n1, n2), read w :: Float)
      es = map (parseData . words) $ lines strLines
  in importList es

importList :: [((String, String), Float)] -> Graph
importList es =
  let nodes = nub . map (fst . fst) $ es
      makeEdge es node = 
        let connected = filter (\((n,_),_) -> node == n) $ es
        in map (\((_,n),wt) -> Edge n wt) connected 
  in map (\n -> (n, makeEdge es n)) nodes
