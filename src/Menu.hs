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
  packages <- readPackagesFromFile;
  clearScreen;
  
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
  deliveries <- readDeliveriesFromFile;
  packages <- readPackagesFromFile;
  clearScreen;
  
  putStrLn "========= ENTREGA =========";
  putStrLn "1 - Cadastrar";
  putStrLn "2 - Verificar";
  putStrLn "3 - Finalizar entrega";
  putStrLn "4 - Voltar";

  option <- getLine;
  case option of
    "1" -> registerDelivery deliveries packages;
    "2" -> listDeliveries deliveries;
    "3" -> deliveryFinishMenu deliveries packages;
    "4" -> menu;
}

deliveryFinishMenu :: [Delivery] -> [Package] -> IO()
deliveryFinishMenu deliveries packages = do {
  clearScreen;

  putStrLn ("Digite o código da entrega:");
  id <- getLine;
  -- TODO: verificar se o código existe
  putStrLn "========= FINALIZAR ENTREGA =========";
  putStrLn "1 - Sucesso";
  putStrLn "2 - Falha";
  putStrLn "3 - Cancelar";
  putStrLn "4 - Voltar";

  option <- getLine;
  case option of
    "1" -> updateDeliveryStatus deliveries packages (read id :: Int) "sucesso";
    "2" -> updateDeliveryStatus deliveries packages (read id :: Int) "falha";
    "3" -> updateDeliveryStatus deliveries packages (read id :: Int) "cancelada";
    "4" -> deliveryMenu;
}