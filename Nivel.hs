module Nivel where

import Objeto (Enemigo(..), Meta(..), Plataforma(..))
import Tipos (Celda(..), Grid, TipoEnemigo(..), Vector2)

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

-- 1. Separar la cabecera del mapa por la linea "---" o da error
separar :: [String] -> Either ErrorNivel ([String], [String])
separar lineas = case break (== "---") lineas of
    (_, []) -> Left (FormatoInvalido "falta el separador '---'") -- devuelve lista vacia es que falta el separador
    (_, [_]) -> Left (FormatoInvalido "No hay mapa tras el separador ...") -- [_] solo hay un elemento en la lista que es el separador pero sin mapa
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

-- Interpreta un fichero de nivel y comprueba que tiene exactamente una meta
parsearNivelCompleto :: [String] -> Either ErrorNivel NivelData
parsearNivelCompleto lineas = parsearFichero lineas >>= validarNivel

--------------------------------------------------------------------------------------------------------------------------

-- Bonus

-- Interpreta y valida una lista de niveles devolviendo todos o el primer error 
parsearNiveles :: [[String]] -> Either ErrorNivel [NivelData]
parsearNiveles ficheros = traverse parsearNivelCompleto ficheros -- traverse y mapM hacen lo mismo


-- Todas las posiciones (fila, columna) de una rejilla rectangular, en orden de filas.
todasLasPosiciones :: Grid -> [(Int, Int)]
todasLasPosiciones []         = []
todasLasPosiciones g@(fila:_) = (,) <$> [0 .. length g - 1] <*> [0 .. length fila - 1]  -- fila <*> columna


-- Lee un número entero de la línea que empieza por la clave, si existe y es válido. (Aux)
leerNumero :: String -> [String] -> Maybe Int
leerNumero clave ls = buscarClave clave ls >>= readMaybe

-- Lee una partida guardada construyendo Partida en estilo aplicativo.
parsearPartidaA :: [String] -> Maybe Partida
parsearPartidaA ls = Partida <$> leerNumero "NIVEL: " ls <*> leerNumero "VIDAS: " ls <*> leerNumero "PUNTUACION: " ls



-- Suma los puntos de una tabla de puntuaciones válida.
puntuacionTotal :: [String] -> Maybe Int
puntuacionTotal ls = sum . map puntos <$> parsearLeaderboard ls
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
