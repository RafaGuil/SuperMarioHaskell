module Matriz
  ( Pos
  , Matriz
  ) where

import Data.Array (Array)

import Tipos (Celda)

type Pos    = (Int, Int)            -- (fila, columna); la esquina superior izquierda es (0,0)
type Matriz = Array Pos Celda
