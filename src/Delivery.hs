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
  arq <- openFile "deliveries.txt" ReadMode
  fileContents <- hGetContents arq
  let readData [id, packages, status] = Delivery (read id :: Int) (map (read::String->Int) (splitOn "," packages)) status
  let deliveries = map words $ lines fileContents
  return (map readData deliveries)

deliveryToString :: Delivery -> String
deliveryToString (Delivery id packages status) =
  (show id) ++ " " ++ (intercalate "," (map show packages)) ++ " " ++ status

createFileFromDeliveries :: [Delivery] -> IO ()
createFileFromDeliveries deliveries = do
  arq <- openFile "deliveries.txt" WriteMode
  let deliveryStrings = map deliveryToString deliveries
  hPutStr arq (unlines deliveryStrings)
  hClose arq

-- Get the lenght of the lines in file delivery.txt as intenger
getDeliveryIdentifier :: IO Int
getDeliveryIdentifier = do
  file <- openFile "delivery.txt" ReadWriteMode
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


addPackagesToBag :: String -> IO ()
addPackagesToBag packages = do
    listPendingPackages
    putStrLn "Digite o código do pacote:"
    id <- getLine
    -- TODO verificar se o código existe
    let packagesIds = packages ++ id
    putStrLn "Produto adicionado com sucesso!"
    putStrLn "Deseja adicionar outro produto?"
    putStrLn "(s) sim (n) não"
    answer <- getLine
    if answer == "s"
    then do
        let parsedPackages = packagesIds ++ ","
        addPackagesToBag parsedPackages
    else do
        deliveryId <- getDeliveryIdentifier
        file <- openFile "delivery.txt" AppendMode
        let delivery = ("Identificador: " ++ (show deliveryId) ++ ";" ++
                      "Pacotes: " ++ packagesIds ++ ";" ++
                      "Status: " ++ "em rota de entrega" ++ "\n")
        hPutStr file delivery
        hClose file
        putStrLn "Entrega cadastrada!"


registerDelivery :: IO ()
registerDelivery = do
    let packages = ""
    addPackagesToBag packages
    

printDelivery :: Int -> Int -> [String] -> IO ()
printDelivery num len list = do
    let item = list !! num
    if num <= (len * 2)
    then do
        putStrLn item
        printDelivery (num + 1) len list
    else putStrLn ("Quantidade de entregas: " ++ (show len))

listDelivery :: IO ()
listDelivery = do
    arq <- openFile "delivery.txt" ReadMode
    fileContents <- hGetContents arq
    let deliverys = splitOn ";" fileContents
    let len = (length (lines fileContents))
    clearScreen
    putStrLn "======== STATUS ENTREGA ========"
    printDelivery 0 len deliverys
    hClose arq
