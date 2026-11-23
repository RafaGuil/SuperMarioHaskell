module Matriz
  ( Pos
  , Matriz
  , gridAMatriz
--   , matrizAGrid
--   , dimensiones
--   , celdaEn
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

