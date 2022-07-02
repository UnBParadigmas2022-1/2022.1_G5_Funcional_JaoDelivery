module Package where

import System.IO
import Data.List.Split (splitOn)
import System.Console.ANSI
import Data.Char (chr)
import System.Console.ANSI

registerPackage :: IO ()
registerPackage = do
    clearScreen;
    putStrLn "Digite o nome do destinatário:"
    destinatario <- getLine
    putStrLn "Digite o nome do remetente:"
    remetente <- getLine
    putStrLn "Digite o endereço do destinatário:"
    endereco <- getLine
    identifier <- getIdentifier
    putStr "Identificador do pacote: " 
    putStrLn $ show identifier

    let package = ("Identificador: " ++ (show identifier) ++ ";"++ 
                 "Destinatário: " ++ destinatario ++ ";" ++ 
                 "Remetente: " ++ remetente ++ ";" ++ 
                 "Endereço: " ++ endereco ++ ";" ++
                 "Status: pendente" ++ "\n")
    arq <- openFile "packages.txt" AppendMode
    hPutStr arq package
    hClose arq
    putStrLn "Pacote cadastrado com sucesso!"

printList :: Int -> Int -> [String] -> IO ()
printList num len list = do
    let item = list !! num
    if num <= (len * 2)
    then do
        putStrLn item
        printList (num + 1) len list
    else putStrLn ("Quantidade de pacotes: " ++ (show len))

listPackages :: IO ()
listPackages = do
    arq <- openFile "packages.txt" ReadMode
    fileContents <- hGetContents arq
    let packages = splitOn ";" fileContents
    let len = (length (lines fileContents))
    clearScreen;
    putStrLn "======== TODOS OS PACOTES PARA ENTREGA ========"
    printList 0 len packages
    hClose arq


-- Get the lenght of the lines in file packages.txt as intenger
getIdentifier :: IO Int
getIdentifier = do
  contents <- readFile "packages.txt"
  return ((length $ lines contents) +1)


