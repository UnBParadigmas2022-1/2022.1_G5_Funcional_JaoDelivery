module Package where

import System.IO
import Data.List.Split (splitOn)
import System.Console.ANSI
import System.Directory
import Control.DeepSeq
import Data.List
import Structure
import Util

data Package = Package { 
  id :: Int, 
  to :: String, 
  from :: String, 
  address :: String, 
  status :: String 
} deriving (Show)

-- read packages from txt file
readPackagesFromFile :: IO [Package]
readPackagesFromFile = do
  let filename = "packages.txt"
  exists <- doesFileExist filename

  if not exists
  then writeFile filename ""
  else return ()

  file <- openFile filename ReadMode
  fileContents <- hGetContents file
  fileContents `deepseq` putStr fileContents
  let readData [id, to, from, address, status] = Package (read id :: Int) to from address status
  let packages = map words $ lines fileContents
  return (map readData packages)

-- parse package data type to string
packageToString :: Package -> String
packageToString (Package id to from address status) =
  (show id) ++ " " ++ to ++ " " ++ from ++ " " ++ address ++ " " ++ status

-- write packages txt file
createFileFromPackages :: [Package] -> IO ()
createFileFromPackages packages = do
  file <- openFile "packages.txt" WriteMode
  let packageStrings = map packageToString packages
  hPutStr file (unlines packageStrings)
  hClose file

-- create package
registerPackage :: [Package] -> IO ()
registerPackage packages = do
  clearScreen;
  putStrLn "Digite o nome do destinatário:"
  to <- formatInput <$> getLine
  putStrLn "Digite o nome do remetente:"
  from <- formatInput <$> getLine
  putStrLn "Digite a cidade do destinatário: (RA de Brasília)"
  address <- formatInput <$> getLine
  let id = (length packages) + 1
  putStr "Identificador do pacote: " 
  putStrLn $ show id
  let package = Package id to from address "pendente"

  createFileFromPackages (packages ++ [package])
  putStrLn "Pacote cadastrado com sucesso!"

-- print single package
printPackage :: Package -> IO ()
printPackage (Package id to from address status) = do
  let package = ("Identificador: " ++ (show id) ++ "\n" ++
                  "Destinatário: " ++ formatOutput to ++ "\n" ++
                  "Remetente: " ++ formatOutput from ++ "\n" ++
                  "Endereço: " ++ formatOutput address ++ "\n" ++
                  "Status: " ++ formatOutput status ++ "\n")
  putStrLn package

-- print multiple packages
printPackages :: Int -> Int -> [Package] -> IO ()
printPackages num len list = do
  let package = list !! num
  if num /= len
  then do
      printPackage package
      printPackages (num + 1) len list
  else putStrLn ("Quantidade de pacotes: " ++ (show len))

-- initial listing packages function
listPackages :: [Package] -> IO ()
listPackages packages = do
  let len = length packages
  clearScreen;
  putStrLn "======== TODOS OS PACOTES PARA ENTREGA ========"
  printPackages 0 len packages

-- list all packages with pending status
listPendingPackages :: [Package] -> IO ()
listPendingPackages packages = do
  let pendingPackages = (filter (\x -> status x == "pendente") packages)
  let len = length pendingPackages
  clearScreen;
  putStrLn "======== TODOS OS PACOTES PENDENTES ========"
  printPackages 0 len pendingPackages

-- get package by identifier
getPackage :: [Package] -> Int -> IO Package
getPackage packages id = do
  let package = packages !! (id - 1)
  return package

-- update package status
updatePackagesStatus :: [Package] -> [Int] -> String -> Int -> Int -> IO [Package]
updatePackagesStatus packages packagesIds status index len = do
  if index /= len
  then do
    let id = packagesIds !! index
    let (left,element:right) = splitAt (id - 1) packages
    let updatedPackage = Package id (to element) (from element) (address element) status
    let updatedPackages = left ++ [updatedPackage] ++ right
    updatePackagesStatus updatedPackages packagesIds status (index+1) len
  else return (packages);

-- update packages status by id
updatePackagesFromIds :: [Package] -> [Int] -> String -> IO ()
updatePackagesFromIds packages packagesIds status = do
  updatedPackages <- updatePackagesStatus packages packagesIds status 0 (length packagesIds)
  createFileFromPackages updatedPackages
  putStrLn "Status dos pacotes alterados com sucesso!"

-- calculate package route from Central
calculatePackageRoute :: [Package] -> IO ()
calculatePackageRoute packages = do
  clearScreen;
  putStrLn "Digite o identificador do pacote:"
  id <- getLine
  package <- getPackage packages (read id :: Int)

  file <- readFile "graph.txt"
  let graph = importText file
  let solution = dijkstra graph "Central"
  printShortestPath (pathToNode solution (address package)) ""
