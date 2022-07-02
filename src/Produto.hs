module Produto where

import System.IO
import Data.List.Split (splitOn)
import System.Console.ANSI

registerProduct :: IO ()
registerProduct = do
    arq <- openFile "products.txt" AppendMode
    putStrLn "Digite o nome do produto:"
    nome <- getLine
    putStrLn "Digite o preço do produto:"
    preco <- getLine
    putStrLn "Digite a quantidade do produto:"
    quantidade <- getLine
    let produto = "Produto: " ++ nome ++ ";" ++ "Preco: " ++ preco ++ ";" ++ "Qtd: " ++ quantidade ++ "\n"
    hPutStr arq produto
    hClose arq
    putStrLn "Produto cadastrado com sucesso!"

printList :: Int -> Int -> [String] -> IO ()
printList num len list = do
    let item = list !! num
    if num <= (len * 2)
    then do
        putStrLn item
        printList (num + 1) len list
    else putStrLn ("Quantidade de produtos: " ++ (show len))

listProducts :: IO ()
listProducts = do
    arq <- openFile "products.txt" ReadMode
    fileContents <- hGetContents arq
    let products = splitOn ";" fileContents
    let len = (length (lines fileContents))
    clearScreen;
    putStrLn "======== TODOS OS PRODUTOS PARA ENTREGA ========"
    printList 0 len products
    hClose arq
