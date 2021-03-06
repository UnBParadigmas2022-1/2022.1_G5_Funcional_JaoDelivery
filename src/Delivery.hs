module Delivery where

import System.IO
import Data.List (intercalate)
import Data.List.Split (splitOn)
import System.Console.ANSI
import System.Directory
import Control.DeepSeq
import Data.List
import Util

import Package

data Delivery = Delivery {
  id       :: Int,
  packages :: [Int],
  status   :: String
} deriving (Show)

-- get deliveries from txt file
readDeliveriesFromFile :: IO [Delivery]
readDeliveriesFromFile = do
  let filename = "deliveries.txt"
  exists <- doesFileExist filename

  if not exists
  then writeFile filename ""
  else return ()

  file <- openFile filename ReadMode
  fileContents <- hGetContents file
  fileContents `deepseq` putStr fileContents
  let readData [id, packages, status] = Delivery (read id :: Int) (map (read::String->Int) (splitOn "," packages)) status
  let deliveries = map words $ lines fileContents
  return (map readData deliveries)

-- parse delivery data type to string
deliveryToString :: Delivery -> String
deliveryToString (Delivery id packages status) =
  (show id) ++ " " ++ (intercalate "," (map show packages)) ++ " " ++ status

-- write deliveries txt file
createFileFromDeliveries :: [Delivery] -> IO ()
createFileFromDeliveries deliveries = do
  file <- openFile "deliveries.txt" WriteMode
  let deliveryStrings = map deliveryToString deliveries
  hPutStr file (unlines deliveryStrings)
  hClose file

-- loop for product add flow
continueAddPackages :: [Package] -> [Int] -> IO [Int]
continueAddPackages packages newPackagesIdList = do
  putStrLn "Deseja adicionar outro produto?"
  putStrLn "(s) sim (n) não"
  answer <- getLine
  if answer == "s"
  then do
    addPackagesToBag packages newPackagesIdList
  else if answer == "n"
  then do
    return newPackagesIdList
  else do
    putStrLn "Opcao invalida, tente novamente\n"
    continueAddPackages packages newPackagesIdList

-- add products to current delivery
addPackagesToBag :: [Package] -> [Int] -> IO [Int]
addPackagesToBag packages packagesIdList = do
  listPendingPackages packages
  putStrLn "Digite o código do pacote:"
  id <- getLine
  -- TODO: verificar se o código existe
  let newPackagesIdList = packagesIdList ++ [read id :: Int]
  putStrLn "Produto adicionado com sucesso!"
  continueAddPackages packages newPackagesIdList

-- create delivery
registerDelivery :: [Delivery] -> [Package] -> IO ()
registerDelivery deliveries packages = do
  let packagesIds = []
  packagesIds <- addPackagesToBag packages packagesIds
  let deliveryId = (length deliveries) + 1
  let delivery = Delivery deliveryId packagesIds "entregando"
  createFileFromDeliveries (deliveries ++ [delivery])

  -- update delivery's packages to in progress
  updatePackagesFromIds packages packagesIds "entregando";
  putStrLn "Entrega cadastrada!"

-- print single delivery
printDelivery :: Delivery -> IO ()
printDelivery (Delivery id packages status) = do
  let delivery = ("Identificador: " ++ (show id) ++ "\n" ++
                "Pacotes: " ++ (intercalate "," (map show packages)) ++ "\n" ++
                "Status: " ++ formatOutput status ++ "\n")
  putStrLn delivery

-- get deliveries quantity by status
countDeliveriesByStatus :: [Delivery] -> String -> IO()
countDeliveriesByStatus deliveries status  = do
  let count = length (filter (\(Delivery _ _ deliveryStatus) -> deliveryStatus == status) deliveries)
  putStrLn ("Quantidade de entregas com status " ++ status ++ ": " ++ (show count))

-- print multiple deliveries
printDeliveries :: Int -> Int -> [Delivery] -> IO ()
printDeliveries index len deliveries = do
  let delivery = deliveries !! index
  if index /= len
  then do
      printDelivery delivery
      printDeliveries (index + 1) len deliveries
  else do
      (countDeliveriesByStatus deliveries "entregando")
      (countDeliveriesByStatus deliveries "entregue")
      (countDeliveriesByStatus deliveries "falha")
      (countDeliveriesByStatus deliveries "cancelada")

-- initial listing deliveries function
listDeliveries :: [Delivery] -> IO ()
listDeliveries deliveries = do
  let len = length deliveries
  clearScreen
  putStrLn "======== STATUS ENTREGA ========"
  printDeliveries 0 len deliveries

-- update delivery status
updateDeliveryStatus :: [Delivery] -> [Package] -> Int -> String -> IO ()
updateDeliveryStatus deliveries packagesList id status = do
  -- update delivery status
  let (left,element:right) = splitAt (id - 1) deliveries
  let updatedDelivery = Delivery id (packages element) status
  let updatedDeliveries = left ++ [updatedDelivery] ++ right
  createFileFromDeliveries updatedDeliveries
  putStrLn ("Status da entrega " ++ (show id) ++ " alterado com sucesso para: " ++ status)

  -- update delivery's packages status
  updatePackagesFromIds packagesList (packages element) status;