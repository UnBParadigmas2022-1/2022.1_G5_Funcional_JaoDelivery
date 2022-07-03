module Delivery where

import System.IO
import Data.List (intercalate)
import Data.List.Split (splitOn)
import System.Console.ANSI
import Data.List
import Util

import Package

data Delivery = Delivery {
  id       :: Int,
  packages :: [Int],
  status   :: String
} deriving (Show)

readDeliveriesFromFile :: IO [Delivery]
readDeliveriesFromFile = do
  file <- openFile "deliveries.txt" ReadMode
  fileContents <- hGetContents file
  let readData [id, packages, status] = Delivery (read id :: Int) (map (read::String->Int) (splitOn "," packages)) status
  let deliveries = map words $ lines fileContents
  return (map readData deliveries)

deliveryToString :: Delivery -> String
deliveryToString (Delivery id packages status) =
  (show id) ++ " " ++ (intercalate "," (map show packages)) ++ " " ++ status

createFileFromDeliveries :: [Delivery] -> IO ()
createFileFromDeliveries deliveries = do
  file <- openFile "deliveries.txt" WriteMode
  let deliveryStrings = map deliveryToString deliveries
  hPutStr file (unlines deliveryStrings)
  hClose file

-- Get the lenght of the lines in file deliveries.txt as intenger
getDeliveryIdentifier :: IO Int
getDeliveryIdentifier = do
  file <- openFile "deliveries.txt" ReadWriteMode
  fileContents <- hGetContents file
  let new_identifier = ((length $ lines fileContents) + 1)
  hClose file
  return new_identifier

-- TODO: excluir da listagem os produtos ja escolhidos para entrega
printPendingPackages :: Int -> Int -> [String] -> IO ()
printPendingPackages index len packages = do
  let package = packages !! index
  if index < len
  then do
    let attributes = splitOn ";" package
    let status = last attributes
    if status == "Status: pendente"
    then do
      putStrLn  $ intercalate "\n" attributes ++ "\n\n"
    else
      pure ()
    printPendingPackages (index + 1) len packages
  else
    putStrLn ""


listPendingPackages :: IO ()
listPendingPackages = do
  file <- openFile "packages.txt" ReadMode
  fileContents <- hGetContents file
  let packages = splitOn "\n" fileContents
  let len = (length (lines fileContents))
  clearScreen;
  putStrLn $ "======== TODOS OS PACOTES PENDENTES ========" ++ "\n\n"
  printPendingPackages 0 len packages
  hClose file


addPackagesToBag :: [Int] -> IO [Int]
addPackagesToBag packagesIdList = do
  listPendingPackages
  putStrLn "Digite o código do pacote:"
  id <- getLine 
  -- TODO: verificar se o código existe
  let newPackagesIdList = packagesIdList ++ [read id :: Int]
  putStrLn "Produto adicionado com sucesso!"
  putStrLn "Deseja adicionar outro produto?"
  putStrLn "(s) sim (n) não"
  answer <- getLine
  -- TODO: adicionar default case
  if answer == "s"
  then do
      addPackagesToBag newPackagesIdList
  else return packagesIdList


registerDelivery :: [Delivery] -> IO ()
registerDelivery deliveries = do
  let packagesIds = []
  packagesIds <- addPackagesToBag packagesIds
  let deliveryId = (length deliveries) + 1
  let delivery = Delivery deliveryId packagesIds "entregando"
  createFileFromDeliveries (deliveries ++ [delivery])
  putStrLn "Entrega cadastrada!"
    

printDelivery :: Delivery -> IO ()
printDelivery (Delivery id packages status) = do
  let delivery = ("Identificador: " ++ (show id) ++ "\n" ++
                "Pacotes: " ++ (intercalate "," (map show packages)) ++ "\n" ++
                "Status: " ++ status ++ "\n")
  putStrLn delivery


printDeliveries :: Int -> Int -> [Delivery] -> IO ()
printDeliveries index len deliveries = do
  let delivery = deliveries !! index
  if index /= len
  then do
      printDelivery delivery
      printDeliveries (index + 1) len deliveries
  else putStrLn ("Quantidade de entregas: " ++ (show len))

listDeliveries :: [Delivery] -> IO ()
listDeliveries deliveries = do
  let len = length deliveries
  clearScreen
  putStrLn "======== STATUS ENTREGA ========"
  printDeliveries 0 len deliveries
