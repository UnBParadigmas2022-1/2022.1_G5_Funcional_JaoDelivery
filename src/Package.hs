module Package where

import System.IO
import Data.List.Split (splitOn)
import System.Console.ANSI
import Control.DeepSeq
import Data.List

data Package = Package { 
  id :: Int, 
  to :: String, 
  from :: String, 
  address :: String, 
  status :: String 
} deriving (Show)

readPackagesFromFile :: IO [Package]
readPackagesFromFile = do
  file <- openFile "packages.txt" ReadMode
  fileContents <- hGetContents file
  fileContents `deepseq` putStr fileContents
  let readData [id, to, from, address, status] = Package (read id :: Int) to from address status
  let packages = map words $ lines fileContents
  return (map readData packages)

packageToString :: Package -> String
packageToString (Package id to from address status) =
  (show id) ++ " " ++ to ++ " " ++ from ++ " " ++ address ++ " " ++ status

createFileFromPackages :: [Package] -> IO ()
createFileFromPackages packages = do
  file <- openFile "packages.txt" WriteMode
  let packageStrings = map packageToString packages
  hPutStr file (unlines packageStrings)
  hClose file

registerPackage :: [Package] -> IO ()
registerPackage packages = do
  clearScreen;
  putStrLn "Digite o nome do destinatário:"
  to <- getLine
  putStrLn "Digite o nome do remetente:"
  from <- getLine
  putStrLn "Digite o endereço do destinatário:"
  address <- getLine
  let id = (length packages) + 1
  putStr "Identificador do pacote: " 
  putStrLn $ show id
  let package = Package id to from address "pendente"

  createFileFromPackages (packages ++ [package])
  putStrLn "Pacote cadastrado com sucesso!"

printPackage :: Package -> IO ()
printPackage (Package id to from address status) = do
  let package = ("Identificador: " ++ (show id) ++ "\n" ++
                  "Destinatário: " ++ to ++ "\n" ++
                  "Remetente: " ++ from ++ "\n" ++
                  "Endereço: " ++ address ++ "\n" ++
                  "Status: " ++ status ++ "\n")
  putStrLn package

printPackages :: Int -> Int -> [Package] -> IO ()
printPackages num len list = do
  let package = list !! num
  if num /= len
  then do
      printPackage package
      printPackages (num + 1) len list
  else putStrLn ("Quantidade de pacotes: " ++ (show len))

listPackages :: [Package] -> IO ()
listPackages packages = do
  let len = length packages
  clearScreen;
  putStrLn "======== TODOS OS PACOTES PARA ENTREGA ========"
  printPackages 0 len packages

listPendingPackages :: [Package] -> IO ()
listPendingPackages packages = do
  let len = length packages
  clearScreen;
  putStrLn "======== TODOS OS PACOTES PENDENTES ========"
  printPackages 0 len (filter (\x -> status x == "pendente") packages)

-- Get the package by identifier
getPackage :: [Package] -> Int -> IO Package
getPackage packages id = do
  let package = packages !! id
  return package

updatePackageStatus :: [Package] -> Int -> String -> IO ()
updatePackageStatus packages id status = do
  let (left,element:right) = splitAt (id - 1) packages
  let updatedPackage = Package id (to element) (from element) (address element) status
  let updatedPackages = left ++ [updatedPackage] ++ right
  createFileFromPackages updatedPackages