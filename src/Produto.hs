module Produto where

import System.IO
import Data.List.Split (splitOn)

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

printList :: Int -> [String] -> IO ()
printList num list = do
    let item = list !! num
    if num <= 2
    then do
        putStrLn item
        printList (num + 1) list
    else putStrLn "Todos os produtos listados!"

listProducts :: IO ()
listProducts = do
    arq <- openFile "products.txt" ReadMode
    fileContents <- hGetContents arq
    let products = splitOn ";" fileContents
    printList 0 products
    hClose arq
