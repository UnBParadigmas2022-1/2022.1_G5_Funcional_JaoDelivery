module Produto where

import System.IO

registerProduct :: IO ()
registerProduct = do
    arq <- openFile "products.txt" AppendMode
    putStrLn "Digite o nome do produto:"
    nome <- getLine
    putStrLn "Digite o preço do produto:"
    preco <- getLine
    putStrLn "Digite a quantidade do produto:"
    quantidade <- getLine
    let produto = nome ++ ";" ++ preco ++ ";" ++ quantidade ++ "\n"
    hPutStr arq produto
    hClose arq
    putStrLn "Produto cadastrado com sucesso!"