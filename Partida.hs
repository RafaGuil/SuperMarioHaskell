module Partida 
    ( Partida(..)
    , Entrada(..)
    , serializarPartida
    , parsearPartida
    , parsearEntrada
    , parsearLeaderboard
    , mejoresPuntuaciones
    ) where

import Nivel (buscarClave, splitOn)
import Text.Read (readMaybe)
import Data.List (sortOn)
import Data.Ord (Down(..))

-- Representa una partida guardada con el nivel, vidas y puntuación actuales.
data Partida = Partida
  { nivelGuardado      :: Int
  , vidasGuardadas     :: Int
  , puntuacionGuardada :: Int
  } deriving (Eq, Show)

-- Representa un registro individual en la tabla de clasificación (leaderboard).
data Entrada = Entrada 
  { nombreJugador :: String
  , puntos        :: Int 
  } deriving (Eq, Show)

-- Serializa los datos de una partida convirtiéndolos a una lista de cadenas con formato de clave-valor.
serializarPartida :: Partida -> [String]
serializarPartida p =
  [ "NIVEL: " ++ show (nivelGuardado p)
  , "VIDAS: " ++ show (vidasGuardadas p)
  , "PUNTUACION: " ++ show (puntuacionGuardada p)
  ]

-- Interpreta una partida guardada a partir de líneas de texto usando la mónada Maybe y notación do.
parsearPartida :: [String] -> Maybe Partida
parsearPartida lineas = do
    nivelStr  <- buscarClave "NIVEL: " lineas
    nivel     <- readMaybe nivelStr
    vidasStr  <- buscarClave "VIDAS: " lineas
    vidas     <- readMaybe vidasStr
    puntosStr <- buscarClave "PUNTUACION: " lineas
    puntos    <- readMaybe puntosStr
    return (Partida nivel vidas puntos)

-- Convierte una línea de texto con formato "nombre;puntos" en una Entrada validando campos.
parsearEntrada :: String -> Maybe Entrada
parsearEntrada linea = case splitOn ';' linea of
    [nombre, puntosStr] | not (null nombre) -> do
        pts <- readMaybe puntosStr
        return (Entrada nombre pts)
    _ -> Nothing

-- Parsea un conjunto de líneas de leaderboard ignorando las vacías y controlando errores con mapM.
parsearLeaderboard :: [String] -> Maybe [Entrada]
parsearLeaderboard lineas = mapM parsearEntrada (filter (not . null) lineas)

-- Devuelve las 'n' mejores puntuaciones ordenadas de mayor a menor utilizando sortOn y Down.
mejoresPuntuaciones :: Int -> [Entrada] -> [Entrada]
mejoresPuntuaciones n entradas = take n (sortOn (Down . puntos) entradas)