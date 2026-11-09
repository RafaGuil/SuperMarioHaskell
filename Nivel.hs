module Nivel 
    ( splitOn
    , buscarClave
    ) where

import Data.List (stripPrefix)

-- Divide una cadena utilizando un carácter separador dado.
splitOn :: Char -> String -> [String]
splitOn c s = case break (== c) s of
  (a, [])  -> [a]
  (a, _:b) -> a : splitOn c b

-- Busca la clave y devuelve el resto de la primera línea que encaje usando stripPrefix.
buscarClave :: String -> [String] -> Maybe String
buscarClave _ [] = Nothing
buscarClave clave (x:xs) = case stripPrefix clave x of
    Just resto -> Just resto
    Nothing    -> buscarClave clave xs