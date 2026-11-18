module Sprites
  ( Sprites(..)
  ) where

import qualified Data.Map as Map
import Graphics.Gloss (Picture)

import Tipos (Accion)

data Sprites = Sprites
  { acciones :: Map.Map String (Map.Map Accion [Picture])   -- entidad -> acción -> fotogramas
  , plataforma, fondo, meta :: [Picture] } deriving (Eq, Show)
