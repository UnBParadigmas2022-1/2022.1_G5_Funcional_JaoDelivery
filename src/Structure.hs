module Structure 
(
  importText,
  dijkstra,
  pathToNode,
  edgesFor,
  Edge(..),
  Node,
  Graph,
  Dnode
) where

import Data.List

-- structures for graph
data Edge = Edge { node::Node, weight::Float } deriving (Show)
type Node = String
type Graph = [(Node, [Edge])]
type Dnode = (Node, (Float, Node))

-- import and build graph by a text file
importText :: String -> Graph
importText strLines = 
  let readData [n1, n2, w] = ((n1, n2), read w :: Float)
      es = map (readData . words) $ lines strLines
  in importList es

-- format text file to graph structure
importList :: [((String, String), Float)] -> Graph
importList es =
  let nodes = nub . map (fst . fst) $ es
      edgesFor es node = 
        let connected = filter (\((n,_),_) -> node == n) $ es
        in map (\((_,n),wt) -> Edge n wt) connected 
  in map (\n -> (n, edgesFor es n)) nodes

-- get all edges for a given graph
edgesFor :: Graph -> Node -> [Edge]
edgesFor g n = snd . head . filter (\(nd, _) -> nd == n) $ g

-- get the weight for a given Node in a graph
weightFor :: Node -> [Edge] -> Float
weightFor n = weight . head . filter (\e -> n == node e)

-- get all nodes conected in a edge
connectedNodes :: [Edge] -> [Node]
connectedNodes = map node

-- get a dnode for a given node
dnodeForNode :: [Dnode] -> Node -> Dnode
dnodeForNode dnodes n = head . filter (\(x, _) -> x == n) $ dnodes

-- dijkstra algorithm to find a path for a given graph with weights
dijkstra :: Graph -> Node -> [Dnode]
dijkstra g start = 
  let dnodes = initD g start
      unchecked = map fst dnodes
  in  dijkstra' g dnodes unchecked

-- initiate a dnode for a given node inside a graph
initD :: Graph -> Node -> [Dnode]
initD g start =
  let initDist (n, es) = 
        if n == start 
        then 0 
        else if start `elem` connectedNodes es
             then weightFor start es
             else 1.0/0.0
  in map (\pr@(n, _) -> (n, ((initDist pr), start))) g

-- help function for dijkstra algorithm
dijkstra' :: Graph -> [Dnode] -> [Node] -> [Dnode]
dijkstra' g dnodes [] = dnodes
dijkstra' g dnodes unchecked = 
  let dunchecked = filter (\dn -> (fst dn) `elem` unchecked) dnodes
      current = head . sortBy (\(_,(d1,_)) (_,(d2,_)) -> compare d1 d2) $ dunchecked
      c = fst current
      unchecked' = delete c unchecked
      edges = edgesFor g c
      cnodes = intersect (connectedNodes edges) unchecked'
      dnodes' = map (\dn -> update dn current cnodes edges) dnodes
  in dijkstra' g dnodes' unchecked' 

-- update inside a given dnode
update :: Dnode -> Dnode -> [Node] -> [Edge] -> Dnode
update dn@(n, (nd, p)) (c, (cd, _)) cnodes edges =
  let wt = weightFor n edges
  in  if n `notElem` cnodes then dn
      else if cd+wt < nd then (n, (cd+wt, c)) else dn

-- get a path to a given node
pathToNode :: [Dnode] -> Node -> [Node]
pathToNode dnodes dest = 
  let dn@(n, (d, p)) = dnodeForNode dnodes dest
  in if n == p then [n] else pathToNode dnodes p ++ [n]