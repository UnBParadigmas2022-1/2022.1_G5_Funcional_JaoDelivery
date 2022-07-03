module Menu (
  menu,
  packageMenu
) where

import System.IO
import Control.Monad
import System.Console.ANSI
import Package
import Delivery

menu :: IO()
menu = do {
  clearScreen;
  putStrLn "========= SERVIÇO DE ENTREGA =========";
  putStrLn "1 - Pacote";
  putStrLn "2 - Entrega";
  putStrLn "3 - Sair";

  option <- getLine;
  case option of
    "1" -> packageMenu;
    "2" -> deliveryMenu;
    "3" -> putStrLn "Finalizando...";
}

packageMenu :: IO()
packageMenu = do {
  clearScreen;

  packages <- readPackagesFromFile;
  putStrLn "========= PACOTE =========";
  putStrLn "1 - Cadastrar";
  putStrLn "2 - Verificar";
  putStrLn "3 - Calcular rota de entrega";
  putStrLn "4 - Voltar";
  option <- getLine;

  case option of
    "1" -> registerPackage packages;
    "2" -> listPackages packages;
    "3" -> putStrLn "Calculando rota de entrega"; --TODO
    "4" -> menu;
}

deliveryMenu :: IO()
deliveryMenu = do {
  clearScreen;

  deliveries <- readDeliveriesFromFile;
  packages <- readPackagesFromFile;
  
  putStrLn "========= ENTREGA =========";
  putStrLn "1 - Cadastrar";
  putStrLn "2 - Verificar";
  putStrLn "3 - Finalizar entrega";
  putStrLn "4 - Voltar";

  option <- getLine;
  case option of
    "1" -> registerDelivery deliveries packages;
    "2" -> listDeliveries deliveries;
    "3" -> deliveryFinishMenu;
    "4" -> menu;
}

deliveryFinishMenu :: IO()
deliveryFinishMenu = do {
  clearScreen;
  putStrLn "========= FINALIZAR ENTREGA =========";
  putStrLn "1 - Sucesso";
  putStrLn "2 - Falha";
  putStrLn "3 - Cancelar";
  putStrLn "4 - Voltar";

  option <- getLine;
  case option of
    "1" -> putStrLn "Sucesso!"; --TODO
    "2" -> putStrLn "Falha!"; --TODO
    "3" -> putStrLn "Cancelar.!"; --TODO
    "4" -> deliveryMenu;
}