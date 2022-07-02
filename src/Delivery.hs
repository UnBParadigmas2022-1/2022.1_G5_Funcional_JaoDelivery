module Delivery where

import System.IO
import Data.List.Split (splitOn)
import System.Console.ANSI
import Data.List

import Package

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
    
    
registerDelivery :: IO ()
registerDelivery = do
    arq <- openFile "delivery.txt" AppendMode
    listPendingPackages
    putStrLn "Digite o código do pacote:"
    codigo <- getLine
    -- TODO verificar se código existe e está com status pendente
    let entrega = "Código: " ++ codigo ++ ";" ++ "Status da Entrega: Em Progresso\n"
    hPutStr arq entrega
    hClose arq
    putStrLn "Processo de Entrega cadastrada com sucesso!"
      -- else
      --   putStrLn "Produto não existe\n"
    putStrLn "Deseja entregar outro produto?"
    putStrLn "(s) sim (n) não"
    answer <- getLine
    if answer == "s"
    then registerDelivery
    else putStrLn ("Entrega cadastrada!")
    

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