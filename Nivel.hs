module Nivel
    ( -- * Tipos de un nivel
      ErrorNivel(..)
    , DatosEnemigo(..)
    , NivelData(..)
      -- * Utilidades de texto (Subtarea 4, reutilizadas por Partida)
    , splitOn
    , buscarClave
      -- * Interpretación y validación (Subtarea 5)
    , parsearFichero
    , validarNivel
    , parsearNivelCompleto
      -- * Del mapa a los objetos (Subtarea 6A)
    , tamCelda
    , posicionCelda
    , gridAPlataformas
    , metasDesdeGrid
    , enemigosDesdeMatriz
      -- * Bonus
    , parsearNiveles
    , todasLasPosiciones
    ) where
-- No se exportan las auxiliares separar, buscarOError, leerFondos ni celdasConPosicion.

import Data.Array (elems)
import Data.List (stripPrefix)
import qualified Data.Map as Map
import Text.Read (readMaybe)

import Matriz (Matriz)
import Objeto (Enemigo(..), Meta(..), Plataforma(..))
import Tipos (BoundingBox, Celda(..), Grid, Vector2, esMeta)

-- Errores posibles al interpretar un nivel (dado en el enunciado).
data ErrorNivel
  = FormatoInvalido String
  | NivelSinMeta
  | NivelConVariasMetas Int
  | EnemigoDesconocido String
  | ErrorFichero String
  deriving (Eq, Show)

-- Lo declarado en la cabecera.
data DatosEnemigo = DatosEnemigo
  { idDatos      :: String
  , tipoSprite   :: String
  , periodoDatos :: Int
  , mortal       :: Bool
  , tamEnemigo   :: Vector2
  , offsetCaja   :: BoundingBox
  , patronDatos  :: [Vector2]
  } deriving (Eq, Show)

-- Datos de un nivel ya interpretado (dado en el enunciado).
data NivelData = NivelData
  { nombreNivel :: String
  , fondos      :: [Int]
  , matrizNivel :: Matriz
  , metaOffset  :: Vector2
  , enemigosData :: Map.Map String DatosEnemigo
  , tiposEnemigo :: [String]
  } deriving (Eq, Show)

--------------------------------------------------------------------------------------------------------------------------
-- Utilidades de texto (Subtarea 4)

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

--------------------------------------------------------------------------------------------------------------------------
-- Subtarea 5

-- Comprueba que el nivel tiene exactamente una meta; si no, devuelve el error correspondiente.
validarNivel :: NivelData -> Either ErrorNivel NivelData
validarNivel nivel
    | nMetas == 0 = Left NivelSinMeta
    | nMetas > 1 = Left (NivelConVariasMetas nMetas)
    | otherwise = Right nivel
    where
        nMetas = length (filter esMeta (elems (matrizNivel nivel)))

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

-- Como en la Tarea 3, pero ahora lee también META OFFSET: x,y, TIPOS DE ENEMIGO: t1, t2 y todas las líneas ENEMIGO k:.
-- Errores (FormatoInvalido): falta una clave obligatoria, FONDOS o META OFFSET no válidos, o un ENEMIGO k mal formado
-- (mensaje "ENEMIGO k mal formado").
parsearFichero :: [String] -> Either ErrorNivel NivelData
parsearFichero = undefined

-- Interpreta un fichero de nivel y comprueba que tiene exactamente una meta
parsearNivelCompleto :: [String] -> Either ErrorNivel NivelData
parsearNivelCompleto lineas = parsearFichero lineas >>= validarNivel

--------------------------------------------------------------------------------------------------------------------------
-- Subtarea 6A: del mapa a los objetos

-- Lado (en unidades del mundo) de cada celda cuadrada del mapa.
tamCelda :: Float
tamCelda = 40

-- Esquina inferior izquierda de la celda (fila i desde arriba, columna j) en un mapa de 'total' filas.
posicionCelda :: Int -> Int -> Int -> Vector2
posicionCelda total i j = (fromIntegral j * tamCelda, fromIntegral (total - 1 - i) * tamCelda)

-- Cada celda del mapa junto con la esquina de su posición en el mundo (auxiliar, no se exporta).
celdasConPosicion :: Grid -> [(Vector2, Celda)]
celdasConPosicion g =
  [ (posicionCelda (length g) i j, c) | (i, fila) <- zip [0 ..] g, (j, c) <- zip [0 ..] fila ]

-- Una plataforma de tamCelda x tamCelda por cada celda sólida del mapa.
gridAPlataformas :: Grid -> [Plataforma]
gridAPlataformas g = [ Plataforma (x, y, tamCelda, tamCelda) | ((x, y), Solido) <- celdasConPosicion g ]

-- Una meta en la esquina de cada celda META del mapa.
metasDesdeGrid :: Grid -> [Meta]
metasDesdeGrid g = [ Meta esquina | (esquina, META) <- celdasConPosicion g ]

-- Un Enemigo por cada celda InicioEnemigo id cuyo id esté en datos, numerados desde 0 en el orden del mapa.
-- Su centro está en (x + anchoBaldosa / 2, y + alto / 2) (alto = alto de su sprite); su velocidad inicial es la
-- primera del patrón (o (0,0) si es vacío); contador e indicePatron a 0; tiempoMuerte a Nothing; el resto, de sus datos.
enemigosDesdeMatriz :: Map.Map String DatosEnemigo -> Matriz -> Map.Map Int Enemigo
enemigosDesdeMatriz = undefined

--------------------------------------------------------------------------------------------------------------------------
-- Bonus

-- Interpreta y valida una lista de niveles devolviendo todos o el primer error
parsearNiveles :: [[String]] -> Either ErrorNivel [NivelData]
parsearNiveles ficheros = traverse parsearNivelCompleto ficheros -- traverse y mapM hacen lo mismo

-- Todas las posiciones (fila, columna) de una rejilla rectangular, en orden de filas.
todasLasPosiciones :: Grid -> [(Int, Int)]
todasLasPosiciones []         = []
todasLasPosiciones g@(fila:_) = (,) <$> [0 .. length g - 1] <*> [0 .. length fila - 1]  -- fila <*> columna
