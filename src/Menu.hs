module Menu (menu) where

import System.IO
import Control.Monad
import System.Console.ANSI
import Produto
menu :: IO()
menu = do {
  clearScreen;
  putStrLn "========= SERVIÇO DE ENTREGA =========";
  putStrLn "1 - Produto";
  putStrLn "2 - Entrega";
  putStrLn "3 - Sair";

  option <- getLine;
  case option of
    "1" -> productMenu;
    "2" -> deliveryMenu;
    "3" -> putStrLn "Finalizando...";
}

productMenu :: IO()
productMenu = do {
  clearScreen;
  putStrLn "========= PRODUTO =========";
  putStrLn "1 - Cadastrar";
  putStrLn "2 - Verificar";
  putStrLn "3 - Calcular tempo de entrega";
  putStrLn "4 - Voltar";

  option <- getLine;
  case option of
    "1" -> registerProduct;
    "2" -> putStrLn "Verificar produto"; --TODO
    "3" -> putStrLn "Calculando tempo de entrega"; --TODO
    "4" -> menu;
}

deliveryMenu :: IO()
deliveryMenu = do {
  clearScreen;
  putStrLn "========= ENTREGA =========";
  putStrLn "1 - Cadastrar";
  putStrLn "2 - Verificar";
  putStrLn "3 - Calcular rota";
  putStrLn "4 - Finalizar entrega";
  putStrLn "5 - Voltar";

  option <- getLine;
  case option of
    "1" -> putStrLn "Cadastrar entrega"; --TODO
    "2" -> putStrLn "Verificar entrega"; --TODO
    "3" -> putStrLn "Calculando rota de entrega"; --TODO
    "4" -> deliveryFinishMenu;
    "5" -> menu;
}

deliveryFinishMenu :: IO()
deliveryFinishMenu = do {
  clearScreen;
  putStrLn "========= FINALIZAR ENTREGA =========";
  putStrLn "1 - Sucesso";
  putStrLn "2 - Falha";
  putStrLn "3 - Voltar";

  option <- getLine;
  case option of
    "1" -> putStrLn "Sucesso!"; --TODO
    "2" -> putStrLn "Falha!"; --TODO
    "3" -> deliveryMenu;
}