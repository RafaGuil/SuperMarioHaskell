module Matriz
  ( Pos
  , Matriz
  , gridAMatriz
  , matrizAGrid
  , dimensiones
  , celdaEn
--   , vecinos
--   , posicionesDe
--   , conteoPorFila
--   , distancias
--   , metaAlcanzable
--   , posicionMundo
  ) where

import Data.Array
import qualified Data.Map as M

import qualified Cola as C
import Tipos (Celda(..), Grid, Vector2, esSolido, esMeta, anchoBaldosa, altoBaldosa, yBaseNivel, parsearGrid)

type Pos    = (Int, Int)            -- (fila, columna); la esquina superior izquierda es (0,0)
type Matriz = Array Pos Celda

-- Convierte un grid en una matriz
gridAMatriz :: Grid -> Matriz
gridAMatriz g = listArray ((0,0),(f-1,c-1)) (concatMap completar g) -- Se usa los limites del enunciado
  where
    f = length g -- Numero de listas del grid
    c = maximum (0 : map length g) -- Longitud de la lista más grande
    completar fila = take c (fila ++ repeat Vacio) -- Rellena con Vacio hasta medir c

-- Convierte una matriz a grid
matrizAGrid :: Matriz -> Grid
matrizAGrid m = [[ m ! (i, j) | j <- [c0 .. c1] ] | i <- [f0 .. f1]] -- Se mete en una lista lo que hay en (0,0), luego en (0,1)...
  where 
    ((f0, c0), (f1, c1)) = bounds m -- bounds m devuelve esto: ((filaInicial, colInicial), (filaFinal, colFinal))

-- Dimensiones de la matriz
dimensiones :: Matriz -> (Int, Int)
dimensiones m = (f1+1, c1+1)
  where
    ((_, _), (f1, c1)) = bounds m -- bounds m devuelve esto: ((filaInicial, colInicial), (filaFinal, colFinal))

-- Celda en tal posicion
celdaEn :: Matriz -> Pos -> Maybe Celda
celdaEn m p
  | inRange (bounds m) p = Just (m ! p)
  | otherwise            = Nothing

-- Se miran los vecinos que no son solidos
vecinos :: Matriz -> Pos -> [Pos]
vecinos m (i, j) = filter libre [(i - 1, j), (i + 1, j), (i, j - 1), (i, j + 1)]
  where libre p = inRange (bounds m) p && not (esSolido (m ! p))

-- Posiciones de las celdas que cumplen una propiedad
posicionesDe :: (Celda -> Bool) -> Matriz -> [Pos]
posicionesDe prop m = [ p | (p, c) <- assocs m, prop c ] -- Si cumple prop c, se hace la tupla con (posicion, tipoCelda) y se devuelve la posicion (fila, columna) 

-- Número de celdas sólidas de cada fila.
conteoPorFila :: Matriz -> Array Int Int
conteoPorFila m = accumArray (+) 0 (f0, f1) [ (i, 1) | ((i, _), c) <- assocs m, esSolido c ] -- Se devuelve una lista de tuplas con (Fila, num solidos)
  where ((f0, _), (f1, _)) = bounds m