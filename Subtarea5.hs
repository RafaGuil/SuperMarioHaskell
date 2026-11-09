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

--------------------------------------------------------------------------------------------------------------------------

-- Comprueba que el nivel tiene exactamente una meta; si no, devuelve el error correspondiente.
validarNivel :: NivelData -> Either ErrorNivel NivelData
validarNivel nivel 
    | nMetas == 0 = Left NivelSinMeta
    | nMetas > 1 = Left (NivelConVariasMetas nMetas)
    | otherwise = Right nivel  
    where
        nMetas = length (filter (== META) (concat (gridNivel nivel)))

--------------------------------------------------------------------------------------------------------------------------

-- 1. separar nivel, limpiar el nivel para comprobar que esta completo
separar :: [String] -> Either ErrorNivel ([String], [String])
separar lineas = case break (== "---") lineas of
    (_, []) -> Left (FormatoInvalido "Falta separador '---'") -- devuelve lista vacia es que falta el separador
    (_, ["_"]) -> Left (FormatoInvalido "No hay mapa ...") -- [_] solo hay un elemento en la lista que es el separador pero sin mapa
    (cabecera, _ : mapa) -> Right (cabecera, mapa) -- tenemos la priemra lista (cabecera) y la segunda que esta abierta _ primer elemento y el mapa

{-
buscarClave devuelve Maybe y parsearFichero Either. Creo funcion aux. para convertir Maybe en Either
-}

-- 2. Busca una clave en la cabecera y si no esta devuelve el error de formato
buscarOError :: String -> [String] -> Either ErrorNivel String
buscarOError clave cabecera = case buscarClave clave cabecera of
    Just valor -> Right valor
    Nothing -> Left (FormatoInvalido ("falta la clave '" ++ clave ++ "'"))

-- 3. buscaOError para "FONDOS: " devuelve el texto "1,2,3" pero NivelData pide una lista de Integer [1,2,3], hay que tranformarlo
leerFondos :: String -> Either ErrorNivel [Int]
leerFondos texto = case mapM readMaybe (splitOn ',' texto) of
    Just ns -> Right ns
    Nothing -> Left (FormatoInvalido "FONDOS contiene valores no numericos")

-- 4. Interpreta las lineas de un fichero de nivel o devuelve el primer error de formato
parsearFichero :: [String] -> Either ErrorNivel NivelData
parsearFichero lineas = do
    (cabecera, mapa) <- separar lineas
    nombre <- buscarOError "NOMBRE: " cabecera
    textosFondos <- buscarOError "FONDOS: " cabecera -- textosFondos = "1,2
    numeros <- leerFondos textosFondos              -- numeros = [1,2]
    return (NivelData nombre numeros (parsearGrid mapa))

--------------------------------------------------------------------------------------------------------------------------

-- Interpresa un fichero de nivel y comprueba que tiene exactamente una meta
parsearNivelCompleto :: [String] -> Either ErrorNivel NivelData
parsearNivelCompleto lineas = parsearFichero lineas >>= validarNivel

--------------------------------------------------------------------------------------------------------------------------

-- Bonus

-- Interpreta y valida una lista de niveles devolviendo todos o el primer error 
parsearNiveles :: [[String]] -> Either ErrorNivel [NivelData]
parsearNiveles ficheros = traverse parsearNivelCompleto ficheros -- traverse y mapM hacen lo mismo
