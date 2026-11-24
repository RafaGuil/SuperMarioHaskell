module Sprites
  ( Sprites(..)
  , nombreFrame
  , cargarImagen
  , cargarSecuencia
  , cargarSprites
  , buscarFrames
  , elegirFrame
  ) where

import qualified Data.Map as Map
import Graphics.Gloss (Picture, blank)

import Nivel (NivelData)
import Tipos (Accion)

data Sprites = Sprites
  { acciones :: Map.Map String (Map.Map Accion [Picture])   -- entidad -> acción -> fotogramas
  , plataforma, fondo, meta :: [Picture] } deriving (Eq, Show)

-- Nombre del fotograma n: prefijo ++ número con 3 cifras ++ ".png".
nombreFrame :: FilePath -> Int -> FilePath
nombreFrame prefijo n = prefijo ++ replicate (3 - length s) '0' ++ s ++ ".png"
  where
    s = show n

-- Carga una imagen escalada al tamaño dado; Nothing si no existe o no es válida (pieza sin puntuación, pendiente).
cargarImagen :: FilePath -> Float -> Float -> IO (Maybe Picture)
cargarImagen = undefined

-- Carga prefijo001.png, prefijo002.png... hasta que falte uno.
cargarSecuencia :: FilePath -> Float -> Float -> IO [Picture]
cargarSecuencia prefijo ancho alto = desde 1
  where
    desde n = do
        mp <- cargarImagen (nombreFrame prefijo n) ancho alto
        case mp of
            Nothing -> return []
            Just p  -> (p :) <$> desde (n + 1)

-- Carga todos los sprites del nivel n (pieza sin puntuación, pendiente).
cargarSprites :: Int -> NivelData -> IO Sprites
cargarSprites = undefined

-- Fotogramas de una entidad en una acción, o [] si no existen.
buscarFrames :: String -> Accion -> Sprites -> [Picture]
buscarFrames clave accion s =
    Map.findWithDefault [] accion (Map.findWithDefault Map.empty clave (acciones s))

-- Fotograma floor fase de la lista, cíclicamente; blank si la lista es vacía.
elegirFrame :: Float -> [Picture] -> Picture
elegirFrame _ [] = blank
elegirFrame fase fs = fs !! (floor fase `mod` length fs)
