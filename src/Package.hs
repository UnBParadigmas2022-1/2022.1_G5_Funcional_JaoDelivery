module Package where

import System.IO
import Data.List.Split (splitOn)
import System.Console.ANSI
import Data.List

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
    let package = list !! num
    if num < len 
    then do
        let attributes = splitOn ";" package
        putStrLn  $ intercalate "\n" attributes ++ "\n\n"
        printList (num + 1) len list
    else putStrLn ("\n"++ "Quantidade de pacotes registrados: " ++ (show len)) -- fix this

listPackages :: IO ()
listPackages = do
    arq <- openFile "packages.txt" ReadMode
    fileContents <- hGetContents arq
    let packages = splitOn "\n" fileContents
    let len = (length (lines fileContents))
    clearScreen;
    putStrLn $ "======== TODOS OS PACOTES ========" ++ "\n\n"
    printList 0 len packages
    hClose arq


-- Get the lenght of the lines in file packages.txt as intenger
getIdentifier :: IO Int
getIdentifier = do
  contents <- readFile "packages.txt"
  return ((length $ lines contents) +1)


