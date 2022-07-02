module Delivery where

import System.IO
import Data.List.Split (splitOn)
import System.Console.ANSI

import Package

-- productExists :: [String] -> Bool ()
--   productExists codigo= do
--     arq <- openFile "products.txt" ReadMode
--     return text =~ "Código " ++ codigo


registerDelivery :: IO ()
registerDelivery = do
    arq <- openFile "delivery.txt" AppendMode
    putStrLn "Digite o código da compra:"
    codigo <- getLine
      -- if productExists codigo
      -- then do
    putStrLn "Digite o endereço de entrega:"
    endereco <- getLine
    let entrega = "Endereço: " ++ endereco ++ ";" ++ "Código: " ++ codigo ++ ";" ++ "Status da Entrega: Em Progresso\n"
    hPutStr arq entrega
    hClose arq
    putStrLn "Processo de Entrega cadastrada com sucesso!"
      -- else
      --   putStrLn "Produto não existe\n"

printList :: Int -> Int -> [String] -> IO ()
printList num len list = do
    let item = list !! num
    if num <= (len * 2)
    then do
        putStrLn item
        printList (num + 1) len list
    else putStrLn ("Quantidade de entregas: " ++ (show len))

listDelivery :: IO ()
listDelivery = do
    arq <- openFile "delivery.txt" ReadMode
    fileContents <- hGetContents arq
    let deliverys = splitOn ";" fileContents
    let len = (length (lines fileContents))
    clearScreen
    putStrLn "======== STATUS ENTREGA ========"
    printList 0 len deliverys
    hClose arq