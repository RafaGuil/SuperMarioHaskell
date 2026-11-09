module Subtarea5 where

import Text.Read (readMaybe)
import Provisional   -- temporal: en el merge se cambia por los módulos del grupo

-- Errores posibles al interpretar un nivel (dado en el enunciado).
data ErrorNivel
  = FormatoInvalido String
  | NivelSinMeta
  | NivelConVariasMetas Int
  deriving (Eq, Show)

-- Datos de un nivel ya interpretado (dado en el enunciado).
data NivelData = NivelData
  { nombreNivel :: String
  , fondos      :: [Int]
  , gridNivel   :: Grid
  } deriving (Eq, Show)


-- Comprueba que el nivel tiene exactamente una meta; si no, devuelve el error correspondiente.
validarNivel :: NivelData -> Either ErrorNivel NivelData
validarNivel nivel 
    | nMetas == 0 = Left NivelSinMeta
    | nMetas > 1 = Left (NivelConVariasMetas nMetas)
    | otherwise = Right nivel  
    where
        nMetas = length (filter (== META) (concat (gridNivel nivel)))

-- separar nivel
separar :: [String] -> Either ErrorNivel ([String], [String])
separar lineas = case break (== "---") lineas of
    (_, []) -> Left (FormatoInvalido "Falta separador '---'") -- devuelve lista vacia es que falta el separador
    (_, ["_"]) -> Left (FormatoInvalido "No hay mapa ...") -- [_] solo hay un elemento en la lista que es el separador pero sin mapa
    (cabecera, _ : mapa) -> Right (cabecera, mapa) -- tenemos la priemra lista (cabecera) y la segunda que esta abierta _ primer elemento y el mapa