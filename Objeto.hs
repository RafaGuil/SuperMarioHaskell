module Objeto
  ( LadoColision(..)
  , Objeto(..)
  , Plataforma(..)
  , Meta(..)
  , Enemigo(..)
  , solapan
  , colisionaCon
  , colisionaConAlguno
  , ladoColision
  , vivo
  , enemigosVivos
  ) where

import Tipos (Vector2, BoundingBox, sumaVectores, escalarVector)
import qualified Data.Map as Map
import Data.Maybe (isNothing)

-- Lado por el que colisiona la entidad A con la entidad B
data LadoColision = Abajo | Arriba | Izquierda | Derecha
  deriving (Eq, Show, Ord)

-- Clase de tipos para los objetos físicos del mundo
class Objeto a where
  posicion :: a -> Vector2
  boundingBox :: a -> BoundingBox
  animar :: Float -> a -> a
  animar _ x = x

-- Entidades del Nivel

-- Plataforma sólida del mapa (su caja AABB en la esquina inferior izquierda)
newtype Plataforma = Plataforma BoundingBox
  deriving (Eq, Show)

instance Objeto Plataforma where
  posicion (Plataforma (x, y, _, _)) = (x, y)
  boundingBox (Plataforma box) = box

-- Meta del nivel (caja de 70x80 con origen en la esquina inferior izquierda posMeta)
newtype Meta = Meta { posMeta :: Vector2 }
  deriving (Eq, Show)

instance Objeto Meta where
  posicion (Meta pos) = pos
  boundingBox (Meta (x, y)) = (x, y, 70.0, 80.0)

-- Enemigo del juego
data Enemigo = Enemigo
  { idEnemigo    :: String
  , posEnemigo   :: Vector2      -- Centro del enemigo
  , velEnemigo   :: Vector2
  , dimEnemigo   :: Vector2      -- (ancho, alto) del sprite
  , hitOffset    :: BoundingBox  -- (ox, oy, ow, oh) en fracciones del sprite
  , patronMov    :: [Vector2]    -- Lista cíclica de velocidades
  , periodoMov   :: Int          -- Fotogramas entre cambios de velocidad
  , contador     :: Int          -- Contador de fotogramas
  , indicePatron :: Int          -- Índice en el patrón
  , tiempoMuerte :: Maybe Float  -- Just t si murió en el instante t
  , puedeMorir   :: Bool
  } deriving (Eq, Show)

instance Objeto Enemigo where
  posicion = posEnemigo

  boundingBox e = (x - w / 2.0 + w * ox, y - h / 2.0 + h * oy, w * ow, h * oh)
    where
      (x, y) = posEnemigo e
      (w, h) = dimEnemigo e
      (ox, oy, ow, oh) = hitOffset e

  -- Anima el avance del enemigo según el tiempo y su patrón
  animar dt e
    | null (patronMov e) = e
    | contador e >= periodoMov e =
        let sigIdx   = (indicePatron e + 1) `mod` length (patronMov e)
            nuevaVel = patronMov e !! sigIdx
            nuevaPos = posEnemigo e `sumaVectores` escalarVector dt nuevaVel
        in e { posEnemigo   = nuevaPos
             , velEnemigo   = nuevaVel
             , contador     = 0
             , indicePatron = sigIdx
             }
    | otherwise =
        let nuevaPos = posEnemigo e `sumaVectores` escalarVector dt (velEnemigo e)
        in e { posEnemigo = nuevaPos, contador = contador e + 1 }

-- Colisiones y Utilidades

- Comprueba el solapamiento estricto de dos cajas
solapan :: BoundingBox -> BoundingBox -> Bool
solapan (x1, y1, w1, h1) (x2, y2, w2, h2) =
  x1 < x2 + w2 && x1 + w1 > x2 && y1 < y2 + h2 && y1 + h1 > y2

-- Indica si dos objetos colisionan
colisionaCon :: (Objeto a, Objeto b) => a -> b -> Bool
colisionaCon a b = solapan (boundingBox a) (boundingBox b)

- Comprueba si un objeto colisiona con alguno de una lista
colisionaConAlguno :: (Objeto a, Objeto b) => a -> [b] -> Bool
colisionaConAlguno obj = any (colisionaCon obj)

- Lado de B por el que choca A (en empates: Abajo, Arriba, Izquierda, Derecha)
ladoColision :: BoundingBox -> BoundingBox -> LadoColision
ladoColision (xA, yA, wA, hA) (xB, yB, wB, hB) =
  let penetracionAbajo     = (yA + hA) - yB
      penetracionArriba    = (yB + hB) - yA
      penetracionIzquierda = (xA + wA) - xB
      penetracionDerecha   = (xB + wB) - xA
      opciones =
        [ (penetracionAbajo, Abajo)
        , (penetracionArriba, Arriba)
        , (penetracionIzquierda, Izquierda)
        , (penetracionDerecha, Derecha)
        ]
  in snd $ foldl1 minOpcion opciones
  where
    minOpcion (d1, l1) (d2, l2)
      | d1 <= d2  = (d1, l1)
      | otherwise = (d2, l2)

- Un enemigo está vivo si no puede morir o si no tiene tiempoMuerte
vivo :: Enemigo -> Bool
vivo e = not (puedeMorir e) || isNothing (tiempoMuerte e)

- Filtra un Map conservando solo los enemigos vivos
enemigosVivos :: Map.Map Int Enemigo -> Map.Map Int Enemigo
enemigosVivos = Map.filter vivo