module Ranking
    ( mejorPorJugador
    , ranking
    ) where

import qualified Data.Map as M
import Data.List (sortOn)
import Data.Ord (Down(..))

import Partida (Entrada(..))

-- Diccionario con la mejor puntuación de cada jugador.
mejorPorJugador :: [Entrada] -> M.Map String Int
mejorPorJugador = foldr (\(Entrada n p) -> M.insertWith max n p) M.empty

-- Las n primeras entradas ordenadas por más puntos y, a igualdad, por nombre.
ranking :: Int -> M.Map String Int -> [Entrada]
ranking n m = take n (sortOn clave [Entrada nombre pts | (nombre, pts) <- M.toList m])
  where
    clave e = (Down (puntos e), nombreJugador e)
