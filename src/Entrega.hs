module Entrega where

import System.IO
import Data.List.Split (splitOn)
import System.Console.ANSI

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
